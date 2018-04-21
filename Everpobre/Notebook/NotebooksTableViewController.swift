//
//  NotebooksViewController.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 7/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit
import CoreData

struct imageCoreDataDummy {
    var objectid: String
    var image: UIImage
    var originalFrame: String
    var actualFrame: String
}

struct NoteDummy {
    var title: String
    var creationDate: Date
    var endDate: Date
    var tags: [String]?
    var images: [imageCoreDataDummy]?
    var text: String
    var notebook: NotebookDummy?
}

struct NotebookDummy {
    var name: String
    var notes: [NoteDummy]
}


class NotebooksTableViewController: UITableViewController {

    // MARK:  - Properties
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?{
        didSet{
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
            tableView.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        title = NSLocalizedString("Notebooks", comment: "")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = CoreDataContainer.default.viewContext
        
        // Register cellId
        tableView.register(NotebookCell.self, forCellReuseIdentifier: "cellId")
        
        // Create FetchedResultsController
        let notebookRequest = Notebook.fetchRequest()
        notebookRequest.fetchBatchSize = 50
        
        notebookRequest.sortDescriptors = [ NSSortDescriptor(key: NotebookAttributes.defaultNotebook.rawValue, ascending: false),
                                            NSSortDescriptor(key: NotebookAttributes.name.rawValue, ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: notebookRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        self.fetchedResultsController = frc
    }

}

// MARK:  - Table Data Source
extension NotebooksTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let fc = self.fetchedResultsController{
            guard let sections = fc.fetchedObjects else {
                return 1
            }
            return sections.count
        }else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get the Notebook
        let notebook = self.fetchedResultsController?.object(at: IndexPath(row: section, section: 0)) as! Notebook
        
        // Return number of Notes in Notebook
        return notebook.notes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let fc = fetchedResultsController{
            let notebook = fc.object(at: IndexPath(row: section, section: 0)) as! Notebook
            return notebook.name
        }else{
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let fc = fetchedResultsController{
            return fc.section(forSectionIndexTitle: title, at: index)
        }else{
            return 0
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let fc = fetchedResultsController{
            return  fc.sectionIndexTitles
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the Notebook
        let notebook = self.fetchedResultsController?.object(at: IndexPath(row: indexPath.section, section: 0)) as! Notebook
        
        // Convert Notes to Array an apply order cause NSSet is unordered and every cycle returns the objects in distinct order
        var notesArray = notebook.notes.allObjects as! [Note]
        notesArray.sort {
            if $0.title != $1.title {
                return $0.title < $1.title
            } else {
                return $0.creationDate < $1.creationDate
            }
        }
        
        // Get the Note
        let note = notesArray[indexPath.row]
        
        // Create Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NotebookCell
        cell.note = note
        cell.accessibilityIdentifier = note.objectID.uriRepresentation().absoluteString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the Notebook
        let notebook = self.fetchedResultsController?.object(at: IndexPath(row: indexPath.section, section: 0)) as! Notebook
        
        // Convert Notes to Array an apply order cause NSSet is unordered and every cycle returns the objects in distinct order
        var notesArray = notebook.notes.allObjects as! [Note]
        notesArray.sort {
            if $0.title != $1.title {
                return $0.title < $1.title
            } else {
                return $0.creationDate < $1.creationDate
            }
        }
        
        // Get the Note selected
        let note = notesArray[indexPath.row]
        
        // Create NoteViewController
        let noteVC = NoteViewController(model: note)
        noteVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: noteVC)
        self.splitViewController?.showDetailViewController(navVC, sender: self)
    }

}

// MARK:  - Fetches
extension NotebooksTableViewController {
    
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }
    }
}


// MARK:  - NSFetchedResultsControllerDelegate
extension NotebooksTableViewController: NSFetchedResultsControllerDelegate{
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let set = IndexSet(integer: sectionIndex)
        
        switch (type){
            
        case .insert:
            tableView.insertSections(set, with: .fade)
            
        case .delete:
            tableView.deleteSections(set, with: .fade)
            
        default:
            // irrelevant in our case
            break
            
        }
    }
    
    
    // This method only receives changes on Sections
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.syncRowWithDetail()
        }
    }
}

extension NotebooksTableViewController: NoteViewControllerDelegate {
    func didChange(note: Note, type: typeOfNoteChange) {
        
        // Save context
        if CoreDataContainer.default.viewContext.hasChanges{
            do{
                try CoreDataContainer.default.viewContext.save()
            } catch let error {
                fatalError("Error saving context: \(error)")
            }
        }
        
        // Validate if changes affects to row sortening
        if (type == .title || type == .expirationDate || type == .tags) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.syncRowWithDetail()
            }
        }
    }
}

// MARK: - Commons
extension NotebooksTableViewController {
    // Sync row selected with detail VC displayed
    func syncRowWithDetail() {
        
        // If splitViewController is collapsed, we dont care about row selected
        if ((self.splitViewController?.isCollapsed)! == false) {
            var noteDisplayed: Note?
            
            // Get reference to actual detail view
            let detailNavVC = self.splitViewController?.viewControllers[1] as! UINavigationController
            for actVC in detailNavVC.viewControllers {
                if let detailVC = actVC as? NoteViewController {
                    noteDisplayed = detailVC.model
                }
            }
            
            // Get the cell that matches with Note displayed and selects it
            let cells = self.tableView.visibleCells
            for cell in cells {
                if (cell.accessibilityIdentifier == noteDisplayed?.objectID.uriRepresentation().absoluteString) {
                    self.tableView.selectRow(at: self.tableView.indexPath(for: cell), animated: true, scrollPosition: .bottom)
                }
            }
        }
        
    }
}

