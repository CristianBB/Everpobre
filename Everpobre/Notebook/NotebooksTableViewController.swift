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
    
    var pickOptions:[Notebook] = []
    
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
        tableView.tableFooterView = UIView()
        
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
    
    // Returns Note associated to an IndexPath
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
    
    // Returns Default Notebook
    func getDefaultNotebook() -> Notebook? {
        let req = Notebook.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "defaultNotebook == %@", NSNumber(booleanLiteral: true))
        guard let results = try? CoreDataContainer.default.viewContext.fetch(req) as! [Notebook] else { return nil}
        let defaultNotebook = results[0]
        return defaultNotebook
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
    
    // Returns Note displayed on detail if there is a Note displayed, if not return nil
    func getNoteDisplayed() -> Note? {
        var noteDisplayed: Note?
        
        // If splitViewController is collapsed or Detail not exists, we dont care about note displayed
        if ((self.splitViewController?.isCollapsed)! || self.splitViewController?.viewControllers.count == 0) {
            return nil
        } else {
            // Get reference to actual detail view
            guard let detailNavVC = self.splitViewController?.viewControllers[1] as? UINavigationController else { return nil }
            for actVC in detailNavVC.viewControllers {
                if let detailVC = actVC as? NoteViewController {
                    noteDisplayed = detailVC.model
                    return noteDisplayed
                }
            }
        }
        
        return nil
    }
    
    // Returns IndexPath for a Note
    func getIndexPath(forNote note: Note) -> IndexPath? {
        
        // Iterate throuth sections
        for section in 0..<tableView.numberOfSections {
            // Iterate throug cells
            for row in 0..<tableView.numberOfRows(inSection: section) {
                // Search for Note on fetchedResultsController that matches with Note displayed and selects it
                let noteAct = self.getNote(atIndexPath: IndexPath(row: row, section: section))
                if (noteAct.objectID == note.objectID) {
                    return IndexPath(row: row, section: section)
                }
            }
        }
        
        return nil
    }
    
    // Sync row selected with detail VC displayed
    func syncRowWithDetail() {
        
        guard let noteDisplayed = getNoteDisplayed() else { return }
        guard let indexPath = getIndexPath(forNote: noteDisplayed) else { return }
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        
    }
    
    // Show Note in Detail
    func showNote(note: Note) {
        let noteVC = NoteViewController(model: note)
        noteVC.delegate = self
        let noteNavVC = UINavigationController(rootViewController: noteVC)
        self.splitViewController?.showDetailViewController(noteNavVC, sender: self)
    }
    
    // User press edit button
    @objc func editButtonPressed() {
        // CATransaction to keep rows animation while activate/deactivate edition mode
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // Reload sections to activate/deactivate edition mode when  animation finish
            let range: Range = 0..<self.tableView.numberOfSections
            let sections = IndexSet(integersIn: range)
            
            self.tableView.reloadSections(sections, with: .none)
        }
        if (tableView.isEditing) {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
        CATransaction.commit()
        
    }
    
    // User press addNote button
    @objc func addNoteButtonPressed() {
        
        // Get Default Notebook
        guard let defaultNotebook = getDefaultNotebook() else { return }
        
        // Add Note
        let newNote = Note(notebook: defaultNotebook, inContext: CoreDataContainer.default.viewContext)
        
        // Show note added on detail
        self.showNote(note: newNote)
        
        // Save
        self.saveChanges()
        
    }
    
    // User press addNotebook button
    @objc func addNotebookButtonPressed() {
        
        let alertController = UIAlertController(title: NSLocalizedString("New Notebook", comment: ""), message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Notebook Name", comment: "")
        }
        
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            let notebookName = textField.text
            let _ = Notebook(isDefaultNotebook: false, name: notebookName!, inContext: CoreDataContainer.default.viewContext)
            
            self.saveChanges()
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteNotebookWithoutUpdating(notebook: Notebook) {
        // Get note Displayed on detail por sync purposes
        if let noteDisplayed = self.getNoteDisplayed() {
            // If one of the notes from the Notebook to be deleted is being showed, change detail view
            if (notebook.notes.contains(noteDisplayed)) {
                let instructionsVC = InstructionsViewController()
                self.splitViewController?.showDetailViewController(instructionsVC, sender: self)
            }
        }
        
        // Remove notebook
        CoreDataContainer.default.viewContext.delete(notebook)
        
        // Save changes
        self.saveChanges()
    }
    
    // AllertController to associate all Notes from a Notebook to a new Notebook selected by user and DELETE notebook
    func deleteNotebookUpdatingNotes(notebook: Notebook) {
        self.loadPickOptions(forNotebook: notebook)
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        
        let chooseNotebookAlert = UIAlertController(title: NSLocalizedString("Select Notebook", comment: ""), message: "", preferredStyle: .alert)
        chooseNotebookAlert.setValue(vc, forKey: "contentViewController")
        
        let selectAction = UIAlertAction(title: NSLocalizedString("Select", comment: ""), style: .default, handler: { alert -> Void in
            let selectedNotebook = self.pickOptions[pickerView.selectedRow(inComponent: 0)]

            // Get note Displayed on detail por sync purposes
            let noteDisplayed = self.getNoteDisplayed()
            
            // Update Notes from Notebook to remove
            for noteAct in notebook.notes as! Set<Note> {
                noteAct.notebook = selectedNotebook
                
                // if note displayed is one of the notes updated, shows it
                if (noteAct.objectID == noteDisplayed?.objectID) {
                    self.showNote(note: noteAct)
                }
            }
            
            // Remove notebook
            CoreDataContainer.default.viewContext.delete(notebook)
            
            // Save changes
            self.saveChanges()
            
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        chooseNotebookAlert.addAction(selectAction)
        chooseNotebookAlert.addAction(cancelAction)
        
        self.present(chooseNotebookAlert, animated: true)
      
    }
    
    // Load pickOptions excluding Notebook to be removed
    func loadPickOptions(forNotebook notebook: Notebook) {
        pickOptions = []
        
        // Only add Notebooks distincts to Notebook to be removed
        if let fc = fetchedResultsController {
            for notebookAct in fc.fetchedObjects as! [Notebook] {
                if (notebook.objectID != notebookAct.objectID) {
                    pickOptions.append(notebookAct)
                }
            }
        }
    }
    
}

