//
//  NotebooksTableViewController+Datasource.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 21/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

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
        let notebook = getNotebook(atSection: section)
        
        // Return number of Notes in Notebook
        return notebook.notes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let fc = fetchedResultsController{
            let notebook = fc.object(at: IndexPath(row: section, section: 0)) as! Notebook
            let headerFrame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.sectionHeaderHeight)
            let headerView = NotebookHeader(frame: headerFrame, model:notebook, isEditing: tableView.isEditing)
            headerView.delegate = self
            return headerView
        }else{
            return nil
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
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get Note
        let note = getNote(atIndexPath: indexPath)
        
        // Create Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NotebookCell
        cell.note = note
        cell.accessibilityIdentifier = note.objectID.uriRepresentation().absoluteString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Note
        let note = getNote(atIndexPath: indexPath)
        
        // Create NoteViewController
        self.showNote(note: note)
    }
    
    // User delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // Get Note
            let note = getNote(atIndexPath: indexPath)
            
            // Create UIAlertController
            let askString1 = NSLocalizedString("Removing Note with Title", comment: "")
            let askString2 = note.title
            let askString3 = NSLocalizedString("This action cannot be undone, are you sure?", comment: "")
            let actionTitle = "\(askString1) \n \(askString2) \n \(askString3)"
            let actionSheetAlert = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
            
            // Action for Yes
            let actionYes = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (alertAction) in
                // Check if note Displayed is the same that the Note deleted to change DetailVC
                if let noteDisplayed = self.getNoteDisplayed() {
                    if (noteDisplayed.objectID == note.objectID) {
                        let instructionsVC = BlankViewController()
                        self.splitViewController?.showDetailViewController(instructionsVC, sender: self)
                    }
                }
                
                // Delete on CoreData
                CoreDataContainer.default.viewContext.delete(note)
                
                // Save changes
                self.saveChanges()
                
                // Reload Table
                tableView.reloadData()
            }
            
            let actionNo = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .destructive, handler: nil)
            
            actionSheetAlert.addAction(actionYes)
            actionSheetAlert.addAction(actionNo)
            
            actionSheetAlert.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: indexPath)
            present(actionSheetAlert, animated: true, completion: nil)
        }
    }
    
}

// MARK: - UIPickerViewDataSource
extension NotebooksTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOptions[row].name
    }
    
}
