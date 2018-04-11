//
//  FileNotebookNoteProvider.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

class FileNotebookNoteProvider: NoteProviding {
    private let operationsFactory: NoteOperationsFactory
    private let operationsDispatcher: OperationDispatcher
    
    init(
        noteOperationsFactory: NoteOperationsFactory,
        operationsDispatcher: OperationDispatcher) {
        operationsFactory = noteOperationsFactory
        self.operationsDispatcher = operationsDispatcher
    }
    
    func getAll(callback: @escaping ([String: Note]?) -> Void) {
        let operation = operationsFactory.buildGetNotesOperation()
        operation.onSuccess = callback
        operationsDispatcher.add(operation, withType: .file)
    }
    
    func save(callback: (() -> Void)?) {
        let operation = operationsFactory.buildSaveNotesOperation()
        operation.onSuccess = callback
        operationsDispatcher.add(operation, withType: .file)
    }
    
    func getNote(withUid uid: String, callback: @escaping (Note?) -> Void) {
        let operation = operationsFactory.buildGetNoteOperation(noteUid: uid)
        operation.onSuccess = callback
        operationsDispatcher.add(operation, withType: .file)
    }
    
    func saveNote(_ note: Note, callback: (() -> Void)?) {
        let operation = operationsFactory.buildSaveNoteOperation(note: note)
        operation.onSuccess = callback
        operationsDispatcher.add(operation, withType: .file)
    }
    
    func removeNote(withUid uid: String, callback: (() -> Void)?) {
        let operation = operationsFactory.buildRemoveNoteOperation(noteUid: uid)
        operation.onSuccess = callback
        operationsDispatcher.add(operation, withType: .file)
    }
}
