//
//  NotebookCell.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 21/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

class NotebookCell: UITableViewCell {
    
    var note: Note? {
        didSet {
            // titleLabel
            if (note?.title == "") {
                titleLabel.text = NSLocalizedString("-- No Title --", comment: "")
            } else {
                titleLabel.text = note?.title
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            // creationDateLabel
            let creationPrefix = NSLocalizedString("Created:", comment: "")
            let creationString = dateFormatter.string(from: (note?.creationDate)!)
            creationDateLabel.text = "\(creationPrefix) \(creationString)"
            
            // endDateLabel
            let endPrefix = NSLocalizedString("Expires:", comment: "")
            let endString = dateFormatter.string(from: (note?.endDate)!)
            endDateLabel.text = "\(endPrefix) \(endString)"
            
            // tagsLabel
            let tagsPrefix = NSLocalizedString("Tags:", comment: "")
            let tagsString = note?.tags
            tagsLabel.text = "\(tagsPrefix) \(tagsString ?? "")"
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessibilityIdentifier = note?.objectID.uriRepresentation().absoluteString
        backgroundColor = UIColor(red:0.57, green:1.00, blue:1.00, alpha:1.0)
        
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4).isActive = true
        
        contentView.addSubview(creationDateLabel)
        creationDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        creationDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4).isActive = true
        creationDateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        contentView.addSubview(endDateLabel)
        endDateLabel.topAnchor.constraint(equalTo: creationDateLabel.topAnchor).isActive = true
        endDateLabel.leftAnchor.constraint(equalTo: creationDateLabel.rightAnchor, constant: 4).isActive = true
        endDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4).isActive = true
        
        contentView.addSubview(tagsLabel)
        tagsLabel.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor, constant: 4).isActive = true
        tagsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4).isActive = true
        tagsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
