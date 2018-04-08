//
//  NoteViewController.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 7/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    // MARK: - Properties
    var model: Note

    // MARK: - UI Components
    let titleTextField = UITextField()
    let notebookLabel = UILabel()
    let endDateTextField = UITextField()
    let tagsTexTield = UITextField()
    let noteTextView = UITextView()
    
    var relativePoint: CGPoint!
    
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
        
        // MARK: View Gestures
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeKeyboard))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
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
                if (imageFrame.maxY > noteTextView.frame.height) {
                    let differY = imageFrame.maxY - noteTextView.frame.height
                    imageFrame = CGRect(x: imageFrame.origin.x, y: imageFrame.origin.y - differY, width: imageFrame.width, height: imageFrame.height)
                }
                if (imageFrame.minX < 0.0) {
                    imageFrame = CGRect(x: 0.0, y: imageFrame.origin.y, width: imageFrame.width, height: imageFrame.height)
                }
                if (imageFrame.minY < 0.0) {
                    imageFrame = CGRect(x: imageFrame.origin.x, y: 0.0, width: imageFrame.width, height: imageFrame.height)
                }
                imageView.frame = imageFrame
                
                
                // Calculate exclusionPaths
                var rect = view.convert(imageView.frame, to: noteTextView)
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
        titleTextField.backgroundColor = .cyan
        titleTextField.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -8).isActive = true
        titleTextField.topAnchor.constraint(equalTo: myView.topAnchor, constant: 40).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Configuramos autolayout de los elementos desde la derecha, pues el Nombre del notebook cogerá todo el espacio que dejen el resto de elementos
        // Configure tagsTexTield
        myView.addSubview(tagsTexTield)
        tagsTexTield.backgroundColor = .green
        tagsTexTield.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -8).isActive = true
        tagsTexTield.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4).isActive = true
        tagsTexTield.widthAnchor.constraint(equalToConstant: 100).isActive = true
        tagsTexTield.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Configure endDate
        myView.addSubview(endDateTextField)
        endDateTextField.addTarget(self, action: #selector(editingEndDateTextField), for: UIControlEvents.touchDown)
        endDateTextField.backgroundColor = .red
        endDateTextField.rightAnchor.constraint(equalTo: tagsTexTield.leftAnchor, constant: -8).isActive = true
        endDateTextField.topAnchor.constraint(equalTo: tagsTexTield.topAnchor).isActive = true
        endDateTextField.widthAnchor.constraint(equalToConstant: 170).isActive = true
        endDateTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Configure notebookLabel
        myView.addSubview(notebookLabel)
        notebookLabel.backgroundColor = .blue
        notebookLabel.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        notebookLabel.rightAnchor.constraint(equalTo: endDateTextField.leftAnchor, constant: -8).isActive = true
        notebookLabel.topAnchor.constraint(equalTo: endDateTextField.topAnchor).isActive = true
        notebookLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Configure noteTextView
        myView.addSubview(noteTextView)
        noteTextView.backgroundColor = .yellow
        noteTextView.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        noteTextView.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -8).isActive = true
        noteTextView.topAnchor.constraint(equalTo: notebookLabel.bottomAnchor, constant: 4).isActive = true
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
        tagsTexTield.text = model.tags.flatMap({$0})?.joined()
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
        //imageView.backgroundColor = .darkGray
        imageView.image = imageCoreData.image
        imageView.accessibilityIdentifier = imageCoreData.objectid // For identification purposes
        
        // Image position
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = imageCoreData.position
        noteTextView.addSubview(imageView)
        
        // Add interaction
        imageView.isUserInteractionEnabled = true
        let moveGesture = UILongPressGestureRecognizer(target: self, action: #selector(moveImage))
        imageView.addGestureRecognizer(moveGesture)
    }
    
    // LongPressGesture: User move the image
    @objc func moveImage(longPressGesture:UILongPressGestureRecognizer)
    {
        let imageViewPressed = longPressGesture.view as! UIImageView
        
        switch longPressGesture.state {
        case .began:
            closeKeyboard()
            relativePoint = longPressGesture.location(in: longPressGesture.view)
            
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
    
    // Close keyboard/datepicker
    @objc func closeKeyboard()
    {
        if (titleTextField.isFirstResponder) {
            titleTextField.resignFirstResponder()
        } else if (endDateTextField.isFirstResponder) {
            endDateTextField.resignFirstResponder()
        } else if (tagsTexTield.isFirstResponder) {
            tagsTexTield.resignFirstResponder()
        } else if (noteTextView.isFirstResponder) {
            noteTextView.resignFirstResponder()
        }
    }
}
