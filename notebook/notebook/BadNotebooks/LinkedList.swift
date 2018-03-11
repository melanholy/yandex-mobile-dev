//
//  LinkedList.swift
//  notebook
//
//  Created by Павел Кошара on 10/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

class Node<T> {
    public var next: Node?
    public var prev: Node?
    public let value: T
    
    init(value: T, next: Node? = nil, prev: Node? = nil) {
        self.value = value
        self.next = next ?? self
        self.prev = prev ?? self
    }
}

public class LinkedListIterator<T>: IteratorProtocol {
    public typealias Element = T
    
    private let list: LinkedList<T>
    private var current: Node<T>?
    
    init(list: LinkedList<T>) {
        self.list = list
        current = list.head
    }
    
    public func next() -> T? {
        guard let result = current else {
            return nil
        }
        
        current = current === list.tail ? nil : result.next
        
        return result.value
    }
}

public class LinkedList<T>: Sequence {
    fileprivate var head: Node<T>? = nil
    fileprivate var tail: Node<T>? = nil
    private(set) var count: Int = 0
    
    init() {}
    
    init(collection: [T]) {
        for elem in collection {
            add(elem)
        }
    }
    
    public func add(_ elem: T) {
        let node = Node(value: elem)
        if head == nil {
            head = node
            tail = node
        } else {
            tail?.next = node
            node.prev = tail
            tail = node
        }
        count += 1
    }
    
    @discardableResult
    public func remove(where selector: (T) -> Bool) -> Bool {
        guard var current = tail else {
            return false
        }
        
        var deleted = false
        while true {
            if selector(current.value) {
                current.prev?.next = current.next
                current.next?.prev = current.prev
                if current === head {
                    head = current.next
                }
                if current === tail {
                    tail = current.prev
                }
                
                count -= 1
                deleted = true
            }
            
            if current === head || current.next === head {
                break
            }
            current = current.prev!
        }
        
        if (count == 0) {
            head = nil
            tail = nil
        }
        
        return deleted
    }
    
    public func makeIterator() -> LinkedListIterator<T> {
        return LinkedListIterator(list: self)
    }
}
