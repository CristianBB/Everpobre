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
}

class NoteViewController: UIViewController {

    // MARK: - Properties
    var model: Note

    // MARK: - UI Components
    let titleTextField = SkyFloatingLabelTextField()
    let notebookLabel = SkyFloatingLabelTextField()
    let endDateTextField = SkyFloatingLabelTextField()
    let tagsTexTield = WSTagsField()
    let noteTextView = UITextView()
    
    var relativePoint: CGPoint!
    var gestureActive: longPressGestureActive = .noActive
    var imageActive:UIImageView?
    
    // MARK: - Initialization
    init(model: Note) {
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
            if let imageView = subview as? UIImageView {
                // If actual subview is UIImageView, check that position is inside noteTextView area
                var imageFrame = imageView.frame
                    
                if (imageFrame.maxX > noteTextView.frame.width) {
                    let differX = imageFrame.maxX - noteTextView.frame.width
                    imageFrame = CGRect(x: imageFrame.origin.x - differX, y: imageFrame.origin.y, width: imageFrame.width, height: imageFrame.height)
                }
                // Dirty trick to expand noteTextView if Image goes down of Height
                if (imageFrame.maxY > noteTextView.contentSize.height && imageFrame.maxY > noteTextView.frame.height) {
                    noteTextView.text.append("\n")
                }
                if (imageFrame.minX < 0.0) {
                    imageFrame = CGRect(x: 0.0, y: imageFrame.origin.y, width: imageFrame.width, height: imageFrame.height)
                }
                if (imageFrame.minY < 0.0) {
                    imageFrame = CGRect(x: imageFrame.origin.x, y: 0.0, width: imageFrame.width, height: imageFrame.height)
                }
                imageView.frame = imageFrame
                
                // Calculate exclusionPaths
                var rect = imageView.frame
                rect = rect.insetBy(dx: -10, dy: -10)
                
                let paths = UIBezierPath(rect: rect)
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
        
        guard let imageCoreData = model.images else { return }
        for imageAct in imageCoreData {
            
            addImageToView(imageCoreData: imageAct)
        }
    }
    
    // Add and image inside noteTextView
    func addImageToView(imageCoreData: imageCoreData) {
        // Setup img
        let imageView = UIImageView()
        imageView.image = imageCoreData.image
        imageView.accessibilityIdentifier = imageCoreData.objectid // For identification purposes
        
        // Image position
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = imageCoreData.position
        noteTextView.addSubview(imageView)
        
        // Add gesture interaction to Image
        imageView.isUserInteractionEnabled = true
        //let moveGesture = UILongPressGestureRecognizer(target: self, action: #selector(moveImage))
        //imageView.addGestureRecognizer(moveGesture)
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
    
    // LongPressGesture
    @objc func longPressGesture(longPressGesture:UILongPressGestureRecognizer) {
        
        if (gestureActive == .noActive) {
            // Check if gesture was released on a UIImageView
            for subview in noteTextView.subviews {
                if let imageView = subview as? UIImageView {
                    if (imageView.frame.contains(longPressGesture.location(in: noteTextView))) {
                        gestureActive = .imagePressed
                        imageActive = imageView
                    }
                }
            }
            
            // If not, Check if gesture was released on noteTextView
            if (gestureActive == .noActive && noteTextView.frame.contains(longPressGesture.location(in: longPressGesture.view))) {
                gestureActive = .notePressed
            }
        }
        
        if (gestureActive == .imagePressed) {
            moveImage(longPressGesture: longPressGesture, imageViewPressed: imageActive!)
        } else if (gestureActive == .notePressed) {
            addElement(longPressGesture: longPressGesture)
        }
        
        if (longPressGesture.state == .cancelled || longPressGesture.state == .ended) {
            gestureActive = .noActive
        }
    }
    
    
    // LongPressGesture on Image: User move the image
    func moveImage(longPressGesture:UILongPressGestureRecognizer, imageViewPressed: UIImageView) {
        
        switch longPressGesture.state {
        case .began:
            closeKeyboard()
            relativePoint = longPressGesture.location(in: imageViewPressed)
            
            UIView.animate(withDuration: 0.1, animations: {
                imageViewPressed.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            })
            
        case .changed:
            let locationPress = longPressGesture.location(in: noteTextView)
            
            let locationY = locationPress.y - relativePoint.y
            let locationX = locationPress.x - relativePoint.x
            
            let newPositionRect = CGRect(x: locationX, y: locationY, width: imageViewPressed.frame.size.width, height: imageViewPressed.frame.size.height)
            imageViewPressed.frame = newPositionRect
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.1, animations: {
                imageViewPressed.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            
        default:
            break
        }
        
        // Force Layout Update
        view.setNeedsLayout()
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
            let imageAdded = imageCoreData(objectid: "5", image: scaledImage!, position: newPosition)
            model.images?.append(imageAdded)
            addImageToView(imageCoreData: imageAdded)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
