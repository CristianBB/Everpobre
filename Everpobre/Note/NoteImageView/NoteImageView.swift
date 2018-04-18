//
//  NoteImageView.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 16/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol
protocol NoteImageViewDelegate: class {
    func didMove()
    func didRotate()
    func didScale()
    func requestRemove(noteImageView: NoteImageView)
}

// MARK: - Class Definition
class NoteImageView: UIImageView {

    // MARK: - Properties
    var model: imageCoreDataDummy
    weak var delegate: NoteImageViewDelegate?
    
    private var relativePoint: CGPoint!
    
    // MARK: - Init
    init(model: imageCoreDataDummy) {
        self.model = model
        super.init(image: model.image)
        
        self.contentMode = UIViewContentMode.scaleAspectFit
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func syncModelWithView() {
        self.image = model.image
        self.frame = CGRectFromString(model.actualFrame)
    }
    
}

// MARK: - Overrides
extension NoteImageView {
    
    // Rounded corner
    override func layoutSubviews() {
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
    }
    
}

// MARK: - Custom Methods
extension NoteImageView {
    
    // Returns a rectangle around the view for exclusion path purposes
    var marginRect:CGRect {
        get {
            return self.frame.insetBy(dx: -10, dy: -10)
        }
    }
    
    // Forces View position inside TextView received
    func fixFramePositionIn(_ containerTextView: UITextView) {
        var actualFrame = self.frame
        
        if (actualFrame.maxX > containerTextView.frame.width) {
            let differX = actualFrame.maxX - containerTextView.frame.width
            actualFrame = CGRect(x: actualFrame.origin.x - differX, y: actualFrame.origin.y, width: actualFrame.width, height: actualFrame.height)
        }
        
        if (actualFrame.maxY > containerTextView.contentSize.height && actualFrame.maxY > containerTextView.frame.height) {
            containerTextView.text.append("\n")
        }
        
        if (actualFrame.minX < 0.0) {
            actualFrame = CGRect(x: 0.0, y: actualFrame.origin.y, width: actualFrame.width, height: actualFrame.height)
        }
        
        if (actualFrame.minY < 0.0) {
            actualFrame = CGRect(x: actualFrame.origin.x, y: 0.0, width: actualFrame.width, height: actualFrame.height)
        }
        
        self.frame = actualFrame
    }
    
    // Configure Gesture Recognizers to Activate Edition Mode
    func activateEditionMode() {
        // Sets border to identify edition mode
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.red.cgColor
        
        // Add swipeGesture to rotate image to right
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRotateImage))
        swipeGestureRight.direction = .right
        self.addGestureRecognizer(swipeGestureRight)
        
        // Add swipeGesture to rotate image to left
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeRotateImage))
        swipeGestureLeft.direction = .left
        self.addGestureRecognizer(swipeGestureLeft)
        
        // Add swipeGesture to delete image
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDeleteImage))
        swipeGestureDown.direction = .down
        self.addGestureRecognizer(swipeGestureDown)
        
        // Add swipeGesture to scale image
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchScaleImage))
        self.addGestureRecognizer(pinchGesture)
    }
    
    // Remove Gesture Recognizers to Deactivate Edition Mode
    func deactivateEditionMode() {
        self.gestureRecognizers?.forEach((self.removeGestureRecognizer(_:)))
        self.layer.borderWidth = 0
    }
    
    // Move the View
    func moveImage(longPressGesture:UILongPressGestureRecognizer, contextView: UIView) {
        
        switch longPressGesture.state {
        case .began:
            self.layer.borderWidth = 1.5
            self.layer.borderColor = UIColor.green.cgColor
            relativePoint = longPressGesture.location(in: self)
            
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            })
            
        case .changed:
            let locationPress = longPressGesture.location(in: contextView)
            
            let locationY = locationPress.y - relativePoint.y
            let locationX = locationPress.x - relativePoint.x
            
            let newPositionRect = CGRect(x: locationX, y: locationY, width: self.frame.size.width, height: self.frame.size.height)
            
            self.frame = newPositionRect
            
        case .ended, .cancelled:
            self.layer.borderWidth = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            
            // Update Model
            model.actualFrame = NSStringFromCGRect(self.frame)
            syncModelWithView()
            
        default:
            break
        }
    
        // Notify Delegate
        delegate?.didMove()
    }
}


// MARK: - Gestures
extension NoteImageView {
    
    // SwipeGesture Left/Right: Rotate image on gesture direction
    @objc func swipeRotateImage(swipeGesture: UISwipeGestureRecognizer) {
        
        var degrees: CGFloat
        if (swipeGesture.direction == .right) {
            degrees = 90
        } else {
            degrees = -90
        }
    
        //Calculate the size of the rotated view's containing box for our drawing space
        let oldImage = model.image
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Calculates new Actual Frame
        let oldActualFrame = CGRectFromString(model.actualFrame)
        let newActualFrame = CGRect(x: oldActualFrame.origin.x, y: oldActualFrame.origin.y, width: newImage.size.width, height: newImage.size.height)
        
        // Calculates new Original Frame
        let oldOriginalFrame = CGRectFromString(model.actualFrame)
        let newOriginalFrame = CGRect(x: oldOriginalFrame.origin.x, y: oldOriginalFrame.origin.y, width: newImage.size.width, height: newImage.size.height)
        
        // Update model
        model.image = newImage
        model.actualFrame = NSStringFromCGRect(newActualFrame)
        model.originalFrame = NSStringFromCGRect(newOriginalFrame)
        syncModelWithView()
        
        // Notify Delegate
        delegate?.didMove()
    }
    
    
    // SwipeGesture Down: Remove image request
    @objc func swipeDeleteImage(swipeGesture: UISwipeGestureRecognizer) {
        
        if (swipeGesture.state == .ended) {
            self.delegate?.requestRemove(noteImageView: self)
        }
    }
    
    // PinchGesture: Scale image
    @objc func pinchScaleImage(pinchGesture: UIPinchGestureRecognizer) {
        
        if (pinchGesture.state == .ended || pinchGesture.state == .changed) {
            let originalRect = CGRectFromString(model.originalFrame)
            let actualRect = CGRectFromString(model.actualFrame)
            let currentScale = actualRect.width / originalRect.width
            var newScale:CGFloat = currentScale * pinchGesture.scale;
            
            if (newScale < 0.7) {
                newScale = 0.7;
            }
            
            if (newScale > 1.5) {
                newScale = 1.5;
            }
            
            let newPosition = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: originalRect.width * newScale, height: originalRect.height * newScale)
            
            pinchGesture.scale = 1;
            
            // Update model
            model.actualFrame = NSStringFromCGRect(newPosition)
            syncModelWithView()
            
            // Notify Delegate
            delegate?.didMove()
        }
        
    }
    
}
