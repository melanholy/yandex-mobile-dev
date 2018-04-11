//
//  AsyncOperation.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    override var isExecuting: Bool {
        return _executing
    }
    override var isFinished: Bool {
        return _finished
    }
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _executing = false
    private var _finished = false
    
    override func start() {
        if isCancelled {
            finish()
            return
        }
        
        willChangeValue(forKey: "isExecuting")
        _executing = true
        main()
        didChangeValue(forKey: "isExcuting")
    }
    
    override func main() {
        finish()
    }
    
    func finish() {
        willChangeValue(forKey: "isFinished")
        _finished = true
        didChangeValue(forKey: "isFinished")
    }
}
