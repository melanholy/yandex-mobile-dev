//
//  FileNotebookNoteProvider.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CocoaLumberjack

class NoteProvider: NoteProviding {
    private let serverOperationsFactory: NoteOperationsFactory
    private let localOperationsFactory: NoteOperationsFactory
    private let operationsDispatcher: OperationDispatcher
    
    init(
        serverOperationsFactory: NoteOperationsFactory,
        localOperationsFactory: NoteOperationsFactory,
        operationsDispatcher: OperationDispatcher) {
        self.serverOperationsFactory = serverOperationsFactory
        self.localOperationsFactory = localOperationsFactory
        self.operationsDispatcher = operationsDispatcher
    }
    
    public func getAll(callback: @escaping ([String: Note]?) -> Void) {
        let serverOperation = serverOperationsFactory.buildGetNotesOperation()
        let localOperation = localOperationsFactory.buildGetNotesOperation()
        let mergeOperation = Operation()
        mergeOperation.addDependency(serverOperation)
        mergeOperation.addDependency(localOperation)
        
        var fromLocal: [String: Note]? = nil
        var fromServer: [String: Note]? = nil
        localOperation.onSuccess = { notes in
            fromLocal = notes
        }
        serverOperation.onSuccess = { notes in
            fromServer = notes
        }
        mergeOperation.completionBlock = {
            callback(self.merge(fromLocal: fromLocal, fromServer: fromServer))
        }
        
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
        operationsDispatcher.add(mergeOperation, withType: .ui)
    }
    
    public func save(callback: (() -> Void)?) {
        let serverOperation = serverOperationsFactory.buildSaveNotesOperation()
        let localOperation = localOperationsFactory.buildSaveNotesOperation()
        let completionOperation = Operation()
        
        completionOperation.addDependency(serverOperation)
        completionOperation.addDependency(localOperation)
        completionOperation.completionBlock = { callback?() }
        
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
        operationsDispatcher.add(completionOperation, withType: .ui)
    }
    
    public func getNote(withUid uid: String, callback: @escaping (Note?) -> Void) {
        let serverOperation = serverOperationsFactory.buildGetNoteOperation(noteUid: uid)
        let localOperation = localOperationsFactory.buildGetNoteOperation(noteUid: uid)
        let mergeOperation = Operation()
        mergeOperation.addDependency(serverOperation)
        mergeOperation.addDependency(localOperation)
        
        var fromLocal: Note? = nil
        var fromServer: Note? = nil
        localOperation.onSuccess = { notes in
            fromLocal = notes
        }
        serverOperation.onSuccess = { notes in
            fromServer = notes
        }
        mergeOperation.completionBlock = {
            callback(self.merge(fromLocal: fromLocal, fromServer: fromServer))
        }
        
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
        operationsDispatcher.add(mergeOperation, withType: .ui)
    }
    
    public func saveNote(_ note: Note, exists: Bool, callback: (() -> Void)?) {
        let serverOperation = serverOperationsFactory.buildSaveNoteOperation(note: note, exists: exists)
        let localOperation = localOperationsFactory.buildSaveNoteOperation(note: note, exists: exists)
        let completionOperation = Operation()
        
        completionOperation.addDependency(serverOperation)
        completionOperation.addDependency(localOperation)
        completionOperation.completionBlock = { callback?() }
        
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
        operationsDispatcher.add(completionOperation, withType: .ui)
    }
    
    public func removeNote(withUid uid: String, callback: (() -> Void)?) {
        let serverOperation = serverOperationsFactory.buildRemoveNoteOperation(noteUid: uid)
        let localOperation = localOperationsFactory.buildRemoveNoteOperation(noteUid: uid)
        let completionOperation = Operation()
        
        completionOperation.addDependency(serverOperation)
        completionOperation.addDependency(localOperation)
        completionOperation.completionBlock = { callback?() }
        
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
        operationsDispatcher.add(completionOperation, withType: .ui)
    }
    
    private func merge(fromLocal: [String: Note]?, fromServer: [String: Note]?) -> [String: Note]? {
        guard let fromLocal = fromLocal else {
            return fromServer
        }
        guard let fromServer = fromServer else {
            return fromLocal
        }
        
        var result = fromLocal
        for kv in fromServer {
            let noteOnLocal = fromLocal[kv.key]
            if noteOnLocal == nil || noteOnLocal != kv.value {
                DDLogInfo(noteOnLocal == nil
                    ? "Note with uid=\(kv.key) is not in local storage. Adding it to local storage."
                    : "Note with uid=\(kv.key) is different from note from server."
                      + "Saving the one from server to local storage.")
                
                let localOperation = localOperationsFactory.buildSaveNoteOperation(
                    note: kv.value,
                    exists: noteOnLocal != nil)
                operationsDispatcher.add(localOperation, withType: .file)
                result[kv.value.uid] = kv.value
            }
        }
        for kv in fromLocal {
            let noteOnServer = fromServer[kv.key]
            if noteOnServer == nil {
                DDLogInfo("Local note with uid=\(kv.key) is not on server."
                          + "Adding it to server.")
                
                let serverOperation = serverOperationsFactory.buildSaveNoteOperation(
                    note: kv.value,
                    exists: false)
                operationsDispatcher.add(serverOperation, withType: .network)
            }
        }
        
        return result
    }
    
    private func merge(fromLocal: Note?, fromServer: Note?) -> Note? {
        guard let fromLocal = fromLocal else {
            return fromServer
        }
        guard let fromServer = fromServer else {
            return fromLocal
        }
        
        if fromLocal != fromServer {
            DDLogInfo("Note with uid=\(fromLocal.uid) from local storage is different from note from server."
                      + " Saving the one from server to local.")
            
            let localOperation = localOperationsFactory.buildSaveNoteOperation(
                note: fromServer,
                exists: true)
            operationsDispatcher.add(localOperation, withType: .file)
        }
        
        return fromServer
    }
}
