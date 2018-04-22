//
//  NotebookCell.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 21/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol
protocol NotebookHeaderDelegate: class {
    func editNotebookName(notebook: Notebook)
    func addNoteToNotebook(notebook: Notebook)
    func deleteNotebook(notebook: Notebook)
    func setDefaultNotebook(notebook: Notebook)
}

class NotebookHeader: UIView {
    
    // MARK: - Properties
    let model: Notebook
    let isEditing: Bool
    weak var delegate: NotebookHeaderDelegate?
    
    private var leftAnchorDefaultView: NSLayoutConstraint?
    private var rightAnchorDefaultView: NSLayoutConstraint?
    
    let defaultView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftEditView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rightEditView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let creationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let defaultImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "defaultNotebook.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let addNoteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size = CGSize(width: 30, height: 30)
        button.setImage(#imageLiteral(resourceName: "addNote.png"), for: .normal)
        button.addTarget(self, action: #selector(addNoteToNotebook), for: .touchDown)
        return button
    }()
    
    init(frame: CGRect, model: Notebook, isEditing: Bool) {
        self.model = model
        self.isEditing = isEditing
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(red:0.03, green:0.64, blue:0.65, alpha:1.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // nameTextField
        if (model.name == "") {
            nameLabel.text = NSLocalizedString("-- NO NAME --", comment: "")
        } else {
            nameLabel.text = model.name
        }
        
        // creationDateLabel
        let creationPrefix = NSLocalizedString("Created:", comment: "")
        let creationString = dateFormatter.string(from: model.creationDate)
        creationDateLabel.text = "\(creationPrefix) \(creationString)"
        
        // Default View, where default UI components will be located
        addSubview(defaultView)
        defaultView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftAnchorDefaultView = defaultView.leftAnchor.constraint(equalTo: leftAnchor)
        rightAnchorDefaultView = defaultView.rightAnchor.constraint(equalTo: rightAnchor)
        defaultView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftAnchorDefaultView?.isActive = true
        rightAnchorDefaultView?.isActive = true
        
        defaultView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: defaultView.topAnchor, constant: 4).isActive = true
        var leftAnchorNameLabel = nameLabel.leftAnchor.constraint(equalTo: defaultView.leftAnchor, constant: 8)
        nameLabel.rightAnchor.constraint(equalTo: defaultView.rightAnchor, constant: -40).isActive = true
        leftAnchorNameLabel.isActive = true
        
        defaultView.addSubview(creationDateLabel)
        creationDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        creationDateLabel.leftAnchor.constraint(equalTo: defaultView.leftAnchor, constant: 8).isActive = true
        creationDateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        if (model.isDefaultNotebook) {
            // defaultImage
            defaultView.addSubview(defaultImage)
            defaultImage.topAnchor.constraint(equalTo: defaultView.topAnchor, constant: 4).isActive = true
            defaultImage.leftAnchor.constraint(equalTo: defaultView.leftAnchor, constant: 4).isActive = true
            defaultImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            defaultImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            // Change nameLabel position
            leftAnchorNameLabel.isActive = false
            leftAnchorNameLabel = nameLabel.leftAnchor.constraint(equalTo: defaultImage.rightAnchor, constant: 4)
            leftAnchorNameLabel.isActive = true
        }
        
        if (isEditing) {
            addLeftEditView()
            
        } else {
            // addNote button
            defaultView.addSubview(addNoteButton)
            addNoteButton.rightAnchor.constraint(equalTo: defaultView.rightAnchor).isActive = true
            addNoteButton.centerYAnchor.constraint(equalTo: defaultView.centerYAnchor).isActive = true
        }
    }
}

extension NotebookHeader {
    
