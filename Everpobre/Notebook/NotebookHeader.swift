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
    
    var nameLabel: UILabel = {
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
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        
        // creationDateLabel
        let creationPrefix = NSLocalizedString("Created:", comment: "")
        let creationString = dateFormatter.string(from: model.creationDate)
        creationDateLabel.text = "\(creationPrefix) \(creationString)"
        
        addSubview(creationDateLabel)
        creationDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        creationDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        creationDateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        if (isEditing) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editName))
            tapGesture.numberOfTapsRequired = 1
            nameLabel.isUserInteractionEnabled = true
            nameLabel.addGestureRecognizer(tapGesture)
        } else {
            nameLabel.isUserInteractionEnabled = false
            if (model.isDefaultNotebook) {
                // defaultImage
                addSubview(defaultImage)
                defaultImage.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
                defaultImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
                defaultImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
                defaultImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
            }
            
        }
    }
}

extension NotebookHeader {
    
    @objc func editName() {
        self.delegate?.editNotebookName(notebook: model)
    }
}
