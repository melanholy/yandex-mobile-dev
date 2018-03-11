//
//  FileNotebookBadCpu.swift
//  notebook
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class FileNotebookBadCpu {
    private static let storeFilename = "notes.json"
    
    private(set) var notes = [Note]()
    
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
        
        notes.append(note)
        
        return true
    }
    
    @discardableResult
    func removeNote(withUid uid: String) -> Bool {
        guard let index = notes.index(where: { $0.uid == uid }) else {
            DDLogInfo("Failed to remove note: note with uid=\(uid) doesn't exists")
            
            return false
        }
        
        notes.remove(at: index)
        
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
        
        for note in notes {
            removeNote(withUid: note.uid)
        }
        for note in loadedNotes {
            add(note)
        }
        
        DDLogInfo("Loaded \(notes.count) notes")
    }
}

