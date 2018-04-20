import UIKit
import CoreData

@objc(NoteImage)
open class NoteImage: _NoteImage {
	
    convenience init(image: UIImage, positionFrame: CGRect, note: Note, inContext: NSManagedObjectContext) {
        self.init(context: inContext)
        
        self.image = image
        self.originalFrame = positionFrame
        self.actualFrame = positionFrame
        self.note = note
    }
}

extension NoteImage {
    var image: UIImage{
        
        get {
            // NSData -> Image
            let img = UIImage(data: self.imageData as Data)
            return img!
        }
        
        set {
            // UIImage -> NSData
            let data = UIImageJPEGRepresentation(newValue, 1)
            self.imageData = data! as NSData
        }
    }
    
    var originalFrame: CGRect {
        
        get {
            // NSString -> CGRect
            let rect = CGRectFromString(self.originalFrameString)
            return rect
        }
        
        set {
            // CGRect -> NSString
            let str = NSStringFromCGRect(newValue)
            self.originalFrameString = str
        }
    }
    
    var actualFrame: CGRect {
        
        get {
            // NSString -> CGRect
            let rect = CGRectFromString(self.actualFrameString)
            return rect
        }
        
        set {
            // CGRect -> NSString
            let str = NSStringFromCGRect(newValue)
            self.actualFrameString = str
        }
    }

}
