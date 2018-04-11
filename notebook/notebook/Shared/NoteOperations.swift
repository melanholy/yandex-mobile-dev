//
//  Operations.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

class NoteOperationsFactory {
    private let fileNotebook: FileNotebook
    
    init(fileNotebook: FileNotebook) {
        self.fileNotebook = fileNotebook
    }
    
    func buildGetNotesOperation() -> GetNotesOperation {
        return GetNotesOperation(fileNotebook: fileNotebook)
    }
    
    func buildSaveNotesOperation() -> SaveNotesOperation {
        return SaveNotesOperation(fileNotebook: fileNotebook)
    }
    
    func buildGetNoteOperation(noteUid: String) -> GetNoteOperation {
        return GetNoteOperation(fileNotebook: fileNotebook, noteUid: noteUid)
    }
    
    func buildSaveNoteOperation(note: Note) -> SaveNoteOperation {
        return SaveNoteOperation(fileNotebook: fileNotebook, note: note)
    }
    
    func buildRemoveNoteOperation(noteUid: String) -> RemoveNoteOperation {
        return RemoveNoteOperation(fileNotebook: fileNotebook, noteUid: noteUid)
    }
}

class GetNotesOperation: AsyncOperation {
    public var onSuccess: (([String: Note]?) -> Void)?
    
    private let fileNotebook: FileNotebook
    
    init(fileNotebook: FileNotebook) {
        self.fileNotebook = fileNotebook
    }
    
    override func main() {
        var notes: [String: Note]?
        do {
            try fileNotebook.load()
            notes = fileNotebook.notes
        } catch {
            notes = nil
        }
        
        finish()
        
        onSuccess?(notes)
    }
}

class SaveNotesOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
    
    private let fileNotebook: FileNotebook
    
    init(fileNotebook: FileNotebook) {
        self.fileNotebook = fileNotebook
    }
    
    override func main() {
        try? fileNotebook.save()
        
        finish()
        
        onSuccess?()
    }
}

class GetNoteOperation: AsyncOperation {
    public var onSuccess: ((Note?) -> Void)?
    
    private let fileNotebook: FileNotebook
    private let noteUid: String
    
    init(fileNotebook: FileNotebook, noteUid: String) {
        self.fileNotebook = fileNotebook
        self.noteUid = noteUid
    }
    
    override func main() {
        let note = fileNotebook.notes[noteUid]
        
        finish()
        
        onSuccess?(note)
    }
}

class SaveNoteOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
    
    private let fileNotebook: FileNotebook
    private let note: Note
    
    init(fileNotebook: FileNotebook, note: Note) {
        self.fileNotebook = fileNotebook
        self.note = note
    }
    
    override func main() {
        if !fileNotebook.add(note) {
            fileNotebook.update(note)
        }
        
        finish()
        
        onSuccess?()
    }
}

class RemoveNoteOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
    
    private let fileNotebook: FileNotebook
    private let noteUid: String
    
    init(fileNotebook: FileNotebook, noteUid: String) {
        self.fileNotebook = fileNotebook
        self.noteUid = noteUid
    }
    
    override func main() {
        fileNotebook.removeNote(withUid: noteUid)
        
        finish()
        
        onSuccess?()
    }
}
