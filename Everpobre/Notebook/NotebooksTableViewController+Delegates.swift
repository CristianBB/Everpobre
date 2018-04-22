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
    func addNoteToNotebook(notebook: Notebook) {
        
    }
    
    func deleteNotebook(notebook: Notebook) {
        
    }
    
    func setDefaultNotebook(notebook: Notebook) {
        
    }
    
    func editNotebookName(notebook: Notebook) {
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
