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
    
    func syncModelWithView() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"

        titleTextField.text = model.title
        notebookLabel.text = model.notebook?.name
        endDateTextField.text = dateFormatter.string(from: model.endDate)
        tagsTexTield.text = model.tags.flatMap({$0})?.joined()
        noteTextView.text = model.text
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
        endDateTextField.addTarget(self, action: #selector(editingendDateTextField), for: UIControlEvents.touchDown)
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
    
    
    // Instead of keyboard for endDate edition, we'll use DatePicker
    @objc func editingendDateTextField(textField: UITextField) {
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
