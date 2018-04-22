//
//  NotebooksTableViewController+Delegates.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 21/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit
import CoreData

// MARK:  - NSFetchedResultsControllerDelegate
extension NotebooksTableViewController: NSFetchedResultsControllerDelegate{
    
    // This method only receives changes over Sections
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        DispatchQueue.main.async {
            self.saveChanges()
            self.tableView.reloadData()
            self.syncRowWithDetail()
        }

    }
}

// MARK:  - NoteViewControllerDelegate
extension NotebooksTableViewController: NoteViewControllerDelegate {
    func didChange(note: Note, type: typeOfNoteChange) {
        
        self.saveChanges()
        
        // Validate if changes affects to info displayed or row sortening
        if (type == .title || type == .expirationDate || type == .tags) {
            
            // Find IndexPath of Note changed and reload section to wich it belongs
            guard let indexPath = getIndexPath(forNote: note) else { return }
            self.tableView.reloadSections([indexPath.section], with: .none)
            self.syncRowWithDetail()
        }
    }
}

// MARK: - NotebookHeaderDelegate
extension NotebooksTableViewController: NotebookHeaderDelegate {
    func addNoteToNotebook(notebook: Notebook, sender: UIView) {
        // Add Note
        let newNote = Note(notebook: notebook, inContext: CoreDataContainer.default.viewContext)
        
        // Show note added on detail
        self.showNote(note: newNote)
        
        // Save
        self.saveChanges()
    }
    
    func deleteNotebook(notebook: Notebook, sender: UIView) {
        if (notebook.isDefaultNotebook) {
            let title = NSLocalizedString("Not Allowed", comment: "")
            let message = NSLocalizedString("Default Notebook cannot be deleted", comment: "")
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .destructive)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            let title = NSLocalizedString("Delete Notebook", comment: "")
            var message = ""
            var action1: UIAlertAction?
            var action2: UIAlertAction?
            
            if (notebook.notes.count == 0) {
                message = NSLocalizedString("This action cannot be undone, are you sure?", comment: "")
                action1 = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .default, handler:  { alert -> Void in
                    self.deleteNotebookWithoutUpdating(notebook: notebook)
                })
            } else {
                message = NSLocalizedString("This notebook has associated notes, what do you want to do?", comment: "")
                
                action1 = UIAlertAction(title: NSLocalizedString("DELETE Notebook", comment: ""), style: .default, handler:  { alert -> Void in
                    self.deleteNotebookWithoutUpdating(notebook: notebook)
                })
                
                action2 = UIAlertAction(title: NSLocalizedString("ASSOCIATE notes to another book", comment: ""), style: .default, handler:  { alert -> Void in
                    self.deleteNotebookUpdatingNotes(notebook: notebook)
                })
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            
            alertController.addAction(action1!)
            if (action2 != nil) {
                alertController.addAction(action2!)
            }
            alertController.addAction(cancelAction)
            
            alertController.popoverPresentationController?.sourceView = sender
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setDefaultNotebook(notebook: Notebook, sender: UIView) {
        // Get default Notebook
        guard let defaultNotebook = getDefaultNotebook() else { return }
        
        // Update default Notebook
        defaultNotebook.isDefaultNotebook = false
        
        // Update notebook received and sets as new default notebook
        notebook.isDefaultNotebook = true
        
        // Save changes
        self.saveChanges()
    }
    
    func editNotebookName(notebook: Notebook, sender: UIView) {
        let alertController = UIAlertController(title: NSLocalizedString("Edit Notebook Name", comment: ""), message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = NSLocalizedString("Notebook Name", comment: "")
            textField.text = notebook.name
        }
        
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            notebook.name = textField.text!
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - UIPickerViewDelegate
extension NotebooksTableViewController: UIPickerViewDelegate {
    
}
