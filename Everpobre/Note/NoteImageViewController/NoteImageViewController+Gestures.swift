//
//  NoteImageViewController+Gestures.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 20/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

// MARK: - Gestures
extension NoteImageViewController {

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
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: model.actualFrame.size.width, height: model.actualFrame.size.height))
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
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -model.actualFrame.size.width / 2, y: -model.actualFrame.size.height / 2, width: model.actualFrame.size.width, height: model.actualFrame.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Calculates new Actual Frame
        let oldActualFrame = model.actualFrame
        let newActualFrame = CGRect(x: oldActualFrame.origin.x, y: oldActualFrame.origin.y, width: newImage.size.width, height: newImage.size.height)
        
        // Calculates new Original Frame
        let oldOriginalFrame = model.actualFrame
        let newOriginalFrame = CGRect(x: oldOriginalFrame.origin.x, y: oldOriginalFrame.origin.y, width: newImage.size.width, height: newImage.size.height)
        
        // Update model
        model.image = newImage
        model.actualFrame = newActualFrame
        model.originalFrame = newOriginalFrame
        syncModelWithView()
        
        // Notify Delegate
        delegate?.didChange(noteImage: model)
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
            let originalRect = model.originalFrame
            let actualRect = model.actualFrame
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
            model.actualFrame = newPosition
            syncModelWithView()
            
            // Notify Delegate
            delegate?.didChange(noteImage: model)
        }
        
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
            model.actualFrame = self.frame
            syncModelWithView()
            
        default:
            break
        }
        
        // Notify Delegate
        delegate?.didChange(noteImage: model)
    }
    
}
