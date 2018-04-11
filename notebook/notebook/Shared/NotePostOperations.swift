//
//  NotePostOperations.swift
//  notebook
//
//  Created by Павел Кошара on 09/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CocoaLumberjack

class PostNoteOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
    
    private let note: Note
    
    init(note: Note) {
        self.note = note
    }
    
    override func main() {
        DDLogInfo("post: \(String(describing: note))")
        finish()
        
        onSuccess?()
    }
}

class GetPostsOperation: AsyncOperation {
    public var onSuccess: (() -> Void)?
    
    override func main() {
        DDLogInfo("get posts")
        finish()
        
        onSuccess?()
    }
}
