//
//  NoteImageView.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 16/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol
protocol NoteImageViewControllerDelegate: class {
    func didChange(noteImage: NoteImage)
    func requestRemove(noteImageView: NoteImageViewController)
}

// MARK: - Class Definition
class NoteImageViewController: UIImageView {

    // MARK: - Properties
    var model: NoteImage
    weak var delegate: NoteImageViewControllerDelegate?
    var relativePoint: CGPoint!
    
    // MARK: - Init
    init(model: NoteImage) {
        self.model = model
        super.init(image: model.image)
        
        self.contentMode = UIViewContentMode.scaleAspectFit
        self.isUserInteractionEnabled = true
        syncModelWithView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func syncModelWithView() {
        self.image = model.image
        self.frame = model.actualFrame
    }
    
}

// MARK: - Overrides
extension NoteImageViewController {
    
    // Rounded corner
    override func layoutSubviews() {
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
    }
    
}

// MARK: - Custom Methods
extension NoteImageViewController {
    
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
    
    
}


