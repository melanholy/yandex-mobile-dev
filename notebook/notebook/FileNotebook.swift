//
//  FileNotebook.swift
//  notebook
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class FileNotebook {
    private static let storeFilename = "notes.json"
    
    private(set) var notes = [Note]()
    
    static var filePath: String? {
        guard let dir = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .allDomainsMask,
            true).first else {
                return nil
        }
        
        let path = "\(dir)/\(storeFilename)"
        
        return path
    }
    
    func add(_ note: Note) -> Bool {
        if notes.contains(where: { $0.uid == note.uid }) {
            return false
        }
        
        notes.append(note)
        
        return true
    }
    
    func removeNote(withUid uid: String) -> Bool {
        guard let index = notes.index(where: { $0.uid == uid }) else {
            return false
        }
        
        notes.remove(at: index)
        
        return true
    }
    
    func save() throws {
        guard let filePath = FileNotebook.filePath else {
            return
        }
        
        let jsonNotes = notes.map { $0.json }
        
        let data = try JSONSerialization.data(withJSONObject: jsonNotes, options: [])
        guard let jsonString = String(data: data, encoding: .utf8) else {
            return
        }
        
        try jsonString.write(toFile: filePath, atomically: false, encoding: .utf8)
    }
    
    func load() throws {
        guard let filePath = FileNotebook.filePath else {
            return
        }
        
        let content = try String(contentsOfFile: filePath)
        guard let data = content.data(using: .utf8),
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                return
        }
        
        var loadedNotes = [Note]()
        for obj in jsonArray {
            let note = Note.parse(json: obj)
            if let note = note {
                loadedNotes.append(note)
            }
        }
        
        notes = loadedNotes
    }
}
