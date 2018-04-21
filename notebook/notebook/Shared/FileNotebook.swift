//
//  FileNotebook.swift
//  notebook
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class FileNotebook {
    private static let storeFilename = "notes.json"
    
    private(set) var notes = [String: Note]()
    
    private static var filePath: String? {
        guard let dir = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .allDomainsMask,
            true).first else {
                DDLogError("NSSearchPathForDirectoriesInDomains didn't return any directories")
                
                return nil
        }
        
        let path = "\(dir)/\(storeFilename)"
        
        DDLogInfo("Got filePath for FileNotebook: \(path)")
        
        return path
    }
    
    @discardableResult
    public func add(_ note: Note) -> Bool {
        if notes[note.uid] != nil {
            DDLogInfo("Failed to add new note: note with uid=\(note.uid) already exists")
            
            return false
        }
        
        notes[note.uid] = note
        DDLogInfo("Added note with uid=\(note.uid)")
        
        return true
    }
    
    @discardableResult
    public func update(_ note: Note) -> Bool {
        if notes[note.uid] == nil {
            DDLogInfo("Failed to update note: note with uid=\(note.uid) doesn't exists")
            
            return false
        }
        
        notes[note.uid] = note
        DDLogInfo("Updated note with uid=\(note.uid)")
        
        return true
    }
    
    @discardableResult
    public func removeNote(withUid uid: String) -> Bool {
        if notes[uid] == nil {
            DDLogInfo("Failed to remove note: note with uid=\(uid) doesn't exists")
            
            return false
        }
        
        notes.removeValue(forKey: uid)
        DDLogInfo("Removed note with uid=\(uid)")
        
        return true
    }
    
    public func save() throws {
        guard let filePath = FileNotebook.filePath else {
            DDLogError("Failed to get path for saving")
            
            return
        }
        
        let jsonNotes = notes.values.map { $0.json }
        
        let data = try JSONSerialization.data(withJSONObject: jsonNotes, options: [])
        guard let jsonString = String(data: data, encoding: .utf8) else {
            DDLogError("Failed to create json from notes")
            return
        }
        
        try jsonString.write(toFile: filePath, atomically: false, encoding: .utf8)
        
        DDLogInfo("Saved \(notes.count) notes")
    }
    
    public func load() throws {
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
        
        var loadedNotes = [String: Note]()
        for item in jsonArray {
            let note = Note.parse(json: item)
            if let note = note {
                loadedNotes[note.uid] = note
            }
        }
        
        notes = loadedNotes
        
        DDLogInfo("Loaded \(notes.count) notes")
    }
    
    public func replace(notes: [Note]) {
        self.notes = [String: Note]()
        for note in notes {
            self.notes[note.uid] = note
        }
    }
}
