//
//  OperationDispatcher.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

enum OperationType {
    case network
    case file
    case ui
    case serial
}

class OperationDispatcher {
    private let networkIoQueue: OperationQueue
    private let fileIoQueue: OperationQueue
    private let uiQueue: OperationQueue
    private let serialQueue: OperationQueue
    
    init() {
        networkIoQueue = OperationQueue()
        networkIoQueue.maxConcurrentOperationCount = 5
        
        fileIoQueue = OperationQueue()
        fileIoQueue.maxConcurrentOperationCount = 5
        
        uiQueue = OperationQueue.main
        uiQueue.maxConcurrentOperationCount = 2
        uiQueue.qualityOfService = .userInitiated
        
        serialQueue = OperationQueue()
        serialQueue.maxConcurrentOperationCount = 1
    }
    
    public func add(_ operaion: Operation, withType type: OperationType) {
        switch type {
        case .network:
            networkIoQueue.addOperation(operaion)
        case .file:
            fileIoQueue.addOperation(operaion)
        case .ui:
            uiQueue.addOperation(operaion)
        case .serial:
            serialQueue.addOperation(operaion)
        }
    }
}
