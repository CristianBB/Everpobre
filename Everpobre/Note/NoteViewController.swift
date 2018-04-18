//
//  NoteViewController.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 7/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import WSTagsField

enum longPressGestureActive:String {
    case noActive = "noActive"
    case imagePressed = "imagePressed"
    case notePressed = "notePressed"
    case editImage = "editImage"
}

class NoteViewController: UIViewController {

    // MARK: - Properties
    var model: NoteDummy

    // MARK: - UI Components
    let titleTextField = SkyFloatingLabelTextField()
    let notebookLabel = SkyFloatingLabelTextField()
    let endDateTextField = SkyFloatingLabelTextField()
    let tagsTexTield = WSTagsField()
    let noteTextView = UITextView()
    
    var relativePoint: CGPoint!
    var gestureActive: longPressGestureActive = .noActive
    var imageEdited:NoteImageView?
    
    // MARK: - Initialization
    init(model: NoteDummy) {
        self.model = model
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        
        title = model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setupUI()
        syncModelWithView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View Gesture - Swipe Down
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeKeyboard))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        // noteTextView Gesture - LongPress
        let moveGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        noteTextView.addGestureRecognizer(moveGesture)
        
        // noteTextView Gesture - Double Tap
        let twoTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture))
        twoTapGesture.numberOfTapsRequired = 2
        noteTextView.addGestureRecognizer(twoTapGesture)
        
        // tagsTexTield Events
        tagsTexTield.onDidAddTag = { (_,_) in
            print("DidAddTag")
        }
        
        tagsTexTield.onDidRemoveTag = { (_,_) in
            print("DidRemoveTag")
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        // Empty exclusionPaths from noteTextView
        noteTextView.textContainer.exclusionPaths = []
        
        // Iterate subviews on noteTextView
        for subview in noteTextView.subviews {
            if let noteImageView = subview as? NoteImageView {
                noteImageView.fixFramePositionIn(noteTextView)
                
                // Apply exclusionPaths
                let paths = UIBezierPath(rect: noteImageView.marginRect)
                noteTextView.textContainer.exclusionPaths.append(paths)
            }
        }
    }
    
    func setupUI() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        notebookLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateTextField.translatesAutoresizingMaskIntoConstraints = false
        tagsTexTield.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let myView = UIView()
        myView.backgroundColor = .white
        
        // Configure titleTextField
        myView.addSubview(titleTextField)
        titleTextField.placeholder = "Note Title"
        titleTextField.title = "Title"
        titleTextField.backgroundColor = .cyan
        
        titleTextField.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -8).isActive = true
        titleTextField.topAnchor.constraint(equalTo: myView.topAnchor, constant: 40).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Configure notebookLabel
        myView.addSubview(notebookLabel)
        notebookLabel.placeholder = "Notebook"
        notebookLabel.title = "Notebook"
        notebookLabel.titleFont = UIFont(name: notebookLabel.titleFont.fontName, size: 10)!
        notebookLabel.font = UIFont(name: (notebookLabel.font?.fontName)!, size: 10)
        notebookLabel.backgroundColor = .blue
        
        notebookLabel.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        notebookLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4).isActive = true
        notebookLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        notebookLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // Configure endDate
        myView.addSubview(endDateTextField)
        endDateTextField.placeholder = "Expiration Date"
        endDateTextField.title = "Expiration Date"
        endDateTextField.titleFont = UIFont(name: endDateTextField.titleFont.fontName, size: 10)!
        endDateTextField.font = UIFont(name: (endDateTextField.font?.fontName)!, size: 10)
        endDateTextField.addTarget(self, action: #selector(editingEndDateTextField), for: UIControlEvents.touchDown)
        endDateTextField.backgroundColor = .red
        
        endDateTextField.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        endDateTextField.topAnchor.constraint(equalTo: notebookLabel.bottomAnchor, constant: 4).isActive = true
        endDateTextField.widthAnchor.constraint(equalTo: notebookLabel.widthAnchor).isActive = true
        endDateTextField.heightAnchor.constraint(equalTo: notebookLabel.heightAnchor).isActive = true
    
        // Configure tagsTexTield
        myView.addSubview(tagsTexTield)
        tagsTexTield.font = .systemFont(ofSize: 10.0)
        //tagsTexTield.delimiter = ","
        tagsTexTield.placeholder = "Tags"
        tagsTexTield.spaceBetweenTags = 3.0
        tagsTexTield.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tagsTexTield.tintColor = .green
        tagsTexTield.textColor = .black
        tagsTexTield.fieldTextColor = .blue
        tagsTexTield.selectedColor = .black
        tagsTexTield.selectedTextColor = .red
        tagsTexTield.backgroundColor = .lightGray
        
        tagsTexTield.leftAnchor.constraint(equalTo: notebookLabel.rightAnchor, constant: 8).isActive = true
        tagsTexTield.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -8).isActive = true
        tagsTexTield.topAnchor.constraint(equalTo: notebookLabel.topAnchor).isActive = true
        tagsTexTield.bottomAnchor.constraint(equalTo: endDateTextField.bottomAnchor).isActive = true
        
        // Configure noteTextView
        myView.addSubview(noteTextView)
        noteTextView.backgroundColor = .yellow
        noteTextView.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        noteTextView.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -8).isActive = true
        noteTextView.topAnchor.constraint(equalTo: tagsTexTield.bottomAnchor, constant: 4).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant: -8).isActive = true
        
        self.view = myView
    }
    
    func syncModelWithView() {
        
        // Remove NoteImageViews in noteTextView
        for subview in noteTextView.subviews {
            if let imageView = subview as? NoteImageView {
                imageView.removeFromSuperview()
            }
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        titleTextField.text = model.title
        notebookLabel.text = model.notebook?.name
        endDateTextField.text = dateFormatter.string(from: model.endDate)
        if let tags = model.tags {
            for tag in tags {
                tagsTexTield.addTag(tag)
            }
        }
        
        noteTextView.text = model.text
        
        guard let imageCoreDataDummy = model.images else { return }
        for imageAct in imageCoreDataDummy {
            addImageToView(imageAct)
        }
    }
    
    // Add an image inside noteTextView
    func addImageToView(_ image: imageCoreDataDummy) {
        let noteImageView = NoteImageView(model: image)
        noteImageView.delegate = self
        noteTextView.addSubview(noteImageView)
    }
    
    // Instead of keyboard for endDate edition, we'll use DatePicker
    @objc func editingEndDateTextField(textField: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView.locale = Locale.current
        datePickerView.date = model.endDate
        textField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    // Update endDate from Model and Sync View
    @objc func datePickerValueChanged(datePicker:UIDatePicker) {
        model.endDate = datePicker.date
        syncModelWithView()
    }

}

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
            if let noteImageView = subview as? NoteImageView {
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
                if let noteImageView = subview as? NoteImageView {
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
            let imageAdded = imageCoreDataDummy(objectid: "5", image: scaledImage!, originalFrame: NSStringFromCGRect(newPosition), actualFrame: NSStringFromCGRect(newPosition))
            model.images?.append(imageAdded)
            addImageToView(imageAdded)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - NoteImageViewDelegate
extension NoteViewController: NoteImageViewDelegate {
    func didMove() {
        view.setNeedsLayout()
    }
    
    func didRotate() {
        view.setNeedsLayout()
    }
    
    func didScale() {
        view.setNeedsLayout()
    }
    
    func requestRemove(noteImageView: NoteImageView) {
        let confirmation = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            // CBB AQUI
            self.model.images.inde
            // Delete from model
            for index in 0..<self.model.images!.count {
                if (self.model.images![index].objectid == self.imageEdited?.accessibilityIdentifier) {
                    self.model.images?.remove(at: index)
                }
            }
            self.deactivateEdition()
            self.syncModelWithView()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        confirmation.addAction(ok)
        confirmation.addAction(cancel)
        
        self.present(confirmation, animated: true, completion: nil)
    }
    
    
}





