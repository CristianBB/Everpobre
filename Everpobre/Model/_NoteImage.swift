// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NoteImage.swift instead.

import Foundation
import CoreData

public enum NoteImageAttributes: String {
    case image = "image"
    case position = "position"
    case scale = "scale"
}

public enum NoteImageRelationships: String {
    case note = "note"
}

open class _NoteImage: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "NoteImage"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _NoteImage.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var image: NSData

    @NSManaged open
    var position: String

    @NSManaged open
    var scale: String

    // MARK: - Relationships

    @NSManaged open
    var note: Note

}

