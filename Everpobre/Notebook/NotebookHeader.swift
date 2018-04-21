//
//  NotebookCell.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 21/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

class NotebookHeader: UIView {
    
    var notebook: Notebook? {
        didSet {
            // nameLabel
            if (notebook?.name == "") {
                nameLabel.text = NSLocalizedString("-- No Name --", comment: "").uppercased()
            } else {
                nameLabel.text = notebook?.name.uppercased()
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            // creationDateLabel
            let creationPrefix = NSLocalizedString("Created:", comment: "")
            let creationString = dateFormatter.string(from: (notebook?.creationDate)!)
            creationDateLabel.text = "\(creationPrefix) \(creationString)"
            
            // defaultLabel
            var defaultString = ""
            if (notebook?.isDefaultNotebook)! {
                defaultString = NSLocalizedString("Default Notebook", comment: "")
            }
            
            defaultLabel.text = defaultString
        }
    }
    
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
    
    let defaultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .cyan
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        
        addSubview(creationDateLabel)
        creationDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        creationDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        creationDateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(defaultLabel)
        defaultLabel.topAnchor.constraint(equalTo: creationDateLabel.topAnchor).isActive = true
        defaultLabel.leftAnchor.constraint(equalTo: creationDateLabel.rightAnchor, constant: 4).isActive = true
        defaultLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
