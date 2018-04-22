//
//  CoreDataContainer.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 18/4/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataContainer {
    
    static var `default`:KCPersistentContainer = {
        let c = KCPersistentContainer(name: "Everpobre")
        c.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                fatalError("Error loading Persistent Stores \(description)")
            }
        })
        
        return c
    }()
}

open class
KCPersistentContainer : NSPersistentContainer{

    open
    func zapAllData(){
        
        let container = CoreDataContainer.default
        let coord = container.persistentStoreCoordinator
        
        let url = type(of:self).defaultDirectoryURL()
        let model = url.appendingPathComponent("Everpobre.sqlite")
        
        // Delete store
        do{
            try coord.destroyPersistentStore(at: model, ofType: NSSQLiteStoreType, options: nil)
        }catch{
            fatalError("Error while deleting persistent coord")
        }
        
        // Create store
        do{
            let _ = try coord.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: model, options: nil)
        }catch{
            fatalError("Error while trying to add store")
        }
        
    }
}


func loadFakeCoreData() {
    
    CoreDataContainer.default.zapAllData()
    
    let context = CoreDataContainer.default.viewContext
    
    // Notebook por defecto
    let nbdefecto = Notebook(isDefaultNotebook: true, name: "Default Notebook", inContext: context)
    
    // Notebook nuevo
    let nbnuevo = Notebook(isDefaultNotebook: false, name: "Todo", inContext: context)
    let nbnuevo2 = Notebook(isDefaultNotebook: false, name: "Notes", inContext: context)
    
    // Notas
    let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et tempus sem. Aenean sed dolor ex. Duis at tellus a magna consectetur ullamcorper tristique sit amet nisi. Proin enim orci, rutrum in sem in, faucibus finibus turpis. Morbi scelerisque enim at sapien auctor iaculis. Quisque interdum leo quis arcu cursus dictum. Aenean elit lorem, porta malesuada mollis at, egestas quis nibh. Morbi feugiat nunc purus, in posuere sapien tincidunt a. Aenean tempor eros sapien, sed pulvinar velit volutpat ac. Etiam ut eros dui. Nunc ultricies dolor ac orci rutrum fermentum. Nulla et nunc vel est tempus ornare. Nulla suscipit felis nec gravida ullamcorper. Suspendisse neque lacus, lobortis ac diam id, fermentum suscipit justo. Quisque lobortis sit amet sapien et fringilla. Nullam vel elit et diam consequat ultrices quis at elit. Donec nec posuere elit. Morbi sed efficitur ligula. Etiam imperdiet rhoncus dignissim. Vestibulum et velit enim. Donec nec luctus lectus, eu tincidunt purus."
    
    let nota1 = Note(notebook: nbdefecto, inContext: context)
    let nota2 = Note(notebook: nbdefecto, inContext: context)
    let nota3 = Note(notebook: nbnuevo, inContext: context)
    let nota4 = Note(notebook: nbnuevo, inContext: context)
    let nota5 = Note(notebook: nbnuevo, inContext: context)
    let nota6 = Note(notebook: nbnuevo, inContext: context)
    let nota7 = Note(notebook: nbnuevo, inContext: context)
    let nota8 = Note(notebook: nbnuevo, inContext: context)
    let nota9 = Note(notebook: nbnuevo, inContext: context)
    let nota10 = Note(notebook: nbnuevo2, inContext: context)
    nota1.title = "Nota01"
    nota1.text = lorem
    nota2.title = "Nota02"
    nota2.text = lorem
    nota3.title = "Nota03"
    nota3.text = lorem
    nota4.title = "Nota04"
    nota4.text = lorem
    nota5.title = "Nota05"
    nota5.text = lorem
    nota6.title = "Nota06"
    nota6.text = lorem
    nota7.title = "Nota07"
    nota7.text = lorem
    nota8.title = "Nota08"
    nota8.text = lorem
    nota9.title = "Nota09"
    nota9.text = lorem
    nota10.title = "Nota10"
    nota10.text = lorem
    
 
    if context.hasChanges{
        do{
            try context.save()
        } catch let error {
            fatalError("Error saving context: \(error)")
        }
    }
    
}
