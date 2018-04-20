//
//  NoteViewController+Delegates.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 20/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit


// MARK: - ImagePickerControllerDelegate
extension NoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // scale image to width=200 respecting aspect ratio
            let targetWidth: CGFloat = 150.0
            let scaleFactor = targetWidth / image.size.width
            let targetHeight = image.size.height * scaleFactor
            let targetSize = CGSize(width: targetWidth, height: targetHeight)
            let rect = CGRect(x: 0.0, y: 0.0, width: targetSize.width, height: targetSize.height)
            UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
            image.draw(in: rect)
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let locationY = relativePoint.y
            let locationX = relativePoint.x
            let newPosition = CGRect(x: locationX, y: locationY, width: targetWidth, height: targetHeight)
            
            // Add image
            let imageAdded = NoteImage(image: scaledImage!, positionFrame: newPosition, note: model, inContext: CoreDataContainer.default.viewContext)
            addImageToView(imageAdded)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - NoteTextViewDelegate
extension NoteViewController: UITextViewDelegate {
    
    // User edits titleTextField
    func textViewDidChange(_ textView: UITextView) {
        if let value = textView.text {
            model.text = value
        } else {
            model.text = ""
        }
        
        // Notify delegate
        self.delegate?.didChange(note: model, type: .text)
    }
}

// MARK: - NoteImageViewDelegate
extension NoteViewController: NoteImageViewControllerDelegate {
    func didChange(noteImage: NoteImage) {
        view.setNeedsLayout()
        
        // Notify delegate
        self.delegate?.didChange(note: model, type: .images)
    }
    
    func requestRemove(noteImageView: NoteImageViewController) {
        let confirmation = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            // Delete from model
            CoreDataContainer.default.viewContext.delete(noteImageView.model)
            
            // Remove imageView with effect
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                noteImageView.alpha = 0
            }, completion: { (finished) in
                noteImageView.removeFromSuperview()
                
                // Notify Delegate
                self.delegate?.didChange(note: self.model, type: .images)
                
                self.deactivateEdition()
                self.syncModelWithView()
            })
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        confirmation.addAction(ok)
        confirmation.addAction(cancel)
        
        self.present(confirmation, animated: true, completion: nil)
    }
    
    
}
