//
//  NoteOperationsFactory.swift
//  notebook
//
//  Created by Павел Кошара on 21/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

protocol NoteOperationsFactory {
    func buildGetNotesOperation() -> GetNotesOperation
    
    func buildSaveNotesOperation() -> SaveNotesOperation
    
    func buildGetNoteOperation(noteUid: String) -> GetNoteOperation
    
    func buildSaveNoteOperation(note: Note, exists: Bool) -> SaveNoteOperation
    
    func buildRemoveNoteOperation(noteUid: String) -> RemoveNoteOperation
}

class GetNotesOperation: AsyncOperation {
    public var onSuccess: (([String: Note]?) -> Void)?
}

class SaveNotesOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
}

class GetNoteOperation: AsyncOperation {
    public var onSuccess: ((Note?) -> Void)?
}

class SaveNoteOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
}

class RemoveNoteOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
}

