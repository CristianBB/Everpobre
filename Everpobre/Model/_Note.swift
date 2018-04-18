// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.swift instead.

import Foundation
import CoreData

public enum NoteAttributes: String {
    case creationDate = "creationDate"
    case endDate = "endDate"
    case tags = "tags"
    case text = "text"
    case title = "title"
}

public enum NoteRelationships: String {
    case images = "images"
    case notebook = "notebook"
}

open class _Note: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Note"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Note.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var creationDate: Date

    @NSManaged open
    var endDate: Date

    @NSManaged open
    var tags: String

    @NSManaged open
    var text: String

    @NSManaged open
    var title: String

    // MARK: - Relationships

    @NSManaged open
    var images: NSSet

    open func imagesSet() -> NSMutableSet {
        return self.images.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var notebook: Notebook

}

extension _Note {

    open func addImages(_ objects: NSSet) {
        let mutable = self.images.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.images = mutable.copy() as! NSSet
    }

    open func removeImages(_ objects: NSSet) {
        let mutable = self.images.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.images = mutable.copy() as! NSSet
    }

    open func addImagesObject(_ value: NoteImage) {
        let mutable = self.images.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.images = mutable.copy() as! NSSet
    }

    open func removeImagesObject(_ value: NoteImage) {
        let mutable = self.images.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.images = mutable.copy() as! NSSet
    }

}

