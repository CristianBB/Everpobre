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
        backgroundColor = .cyan
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
        nameLabel.leftAnchor.constraint(equalTo: defaultView.leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: defaultView.rightAnchor, constant: -40).isActive = true
        
        defaultView.addSubview(creationDateLabel)
        creationDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        creationDateLabel.leftAnchor.constraint(equalTo: defaultView.leftAnchor, constant: 8).isActive = true
        creationDateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        if (isEditing) {
            addLeftEditView()
            
        } else {
            nameLabel.isUserInteractionEnabled = false
            leftAnchorDefaultView?.isActive = true
            if (model.isDefaultNotebook) {
                // defaultImage
                defaultView.addSubview(defaultImage)
                defaultImage.topAnchor.constraint(equalTo: defaultView.topAnchor, constant: 4).isActive = true
                defaultImage.rightAnchor.constraint(equalTo: defaultView.rightAnchor, constant: -4).isActive = true
                defaultImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
                defaultImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
            }
            
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
        editButton.frame.size = CGSize(width: 30, height: 30)
        editButton.setImage(#imageLiteral(resourceName: "edit.png"), for: .normal)
        editButton.layer.masksToBounds = false
        editButton.layer.cornerRadius = editButton.frame.width / 2
        editButton.addTarget(self, action: #selector(addRightEditView), for: .touchDown)
        
        leftEditView.addSubview(editButton)
        leftEditView.translatesAutoresizingMaskIntoConstraints = false
        editButton.leftAnchor.constraint(equalTo: leftEditView.leftAnchor).isActive = true
        editButton.topAnchor.constraint(equalTo: leftEditView.topAnchor).isActive = true
    }
    
    @objc func addRightEditView() {
        rightEditView.backgroundColor = .red
        addSubview(rightEditView)
        rightEditView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightEditView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightEditView.widthAnchor.constraint(equalToConstant: 190).isActive = true
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
    
    func addNoteToNotebook() {
        self.delegate?.addNoteToNotebook(notebook: model)
    }
    
    func deleteNotebook() {
        self.delegate?.deleteNotebook(notebook: model)
    }
    
    func setDefaultNotebook() {
        self.delegate?.setDefaultNotebook(notebook: model)
    }
}
