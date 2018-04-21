//
//  Operations.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CocoaLumberjack

class NoteOperationsFactory {
    private let fileNotebook: FileNotebook
    private let api: Api
    
    init(fileNotebook: FileNotebook, api: Api) {
        self.fileNotebook = fileNotebook
        self.api = api
    }
    
    func buildGetNotesOperation() -> GetNotesOperation {
        return GetNotesOperation(fileNotebook: fileNotebook, api: api)
    }
    
    func buildSaveNotesOperation() -> SaveNotesOperation {
        return SaveNotesOperation(fileNotebook: fileNotebook)
    }
    
    func buildGetNoteOperation(noteUid: String) -> GetNoteOperation {
        return GetNoteOperation(fileNotebook: fileNotebook, api: api, noteUid: noteUid)
    }
    
    func buildSaveNoteOperation(note: Note) -> SaveNoteOperation {
        return SaveNoteOperation(fileNotebook: fileNotebook, api: api, note: note)
    }
    
    func buildRemoveNoteOperation(noteUid: String) -> RemoveNoteOperation {
        return RemoveNoteOperation(fileNotebook: fileNotebook, api: api, noteUid: noteUid)
    }
}

class GetNotesOperation: AsyncOperation {
    public var onSuccess: (([String: Note]?) -> Void)?
    
    private let fileNotebook: FileNotebook
    private let api: Api
    
    init(fileNotebook: FileNotebook, api: Api) {
        self.fileNotebook = fileNotebook
        self.api = api
    }
    
    override func main() {
        api.getNotes { (notes) in
            defer {
                self.onSuccess?(self.fileNotebook.notes)
                self.finish()
            }
            
            guard let notes = notes else {
                try? self.fileNotebook.load()
                return
            }
            
            self.fileNotebook.replace(notes: notes)
            try? self.fileNotebook.save()
        }
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
    private let api: Api
    private let noteUid: String
    
    init(fileNotebook: FileNotebook, api: Api, noteUid: String) {
        self.fileNotebook = fileNotebook
        self.api = api
        self.noteUid = noteUid
    }
    
    override func main() {
        api.getNote(withUid: noteUid) { (note) in
            defer {
                self.onSuccess?(self.fileNotebook.notes[self.noteUid])
                self.finish()
            }
            
            guard let note = note else {
                return
            }
            
            self.fileNotebook.add(note) || self.fileNotebook.update(note)
        }
    }
}

class SaveNoteOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
    
    private let fileNotebook: FileNotebook
    private let api: Api
    private let note: Note
    
    init(fileNotebook: FileNotebook, api: Api, note: Note) {
        self.fileNotebook = fileNotebook
        self.api = api
        self.note = note
    }
    
    override func main() {
        var exists = false
        if !fileNotebook.add(note) {
            exists = true
            fileNotebook.update(note)
        }
        
        api.save(note: note, exists: exists) {
            self.onSuccess?()
            self.finish()
        }
    }
}

class RemoveNoteOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
    
    private let fileNotebook: FileNotebook
    private let api: Api
    private let noteUid: String
    
    init(fileNotebook: FileNotebook, api: Api, noteUid: String) {
        self.fileNotebook = fileNotebook
        self.api = api
        self.noteUid = noteUid
    }
    
    override func main() {
        fileNotebook.removeNote(withUid: noteUid)
        api.removeNote(withUid: noteUid) {
            self.onSuccess?()
            self.finish()
        }
    }
}
