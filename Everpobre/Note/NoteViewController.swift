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
    var pickOptions:[Notebook] = []

    // MARK: - UI Components
    let titleTextField = SkyFloatingLabelTextField()
    let notebookSky = SkyFloatingLabelTextField()
    let notebookPickerView = UIPickerView()
    let endDateSky = SkyFloatingLabelTextField()
    let tagsWST = WSTagsField()
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
        
        self.loadPickOptions()
        
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
        
        tagsWST.onDidAddTag = { (_,_) in
            var tagsString = ""
            for tag in self.tagsWST.tags {
                tagsString += "\(tag.text),"
            }
            self.model.tags = tagsString
            self.delegate?.didChange(note: self.model, type: .tags)
        }
        
        tagsWST.onDidRemoveTag = { (_,_) in
            var tagsString = ""
            for tag in self.tagsWST.tags {
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
        notebookSky.translatesAutoresizingMaskIntoConstraints = false
        endDateSky.translatesAutoresizingMaskIntoConstraints = false
        tagsWST.translatesAutoresizingMaskIntoConstraints = false
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
        
        // Configure notebookSky
        myView.addSubview(notebookSky)
        notebookSky.placeholder = "Notebook"
        notebookSky.title = "Notebook"
        notebookSky.titleFont = UIFont(name: notebookSky.titleFont.fontName, size: 10)!
        notebookSky.font = UIFont(name: (notebookSky.font?.fontName)!, size: 10)
        notebookSky.addTarget(self, action: #selector(loadPickOptions), for: .touchDown)
        notebookSky.backgroundColor = .blue
        
        notebookPickerView.delegate = self
        notebookSky.inputView = notebookPickerView
        
        notebookSky.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        notebookSky.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4).isActive = true
        notebookSky.widthAnchor.constraint(equalToConstant: 110).isActive = true
        notebookSky.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // Configure endDateSky
        myView.addSubview(endDateSky)
        endDateSky.placeholder = NSLocalizedString("Expiration Date", comment: "")
        endDateSky.title = NSLocalizedString("Expiration Date", comment: "")
        endDateSky.titleFont = UIFont(name: endDateSky.titleFont.fontName, size: 10)!
        endDateSky.font = UIFont(name: (endDateSky.font?.fontName)!, size: 10)
        endDateSky.addTarget(self, action: #selector(editingEndDateTextField), for: .touchDown)
        endDateSky.backgroundColor = .red
        
        endDateSky.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        endDateSky.topAnchor.constraint(equalTo: notebookSky.bottomAnchor, constant: 4).isActive = true
        endDateSky.widthAnchor.constraint(equalTo: notebookSky.widthAnchor).isActive = true
        endDateSky.heightAnchor.constraint(equalTo: notebookSky.heightAnchor).isActive = true
    
        // Configure tagsWST
        myView.addSubview(tagsWST)
        tagsWST.font = .systemFont(ofSize: 10.0)
        tagsWST.placeholder = NSLocalizedString("Tags", comment: "")
        tagsWST.spaceBetweenTags = 3.0
        tagsWST.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tagsWST.tintColor = .green
        tagsWST.textColor = .black
        tagsWST.fieldTextColor = .blue
        tagsWST.selectedColor = .black
        tagsWST.selectedTextColor = .red
        tagsWST.backgroundColor = .lightGray
        
        tagsWST.leftAnchor.constraint(equalTo: notebookSky.rightAnchor, constant: 8).isActive = true
        tagsWST.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -8).isActive = true
        tagsWST.topAnchor.constraint(equalTo: notebookSky.topAnchor).isActive = true
        tagsWST.bottomAnchor.constraint(equalTo: endDateSky.bottomAnchor).isActive = true
        
        // Configure noteTextView
        myView.addSubview(noteTextView)
        noteTextView.delegate = self
        noteTextView.backgroundColor = .yellow
        noteTextView.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
        noteTextView.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -8).isActive = true
        noteTextView.topAnchor.constraint(equalTo: tagsWST.bottomAnchor, constant: 4).isActive = true
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
        notebookSky.text = model.notebook.name
        endDateSky.text = dateFormatter.string(from: model.endDate)
        let arrTags = model.tags.components(separatedBy: ",")
        for tag in arrTags {
            if (tag != "") {
                tagsWST.addTag(tag)
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
    
    // Get Notebooks to define pick options for notebookPickerView
    @objc func loadPickOptions() {
        // Get all Notebooks
        let req = Notebook.fetchRequest()
        req.fetchBatchSize = 50
        guard let results = try? CoreDataContainer.default.viewContext.fetch(req) as! [Notebook] else {return}
    
        self.pickOptions = results
        self.notebookPickerView.reloadAllComponents()
        
    }
}






