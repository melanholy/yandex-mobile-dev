//
//  CoreDataOperations.swift
//  notebook
//
//  Created by Павел Кошара on 21/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class CoreDataOperationsFactory: NoteOperationsFactory {
    private weak var coreDataManager: CoreDataManager!
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func buildGetNotesOperation() -> GetNotesOperation {
        return CoreDataGetNotesOperation(coreDataManager: coreDataManager)
    }
    
    func buildSaveNotesOperation() -> SaveNotesOperation {
        return CoreDataSaveNotesOperation(coreDataManager: coreDataManager)
    }
    
    func buildGetNoteOperation(noteUid: String) -> GetNoteOperation {
        return CoreDataGetNoteOperation(coreDataManager: coreDataManager, noteUid: noteUid)
    }
    
    func buildSaveNoteOperation(note: Note, exists: Bool) -> SaveNoteOperation {
        return CoreDataSaveNoteOperation(coreDataManager: coreDataManager, note: note)
    }
    
    func buildRemoveNoteOperation(noteUid: String) -> RemoveNoteOperation {
        return CoreDataRemoveNoteOperation(coreDataManager: coreDataManager, noteUid: noteUid)
    }
}

private class CoreDataGetNotesOperation: GetNotesOperation {
    private weak var coreDataManager: CoreDataManager!
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    override func main() {
        let context = coreDataManager.objectContext
        context.perform {
            var notes: [String: Note]? = nil
            defer {
                self.onSuccess?(notes)
                self.finish()
            }
            
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            let fetchResult: [NoteEntity]
            do {
                fetchResult = try context.fetch(request)
            } catch {
                DDLogError("Failed to fetch notes from NSManagedContext: \(error)")
                return
            }
            
            var notesDict = [String: Note]()
            for noteEntity in fetchResult {
                guard let note = noteEntity.toNote() else {
                    DDLogError("CoreDataGetNotesOperation failed to parse Note from NoteEntity")
                    continue
                }
                
                notesDict[note.uid] = note
            }
            notes = notesDict
            
            do {
                try context.save()
            } catch {
                DDLogError("Failed to save core data context: \(error)")
            }
            DDLogInfo("Got \(notesDict.count) notes from local storage.")
        }
    }
}

private class CoreDataSaveNotesOperation: SaveNotesOperation {
    private weak var coreDataManager: CoreDataManager!
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    override func main() {
        let context = coreDataManager.objectContext
        context.perform {
            defer {
                self.onSuccess?()
                self.finish()
            }
            
            do {
                try context.save()
            } catch {
                DDLogError("Failed to save CoreDataManager.objectContext: \(error)")
            }
            
            do {
                try context.save()
            } catch {
                DDLogError("Failed to save core data context: \(error)")
            }
            DDLogInfo("Saved all notes from memory to local storage.")
        }
    }
}

private class CoreDataGetNoteOperation: GetNoteOperation {
    private weak var coreDataManager: CoreDataManager!
    private let noteUid: String
    
    init(coreDataManager: CoreDataManager, noteUid: String) {
        self.coreDataManager = coreDataManager
        self.noteUid = noteUid
    }
    
    override func main() {
        let context = coreDataManager.objectContext
        context.perform {
            var result: Note? = nil
            defer {
                self.onSuccess?(result)
                self.finish()
            }
            
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.predicate = NSPredicate(format: "uid = %@", self.noteUid)
            let noteEntity: NoteEntity
            do {
                noteEntity = try context.fetchSingle(request)
            } catch {
                DDLogError("Failed to fetch note with uid=\(self.noteUid) from NSManagedContext: \(error)")
                return
            }
            guard let note = noteEntity.toNote() else {
                DDLogError("CoreDataGetNoteOperation failed to parse Note from NoteEntity")
                return
            }
            result = note
            
            do {
                try context.save()
            } catch {
                DDLogError("Failed to save core data context: \(error)")
            }
            DDLogInfo("Got note with uid=\(self.noteUid) from local storage.")
        }
    }
}

private class CoreDataSaveNoteOperation: SaveNoteOperation {
    private weak var coreDataManager: CoreDataManager!
    private let note: Note
    
    init(coreDataManager: CoreDataManager, note: Note) {
        self.coreDataManager = coreDataManager
        self.note = note
    }
    
    override func main() {
        let context = coreDataManager.objectContext
        context.perform {
            defer {
                self.onSuccess?()
                self.finish()
            }
            
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.predicate = NSPredicate(format: "uid = %@", self.note.uid)
            let noteEntity: NoteEntity
            do {
                let fetchResult = try context.fetchFirst(request)
                noteEntity = fetchResult ?? NoteEntity(context: context)
            } catch {
                DDLogError("Failed to fetch note with uid=\(self.note.uid) from NSManagedContext: \(error)")
                return
            }
            noteEntity.fill(from: self.note)
            
            do {
                try context.save()
            } catch {
                DDLogError("Failed to save core data context: \(error)")
            }
            DDLogInfo("Saved note with uid=\(self.note.uid) to local storage.")
        }
    }
}

private class CoreDataRemoveNoteOperation: RemoveNoteOperation {
    private weak var coreDataManager: CoreDataManager!
    private let noteUid: String
    
    init(coreDataManager: CoreDataManager, noteUid: String) {
        self.coreDataManager = coreDataManager
        self.noteUid = noteUid
    }
    
    override func main() {
        let context = coreDataManager.objectContext
        context.perform {
            defer {
                self.onSuccess?()
                self.finish()
            }
            
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.predicate = NSPredicate(format: "uid = %@", self.noteUid)
            let noteEntity: NoteEntity
            do {
                noteEntity = try context.fetchSingle(request)
            } catch {
                DDLogError("Failed to fetch note with uid=\(self.noteUid) from NSManagedContext: \(error)")
                return
            }
            context.delete(noteEntity)
            
            do {
                try context.save()
            } catch {
                DDLogError("Failed to save core data context: \(error)")
            }
            DDLogInfo("Removed note with uid=\(self.noteUid) from local storage.")
        }
    }
}










