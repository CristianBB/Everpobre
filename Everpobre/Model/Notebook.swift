import Foundation
import CoreData

@objc(Notebook)
open class Notebook: _Notebook {
	
    convenience init(isDefaultNotebook:Bool, name: String, inContext: NSManagedObjectContext) {
        self.init(context: inContext)
        
        self.isDefaultNotebook = isDefaultNotebook
        self.creationDate = Date()
        self.name = name.uppercased()
    }
    
    convenience init(isDefaultNotebook:Bool, inContext: NSManagedObjectContext) {
        self.init(isDefaultNotebook: isDefaultNotebook, name: NSLocalizedString("My Notebook", comment: ""), inContext: inContext)
    }
    
}


extension Notebook {
    
    // This boolean implementation sucks (0=True/1=False...) but CoreData is fucking me with SortDescriptor making nosense sorts...
    var isDefaultNotebook: Bool {
        get {
            let boolValue = Bool(truncating: self.defaultNotebook!)
            return boolValue
        }
        set {
            let numValue = NSNumber(booleanLiteral: newValue)
            self.defaultNotebook = numValue
        }
    }

    
}