    func addLeftEditView() {
        addSubview(leftEditView)
        leftEditView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftEditView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftEditView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        leftEditView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Change default View left position
        leftAnchorDefaultView?.isActive = false
        rightAnchorDefaultView?.isActive = false
        leftAnchorDefaultView = defaultView.leftAnchor.constraint(equalTo: leftEditView.rightAnchor)
        rightAnchorDefaultView = defaultView.rightAnchor.constraint(equalTo: rightAnchor)
        leftAnchorDefaultView?.isActive = true
        rightAnchorDefaultView?.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        
        // Edit Button
        let editButton = UIButton(type: .custom)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.frame.size = CGSize(width: 30, height: 30)
        editButton.setImage(#imageLiteral(resourceName: "edit.png"), for: .normal)
        editButton.addTarget(self, action: #selector(addRightEditView), for: .touchDown)
        
        leftEditView.addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: leftEditView.rightAnchor).isActive = true
        editButton.centerYAnchor.constraint(equalTo: leftEditView.centerYAnchor).isActive = true
    }
    
    @objc func addRightEditView() {
        addSubview(rightEditView)
        rightEditView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightEditView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightEditView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        rightEditView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Change defaultView position
        leftAnchorDefaultView?.isActive = false
        rightAnchorDefaultView?.isActive = false
        leftAnchorDefaultView = defaultView.leftAnchor.constraint(equalTo: leftAnchor)
        rightAnchorDefaultView = defaultView.rightAnchor.constraint(equalTo: rightEditView.leftAnchor)
        leftAnchorDefaultView?.isActive = true
        rightAnchorDefaultView?.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        
        // Remove leftEditView
        leftEditView.removeFromSuperview()
        
        // Add gesture on defaultView to Deactivate Edition
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelEdit))
        tapGesture.numberOfTapsRequired = 1
        defaultView.isUserInteractionEnabled = true
        defaultView.addGestureRecognizer(tapGesture)
        
        // delete Button
        let deleteButton = UIButton(type: .custom)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.frame.size = CGSize(width: 30, height: 30)
        deleteButton.setImage(#imageLiteral(resourceName: "delete.png"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteNotebook), for: .touchDown)
        
        rightEditView.addSubview(deleteButton)
        deleteButton.rightAnchor.constraint(equalTo: rightEditView.rightAnchor).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: rightEditView.centerYAnchor).isActive = true
        
        // editName Button
        let editNameButton = UIButton(type: .custom)
        editNameButton.translatesAutoresizingMaskIntoConstraints = false
        editNameButton.frame.size = CGSize(width: 30, height: 30)
        editNameButton.setImage(#imageLiteral(resourceName: "edit.png"), for: .normal)
        editNameButton.addTarget(self, action: #selector(editName), for: .touchDown)
        
        rightEditView.addSubview(editNameButton)
        editNameButton.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -4).isActive = true
        editNameButton.centerYAnchor.constraint(equalTo: rightEditView.centerYAnchor).isActive = true
        
        // setDefault Button
        if (model.isDefaultNotebook == false) {
            let setDefault = UIButton(type: .custom)
            setDefault.translatesAutoresizingMaskIntoConstraints = false
            setDefault.frame.size = CGSize(width: 30, height: 30)
            setDefault.setImage(#imageLiteral(resourceName: "noDefaultNotebook.png"), for: .normal)
            setDefault.layer.masksToBounds = false
            setDefault.layer.cornerRadius = setDefault.frame.width / 2
            setDefault.addTarget(self, action: #selector(setDefaultNotebook), for: .touchDown)
            
            rightEditView.addSubview(setDefault)
            setDefault.rightAnchor.constraint(equalTo: editNameButton.leftAnchor, constant: -4).isActive = true
            setDefault.centerYAnchor.constraint(equalTo: rightEditView.centerYAnchor).isActive = true
        }
        
    }
    
    @objc func cancelEdit() {
        // Remove gesture on defaultView
        defaultView.gestureRecognizers?.forEach(defaultView.removeGestureRecognizer)

        // Change defaultView position
        leftAnchorDefaultView?.isActive = false
        rightAnchorDefaultView?.isActive = false
        leftAnchorDefaultView = defaultView.leftAnchor.constraint(equalTo: leftAnchor)
        rightAnchorDefaultView = defaultView.rightAnchor.constraint(equalTo: rightAnchor)
        leftAnchorDefaultView?.isActive = true
        rightAnchorDefaultView?.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        
        // Remove rightEditView
        rightEditView.removeFromSuperview()
        
        addLeftEditView()
    }
    
    @objc func editName() {
        self.delegate?.editNotebookName(notebook: model)
    }
    
    @objc func addNoteToNotebook() {
        self.delegate?.addNoteToNotebook(notebook: model)
    }
    
    @objc func deleteNotebook() {
        self.delegate?.deleteNotebook(notebook: model)
    }
    
    @objc func setDefaultNotebook() {
        self.delegate?.setDefaultNotebook(notebook: model)
    }
}
