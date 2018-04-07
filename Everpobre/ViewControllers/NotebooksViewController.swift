//
//  NotebooksViewController.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 7/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

struct imageCoreData {
    var objectid: String
    var image: UIImage
}

struct Note {
    var title: String
    var creationDate: Date
    var endDate: Date
    var tags: [String]?
    var images: [imageCoreData]?
    var text: String
    var notebook: Notebook?
}

struct Notebook {
    var name: String
    var notes: [Note]
}


class NotebooksViewController: UITableViewController {

    // MARK: - Properties
    var model: [Notebook]
    
    // MARK: - Initialization
    init(model: [Notebook]) {
        self.model = model
        
        // Si se pasa nil en nibname, usará por defecto los que tengan el mismo nombre de la clase
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        
        title = "Everpobre"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentNotebook = model[section]
        return currentNotebook.notes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentNotebook = model[section]
        return currentNotebook.name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId")

        let currentNotebook = model[indexPath.section]
        let currentNote = currentNotebook.notes[indexPath.row]
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        }
        
        cell?.textLabel?.text = currentNote.title
        cell?.detailTextLabel?.text = "created: \(currentNote.creationDate) end: \(currentNote.endDate)"
        
        return cell!
    }

}
