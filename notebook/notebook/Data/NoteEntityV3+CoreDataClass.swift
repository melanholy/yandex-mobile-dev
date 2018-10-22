////
////  NoteEntityV3+CoreDataClass.swift
////
////
////  Created by Павел Кошара on 22/04/2018.
////
////
//
//import Foundation
//import CoreData
//
//@objc(NoteEntity)
//public class NoteEntity: NSManagedObject {
//    func toNote() -> Note? {
//        guard let uid = uid,
//            let title = title,
//            let content = content,
//            let importance = Importance.init(rawValue: Int(importance)),
//            let color = color else {
//                return nil
//        }
//
//        return Note(
//            uid: uid,
//            title: title,
//            content: content,
//            color: color,
//            importance: importance,
//            destroyDate: destroyDate)
//    }
//
//    func fill(from note: Note) {
//        uid = note.uid
//        title = note.title
//        content = note.content
//        importance = Int16(note.importance.rawValue)
//        color = note.color
//        destroyDate = note.destroyDate
//    }
//}
