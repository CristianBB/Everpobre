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

// MARK:  - NoteViewControllerDelegate
extension NotebooksTableViewController: NoteViewControllerDelegate {
    func didChange(note: Note, type: typeOfNoteChange) {
        
        self.saveChanges()
        
        // Validate if changes affects to row sortening
        if (type == .title || type == .expirationDate || type == .tags) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.syncRowWithDetail()
            }
        }
    }
}
