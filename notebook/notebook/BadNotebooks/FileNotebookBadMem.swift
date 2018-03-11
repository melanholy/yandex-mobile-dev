//
//  FileNotebookBadMem.swift
//  notebook
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class FileNotebookBadMem {
    private static let storeFilename = "notes.json"
    
    private(set) var notes = LinkedList<Note>()
    
    static var filePath: String? {
        guard let dir = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .allDomainsMask,
            true).first else {
                DDLogError("NSSearchPathForDirectoriesInDomains didn't return any directories")
                
                return nil
        }
        
        let path = "\(dir)/\(storeFilename)"
        
        return path
    }
    
    @discardableResult
    func add(_ note: Note) -> Bool {
        if notes.contains(where: { $0.uid == note.uid }) {
            DDLogInfo("Failed to add new note: note with uid=\(note.uid) already exists")
            
            return false
        }
        
        notes.add(note)
        
        return true
    }
    
    @discardableResult
    func removeNote(withUid uid: String) -> Bool {
        let result = notes.remove { $0.uid == uid }
        
        if !result {
            DDLogInfo("Failed to remove note: note with uid=\(uid) doesn't exists")
            
            return false
        }

        DDLogInfo("Removed note with uid=\(uid)")
        
        return true
    }
    
    func save() throws {
        guard let filePath = FileNotebook.filePath else {
            DDLogError("Failed to get path for saving")
            
            return
        }
        
        let jsonNotes = notes.map { $0.json }
        
        let data = try JSONSerialization.data(withJSONObject: jsonNotes, options: [])
        guard let jsonString = String(data: data, encoding: .utf8) else {
            DDLogError("Failed to create json from notes")
            return
        }
        
        try jsonString.write(toFile: filePath, atomically: false, encoding: .utf8)
        
        DDLogInfo("Saved \(notes.count) notes")
    }
    
    func load() throws {
        guard let filePath = FileNotebook.filePath else {
            DDLogError("Failed to get path for loading")
            
            return
        }
        
        let content = try String(contentsOfFile: filePath)
        guard let data = content.data(using: .utf8),
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                DDLogError("Failed to decode notes from \(filePath)")
                
                return
        }
        
        var loadedNotes = [Note]()
        for obj in jsonArray {
            let note = Note.parse(json: obj)
            if let note = note {
                loadedNotes.append(note)
            }
        }
        
        notes = LinkedList(collection: loadedNotes)
        
        DDLogInfo("Loaded \(notes.count) notes")
    }
}

