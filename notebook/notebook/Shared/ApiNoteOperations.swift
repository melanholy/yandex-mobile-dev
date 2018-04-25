//
//  Operations.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CocoaLumberjack

class ApiNoteOperationsFactory: NoteOperationsFactory {
    private let api: Api
    
    init(api: Api) {
        self.api = api
    }
    
    func buildGetNotesOperation() -> GetNotesOperation {
        return ApiGetNotesOperation(api: api)
    }
    
    func buildSaveNotesOperation() -> SaveNotesOperation {
        return ApiSaveNotesOperation()
    }
    
    func buildGetNoteOperation(noteUid: String) -> GetNoteOperation {
        return ApiGetNoteOperation(api: api, noteUid: noteUid)
    }
    
    func buildSaveNoteOperation(note: Note, exists: Bool) -> SaveNoteOperation {
        return ApiSaveNoteOperation(api: api, note: note, exists: exists)
    }
    
    func buildRemoveNoteOperation(noteUid: String) -> RemoveNoteOperation {
        return ApiRemoveNoteOperation(api: api, noteUid: noteUid)
    }
}

private class ApiGetNotesOperation: GetNotesOperation {
    private let api: Api
    
    init(api: Api) {
        self.api = api
    }
    
    override func main() {
        api.getNotes { (notes) in
            var result: [String: Note]? = nil
            defer {
                self.onSuccess?(result)
                self.finish()
            }
            
            guard let notes = notes else {
                return
            }
            
            var notesDict = [String: Note]()
            for note in notes {
                notesDict[note.uid] = note
            }
            result = notesDict
        }
    }
}

private class ApiSaveNotesOperation: SaveNotesOperation {
    override func main() {
        finish()
        onSuccess?()
    }
}

private class ApiGetNoteOperation: GetNoteOperation {
    private let api: Api
    private let noteUid: String
    
    init(api: Api, noteUid: String) {
        self.api = api
        self.noteUid = noteUid
    }
    
    override func main() {
        api.getNote(withUid: noteUid) { (note) in
            self.onSuccess?(note)
            self.finish()
        }
    }
}

private class ApiSaveNoteOperation: SaveNoteOperation {
    private let api: Api
    private let note: Note
    private let exists: Bool
    
    init(api: Api, note: Note, exists: Bool) {
        self.api = api
        self.note = note
        self.exists = exists
    }
    
    override func main() {
        api.save(note: note, exists: exists) {
            self.onSuccess?()
            self.finish()
        }
    }
}

private class ApiRemoveNoteOperation: RemoveNoteOperation {
    private let api: Api
    private let noteUid: String
    
    init(api: Api, noteUid: String) {
        self.api = api
        self.noteUid = noteUid
    }
    
    override func main() {
        api.removeNote(withUid: noteUid) {
            self.onSuccess?()
            self.finish()
        }
    }
}
