import Foundation
import CoreData

@objc(Note)
open class Note: _Note {
	
    convenience init(notebook:Notebook, inContext: NSManagedObjectContext) {
        self.init(context: inContext)
        
        self.notebook = notebook
        self.title = NSLocalizedString("New Note", comment: "New Note")
        self.text = ""
        self.tags = ""
        self.creationDate = Date()
        self.endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    }
}
