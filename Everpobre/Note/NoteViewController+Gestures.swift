//
//  NoteViewController+Gestures.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 20/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

// MARK: - Gestures
extension NoteViewController {
    
    // Swipe Down View: Close keyboard/datepicker
    @objc func closeKeyboard() {
        if (titleTextField.isFirstResponder) {
            titleTextField.resignFirstResponder()
        } else if (endDateSky.isFirstResponder) {
            endDateSky.resignFirstResponder()
        } else if (tagsWST.isEditing) {
            tagsWST.endEditing()
        } else if (noteTextView.isFirstResponder) {
            noteTextView.resignFirstResponder()
        }
    }
    
    // DoubleTapGesture: Initialize image edition mode
    @objc func doubleTapGesture(tapGesture:UITapGestureRecognizer) {
        
        // Check if gesture was released on a NoteImageViewController, iterate until last subview cause we want the last NoteImageViewController
        var imageViewFound: NoteImageViewController?
        for subview in noteTextView.subviews {
            if let noteImageView = subview as? NoteImageViewController {
                if (noteImageView.frame.contains(tapGesture.location(in: noteTextView))) {
                    imageViewFound = noteImageView
                }
            }
        }
        
        if let imageViewFound = imageViewFound {
            // Activate Edition Mode
            if (gestureActive == .noActive) {
                imageViewFound.activateEditionMode()
                
                gestureActive = .editImage
                imageEdited = imageViewFound
                noteTextView.isScrollEnabled = false
                return
                
                // Deactivate Edition Mode
            } else if (imageEdited == imageViewFound) {
                deactivateEdition()
                return
            }
        }
    }
    
    // Deactivate any pending gesture action
    func deactivateEdition() {
        if (gestureActive == .editImage) {
            imageEdited?.deactivateEditionMode()
            gestureActive = .noActive
            noteTextView.isScrollEnabled = true
        }
    }
    
    // LongPressGesture
    @objc func longPressGesture(longPressGesture:UILongPressGestureRecognizer) {
        
        if (gestureActive == .noActive) {
            // Check if gesture was released on a NoteImageViewController
            for subview in noteTextView.subviews {
                if let noteImageView = subview as? NoteImageViewController {
                    if (noteImageView.frame.contains(longPressGesture.location(in: noteTextView))) {
                        gestureActive = .imagePressed
                        imageEdited = noteImageView
                    }
                }
            }
            
            // If not, Check if gesture was released on noteTextView
                if (gestureActive == .noActive && noteTextView.frame.contains(longPressGesture.location(in: self.view))) {
                gestureActive = .notePressed
            }
        }
        
        if (gestureActive == .imagePressed) {
            if (longPressGesture.state == .began) { closeKeyboard() }
            if (longPressGesture.state == .ended || longPressGesture.state == .cancelled) { gestureActive = .noActive }
            imageEdited?.moveImage(longPressGesture: longPressGesture, contextView: noteTextView)
        } else if (gestureActive == .notePressed) {
            addElement(longPressGesture: longPressGesture)
        }
        
    }
    
    // LongPressGesture on noteTextView: User selects and action for element addition
    func addElement(longPressGesture:UILongPressGestureRecognizer) {
        
        if (longPressGesture.state == .began) {
            // Save longPressGesture position for image positioning
            relativePoint = longPressGesture.location(in: longPressGesture.view)
            
            // Create UIAlertController
            let actionSheetAlert = UIAlertController(title: NSLocalizedString("Add", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            // Action for use Camera
            let useCamera = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { (alertAction) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            // Action for use Photo Library
            let usePhotoLibrary = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default) { (alertAction) in
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            // Action for use Location
            let useLocation = UIAlertAction(title: NSLocalizedString("Location", comment: ""), style: .default) { (alertAction) in
                let locationVC = LocationViewController()
                locationVC.delegate = self
                self.navigationController?.pushViewController(locationVC, animated: true)
            }
            
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
            
            actionSheetAlert.addAction(useCamera)
            actionSheetAlert.addAction(usePhotoLibrary)
            actionSheetAlert.addAction(useLocation)
            actionSheetAlert.addAction(cancel)
            
            actionSheetAlert.popoverPresentationController?.sourceView = self.noteTextView
            actionSheetAlert.popoverPresentationController?.sourceRect = CGRect(x: longPressGesture.location(in: self.noteTextView).x, y: longPressGesture.location(in: self.noteTextView).y, width: 0, height: 0)
            
            present(actionSheetAlert, animated: true, completion: nil)
            
        } else if (longPressGesture.state == .ended || longPressGesture.state == .cancelled) {
            gestureActive = .noActive
        }
        
    }
    
}
