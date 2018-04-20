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

// MARK: - Delegate Protocol
protocol NoteViewControllerDelegate: class {
    func didChange(note: Note, type:typeOfNoteChange)
}

enum longPressGestureActive:String {
    case noActive
    case imagePressed
    case notePressed
    case editImage
}

enum typeOfNoteChange: String {
    case title
    case notebook
    case expirationDate
    case tags
    case text
    case images
}

class NoteViewController: UIViewController {

    // MARK: - Properties
    var model: Note
    weak var delegate: NoteViewControllerDelegate?

    // MARK: - UI Components
    let titleTextField = SkyFloatingLabelTextField()
    let notebookLabel = SkyFloatingLabelTextField()
    let endDateTextField = SkyFloatingLabelTextField()
    let tagsTexTield = WSTagsField()
    let noteTextView = UITextView()
    
    var relativePoint: CGPoint!
    var gestureActive: longPressGestureActive = .noActive
    var imageEdited:NoteImageViewController?
    
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
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        noteTextView.addGestureRecognizer(longPress)
        
        // noteTextView Gesture - Double Tap
        let twoTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture))
        twoTapGesture.numberOfTapsRequired = 2
        noteTextView.addGestureRecognizer(twoTapGesture)
        
        tagsTexTield.onDidAddTag = { (_,_) in
            var tagsString = ""
            for tag in self.tagsTexTield.tags {
                tagsString += "\(tag.text),"
            }
            self.model.tags = tagsString
            self.delegate?.didChange(note: self.model, type: .tags)
        }
        
        tagsTexTield.onDidRemoveTag = { (_,_) in
            var tagsString = ""
            for tag in self.tagsTexTield.tags {
                tagsString += "\(tag.text),"
            }
            self.model.tags = tagsString
            self.delegate?.didChange(note: self.model, type: .tags)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        // Empty exclusionPaths from noteTextView
        noteTextView.textContainer.exclusionPaths = []
        
        // Iterate subviews on noteTextView
        for subview in noteTextView.subviews {
            if let noteImageView = subview as? NoteImageViewController {
                noteImageView.fixFramePositionIn(noteTextView)
                
                // Apply exclusionPaths
                let paths = UIBezierPath(rect: noteImageView.marginRect)
                noteTextView.textContainer.exclusionPaths.append(paths)
            }
        }
    }
    
    func setupUI() {
        guard let myView = view else { return }
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        notebookLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateTextField.translatesAutoresizingMaskIntoConstraints = false
        tagsTexTield.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // Main View
        myView.backgroundColor = .white
        let guide = myView.safeAreaLayoutGuide
        
        // Configure titleTextField
        myView.addSubview(titleTextField)
        titleTextField.placeholder = NSLocalizedString("Note Title", comment: "")
        titleTextField.title = NSLocalizedString("Title", comment: "")
        titleTextField.addTarget(self, action: #selector(titleTextFieldChanged), for: .editingChanged)
        titleTextField.backgroundColor = .cyan

        titleTextField.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 8).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -8).isActive = true
        titleTextField.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Configure notebookLabel
        myView.addSubview(notebookLabel)
        notebookLabel.placeholder = "Notebook"
        notebookLabel.title = "Notebook"
        notebookLabel.titleFont = UIFont(name: notebookLabel.titleFont.fontName, size: 10)!
        notebookLabel.font = UIFont(name: (notebookLabel.font?.fontName)!, size: 10)
        notebookLabel.isUserInteractionEnabled = false
        notebookLabel.backgroundColor = .blue
        
        notebookLabel.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        notebookLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4).isActive = true
        notebookLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        notebookLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // Configure endDate
        myView.addSubview(endDateTextField)
        endDateTextField.placeholder = NSLocalizedString("Expiration Date", comment: "")
        endDateTextField.title = NSLocalizedString("Expiration Date", comment: "")
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
        tagsTexTield.placeholder = NSLocalizedString("Tags", comment: "")
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
        noteTextView.delegate = self
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
            if let imageView = subview as? NoteImageViewController {
                imageView.removeFromSuperview()
            }
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        titleTextField.text = model.title
        notebookLabel.text = model.notebook.name
        endDateTextField.text = dateFormatter.string(from: model.endDate)
        let arrTags = model.tags.components(separatedBy: ",")
        for tag in arrTags {
            if (tag != "") {
                tagsTexTield.addTag(tag)
            }
        }
        
        noteTextView.text = model.text
        
        let modelImages = model.images.allObjects as! [NoteImage]
        for noteImageAct in modelImages {
            addImageToView(noteImageAct)
        }
        
    }
    
    // Add an image inside noteTextView
    func addImageToView(_ image: NoteImage) {
        let noteImageView = NoteImageViewController(model: image)
        noteImageView.delegate = self as NoteImageViewControllerDelegate
        noteTextView.addSubview(noteImageView)
    }
    
}






