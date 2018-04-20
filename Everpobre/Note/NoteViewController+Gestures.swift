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
        } else if (endDateTextField.isFirstResponder) {
            endDateTextField.resignFirstResponder()
        } else if (tagsTexTield.isEditing) {
            tagsTexTield.endEditing()
        } else if (noteTextView.isFirstResponder) {
            noteTextView.resignFirstResponder()
        }
    }
    
    // DoubleTapGesture: Initialize image edition mode
    @objc func doubleTapGesture(tapGesture:UITapGestureRecognizer) {
        
        // Check if gesture was released on a UIImageView
        for subview in noteTextView.subviews {
            if let noteImageView = subview as? NoteImageViewController {
                if (noteImageView.frame.contains(tapGesture.location(in: noteTextView))) {
                    
                    // Activate Edition Mode
                    if (gestureActive == .noActive) {
                        noteImageView.activateEditionMode()
                        
                        gestureActive = .editImage
                        imageEdited = noteImageView
                        return
                        
                        // Deactivate Edition Mode
                    } else if (imageEdited == noteImageView) {
                        deactivateEdition()
                        return
                    }
                    
                }
            }
        }
    }
    
    
    // Deactivate any pending gesture action
    func deactivateEdition() {
        if (gestureActive == .editImage) {
            imageEdited?.deactivateEditionMode()
            gestureActive = .noActive
        }
    }
    
    // LongPressGesture
    @objc func longPressGesture(longPressGesture:UILongPressGestureRecognizer) {
        
        if (gestureActive == .noActive) {
            // Check if gesture was released on a UIImageView
            for subview in noteTextView.subviews {
                if let noteImageView = subview as? NoteImageViewController {
                    if (noteImageView.frame.contains(longPressGesture.location(in: noteTextView))) {
                        gestureActive = .imagePressed
                        imageEdited = noteImageView
                    }
                }
            }
            
            // If not, Check if gesture was released on noteTextView
            if (gestureActive == .noActive && noteTextView.frame.contains(longPressGesture.location(in: longPressGesture.view))) {
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
            // Save longPressGesture position for positioning image
            relativePoint = longPressGesture.location(in: longPressGesture.view)
            
            // Create UIAlertController
            let actionSheetAlert = UIAlertController(title: NSLocalizedString("Add", comment: "Add an element to your Note"), message: nil, preferredStyle: .actionSheet)
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            // Action for use Camera
            let useCamera = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            // Action for use Photo Library
            let usePhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            // Action for use Location
            let useLocation = UIAlertAction(title: "Location", style: .default) { (alertAction) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
            
            actionSheetAlert.addAction(useCamera)
            actionSheetAlert.addAction(usePhotoLibrary)
            actionSheetAlert.addAction(useLocation)
            actionSheetAlert.addAction(cancel)
            
            present(actionSheetAlert, animated: true, completion: nil)
            
        } else if (longPressGesture.state == .ended || longPressGesture.state == .cancelled) {
            gestureActive = .noActive
        }
        
    }
    
    @objc func addLocation()
    {
        
    }
    
}
