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
    
        let editButton = UIButton(type: .system)
        editButton.setImage(#imageLiteral(resourceName: "edit.png"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let editBarButton = UIBarButtonItem(customView: editButton)
        
        let addNoteButton = UIButton(type: .system)
        addNoteButton.setImage(#imageLiteral(resourceName: "addNote.png"), for: .normal)
        addNoteButton.addTarget(self, action: #selector(addNoteButtonPressed), for: .touchUpInside)
        addNoteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let addNoteBarButton = UIBarButtonItem(customView: addNoteButton)
        
        let addNotebookButton = UIButton(type: .system)
        addNotebookButton.setImage(#imageLiteral(resourceName: "addBook.png"), for: .normal)
        addNotebookButton.addTarget(self, action: #selector(addNotebookButtonPressed), for: .touchUpInside)
        addNotebookButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let addNotebookBarButton = UIBarButtonItem(customView: addNotebookButton)
        
        self.navigationItem.rightBarButtonItems = [editBarButton, addNoteBarButton, addNotebookBarButton]
        
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

// MARK: - Commons
extension NotebooksTableViewController {
    // Save changes in context
    func saveChanges() {
        if CoreDataContainer.default.viewContext.hasChanges{
            do{
                try CoreDataContainer.default.viewContext.save()
            } catch let error {
                fatalError("Error saving context: \(error)")
            }
        }
    }
    
    // Return the Notebook associated to section
    func getNotebook(atSection section: Int) -> Notebook {
        let notebook = self.fetchedResultsController?.object(at: IndexPath(row: section, section: 0)) as! Notebook
        return notebook
    }
    
    // Return Note associated to an IndexPath
    func getNote(atIndexPath indexPath: IndexPath) -> Note {
        let notebook = getNotebook(atSection: indexPath.section)
        
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
        
        return note
    }
    
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
                
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }
    }
    
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
    
    @objc func editButtonPressed() {
        if (tableView.isEditing) {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
    
    @objc func addNoteButtonPressed() {
        
    }
    
    @objc func addNotebookButtonPressed() {
        
    }
}

