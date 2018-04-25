//
//  FileNotebookNoteProvider.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

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
    
    func getAll(callback: @escaping ([String: Note]?) -> Void) {
        let serverOperation = serverOperationsFactory.buildGetNotesOperation()
        let localOperation = localOperationsFactory.buildGetNotesOperation()
        serverOperation.addDependency(localOperation)
        localOperation.onSuccess = callback
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
    }
    
    func save(callback: (() -> Void)?) {
        let serverOperation = serverOperationsFactory.buildSaveNotesOperation()
        let localOperation = localOperationsFactory.buildSaveNotesOperation()
        serverOperation.addDependency(localOperation)
        localOperation.onSuccess = callback
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
    }
    
    func getNote(withUid uid: String, callback: @escaping (Note?) -> Void) {
        let serverOperation = serverOperationsFactory.buildGetNoteOperation(noteUid: uid)
        let localOperation = localOperationsFactory.buildGetNoteOperation(noteUid: uid)
        serverOperation.addDependency(localOperation)
        localOperation.onSuccess = callback
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
    }
    
    func saveNote(_ note: Note, exists: Bool, callback: (() -> Void)?) {
        let serverOperation = serverOperationsFactory.buildSaveNoteOperation(note: note, exists: exists)
        let localOperation = localOperationsFactory.buildSaveNoteOperation(note: note, exists: exists)
        serverOperation.addDependency(localOperation)
        localOperation.onSuccess = callback
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
    }
    
    func removeNote(withUid uid: String, callback: (() -> Void)?) {
        let serverOperation = serverOperationsFactory.buildRemoveNoteOperation(noteUid: uid)
        let localOperation = localOperationsFactory.buildRemoveNoteOperation(noteUid: uid)
        serverOperation.addDependency(localOperation)
        localOperation.onSuccess = callback
        operationsDispatcher.add(serverOperation, withType: .network)
        operationsDispatcher.add(localOperation, withType: .file)
    }
}
