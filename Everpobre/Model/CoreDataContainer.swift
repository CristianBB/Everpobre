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
    let nbdefecto = Notebook(isDefaultNotebook: true, name: "z", inContext: context)
    
    // Notebook nuevo
    let nbnuevo = Notebook(isDefaultNotebook: false, name: "b", inContext: context)
    let nbnuevo2 = Notebook(isDefaultNotebook: false, name: "a", inContext: context)
    
    // Notas
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
    nota2.title = "Nota02"
    nota3.title = "Nota03"
    nota4.title = "Nota04"
    nota5.title = "Nota05"
    nota6.title = "Nota06"
    nota7.title = "Nota07"
    nota8.title = "Nota08"
    nota9.title = "Nota09"
    nota10.title = "Nota10"
    
    // Imagenes
    let testImage = #imageLiteral(resourceName: "imagencita.png")
    let targetWidth: CGFloat = 200.0
    let scaleFactor = targetWidth / testImage.size.width
    let targetHeight = testImage.size.height * scaleFactor
    let targetSize = CGSize(width: targetWidth, height: targetHeight)
    let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
    UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
    testImage.draw(in: rect)
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota1, inContext: context)
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota2, inContext: context)
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota3, inContext: context)
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota4, inContext: context)
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota5, inContext: context)
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota6, inContext: context)
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota7, inContext: context)
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota8, inContext: context)
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota9, inContext: context)
    _ = NoteImage(image: scaledImage!, positionFrame: rect, note: nota10, inContext: context)
 
    if context.hasChanges{
        do{
            try context.save()
        } catch let error {
            fatalError("Error saving context: \(error)")
        }
    }
    
}
