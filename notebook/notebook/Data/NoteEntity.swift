////
////  NoteEntity.swift
////  notebook
////
////  Created by Павел Кошара on 21/04/2018.
////  Copyright © 2018 user. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//extension NoteEntity {
//    func toNote() -> Note? {
//        guard let uid = uid,
//            let title = title,
//            let content = content,
//            let importance = Importance.init(rawValue: Int(importance)),
//            let hexColor = color,
//            let color = UIColor.parseFromHex(string: hexColor) else {
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
//        color = note.color.toHexString()
//        destroyDate = note.destroyDate
//    }
//}
