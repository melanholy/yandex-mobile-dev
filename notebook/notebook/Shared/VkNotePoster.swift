//
//  VkNotePoster.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CocoaLumberjack

class VkNotePoster: NotePosting {
    private let operationsDispatcher: OperationDispatcher
    
    init(operationsDispatcher: OperationDispatcher) {
        self.operationsDispatcher = operationsDispatcher
    }
    
    func post(_ note: Note, callback: (() -> Void)?) {
        let operation = PostNoteOperation(note: note)
        operation.onSuccess = callback
        operationsDispatcher.add(operation, withType: .network)
    }
    
    func getPosts(callback: (() -> Void)?) {
        let operation = GetPostsOperation()
        operation.onSuccess = callback
        operationsDispatcher.add(operation, withType: .network)
    }
}
