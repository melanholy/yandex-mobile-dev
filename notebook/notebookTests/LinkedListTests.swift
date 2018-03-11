//
//  LinkedListTests.swift
//  notebookTests
//
//  Created by Павел Кошара on 10/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import XCTest
@testable import notebook

class LinkedListTests: XCTestCase {
    func testAdd() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let list = LinkedList<Int>()
        list.add(1)
        list.add(1)
        list.add(2)
        
        XCTAssert(list.count == 3)
        
        list.remove(where: { $0 == 1 })
        list.add(1)
        XCTAssert(list.count == 2)
    }
    
    func testRemove() {
        let list = LinkedList<Int>()
        list.add(1)
        list.add(1)
        list.add(2)
        
        XCTAssert(list.remove { $0 == 1 })
        XCTAssert(list.count == 1)
        
        XCTAssertFalse(list.remove { $0 == 0 })
        
        XCTAssert(list.remove { $0 == 2 })
        XCTAssert(list.count == 0)
    }
    
    func testContains() {
        let list = LinkedList<Int>()
        list.add(1)
        list.add(2)
        
        XCTAssert(list.contains { $0 == 1 })
        XCTAssert(list.contains { $0 == 2 })
        
        list.remove(where: { $0 == 2 })
        list.remove(where: { $0 == 1 })
        
        XCTAssertFalse(list.contains { $0 == 2 })
        XCTAssertFalse(list.contains { $0 == 1 })
        
        list.add(4)
        
        XCTAssert(list.contains { $0 == 4 })
    }
}
