//
//  NoteEntityV3+CoreDataProperties.swift
//  
//
//  Created by Павел Кошара on 22/04/2018.
//
//

import Foundation
import CoreData


extension NoteEntityV3 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntityV3> {
        return NSFetchRequest<NoteEntityV3>(entityName: "NoteEntity")
    }

    @NSManaged public var color: UIColor?
    @NSManaged public var content: String?
    @NSManaged public var destroyDate: NSDate?
    @NSManaged public var importance: Int16
    @NSManaged public var title: String?
    @NSManaged public var uid: String?

}
