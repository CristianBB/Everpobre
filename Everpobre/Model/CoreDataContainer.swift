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

// Returns TRUE if there is data in PersistentStore, else returns FALSE
func storeLoaded() -> Bool {
    let context = CoreDataContainer.default.viewContext
    
    // Search Notebooks (Always must be at least defaul Notebook)
    let req = Notebook.fetchRequest()
    req.fetchLimit = 1

    guard let results = try? context.fetch(req) as! [Notebook]  else { return false }
    
    if (results.count == 0) {
        return false
    }
    
    return true
}

// Load Default Data un Persistent Store
func loadData() {
    let context = CoreDataContainer.default.viewContext
    
    // Notebook por defecto
    let defaultNotebook = Notebook(isDefaultNotebook: true, name: NSLocalizedString("My Notebook", comment: ""), inContext: context)
    
    // First Note
    let noteText = "Bienvenido a EverPobre\n\n\nEstas son algunas de las características de la aplicación\n\n\n- Agrega Notas rápidas mediante el icono de la barra de navegación. Las notas agregadas desde aquí serán incluidas directamente en la libreta definida por defecto\n\n- Agrega tantas libretas como quieras\n\n- Si quieres agregar una nota directamente a una libreta, utiliza el botón de agregar nota asociado a la Libreta a la que desees añadir la nota\n\n- Agrega tantas imágenes como quieras dentro de las notas, para agregar una imagen únicamente debes realizar una pulsación larga sobre un área vacía dentro del área de texto de la nota. Al realizar la acción podrás seleccionar como quieres añadir la imagen: Desde la galería, Desde la Camara de fotos o introduciendo una localización para agregar un mapa a la nota.\n\n- Para entrar en el modo Edición de imagen, pulsa dos veces sobre la imagen hasta que veas que aparece un borde de color rojo a su alrededor. En el modo edición podrás rotar la imagen (mediante deslizamientos a izquierda o derecha), escalarla (realizando un pinzamiento con los dedos), o eliminarla (realizando un desplazamiento hacia abajo)\n\n- Mueve las imágenes libremente por el interior de la nota. Para mover una imagen simplemente tienes que realizar una pulsación larga sobre la imagen que deseas mover hasta que aparezca un borde de color verde a su alrededor.\n\n- Para eliminar una Nota, pulsa el icono de Edición de la barra de navegación para entrar en el modo de Edición. Aparecerá un botón que te permitirá seleccionar la nota que desees eliminar\n\n- Para editar, eliminar o poner por defecto una libreta procede del mismo modo que para editar una Nota. Cada libreta tiene un botón de edición asociado que, una vez pulsado, te permitirá acceder a las distintas opciones de edición de la libreta.\n\n\nDisfruta la aplicación!\n"
    let defaultNote = Note(notebook: defaultNotebook, inContext: context)
    defaultNote.title = "Bienvenido a Everpobre"
    defaultNote.text = noteText
    
    if context.hasChanges{
        do{
            try context.save()
        } catch let error {
            fatalError("Error saving context: \(error)")
        }
    }

}

// Load Dummy data for test purposes
func loadDummyData() {
    
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
