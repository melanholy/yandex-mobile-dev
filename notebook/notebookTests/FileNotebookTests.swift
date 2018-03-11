//
//  notebookTests.swift
//  notebookTests
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import XCTest
@testable import notebook

class FileNotebookTests: XCTestCase {
    func testAddSimple() {
        let notebook = FileNotebook()
        let note1 = Note(title: "", content: "", importance: Importance.common)
        
        XCTAssert(notebook.add(note1))
        XCTAssert(notebook.notes.count == 1)
        XCTAssert(notebook.notes.values.contains { $0.uid == note1.uid })
        
        let note2 = Note(title: "", content: "", importance: Importance.common)
        
        XCTAssert(notebook.add(note2))
        XCTAssert(notebook.notes.count == 2)
        XCTAssert(notebook.notes.values.contains { $0.uid == note2.uid })
    }
    
    func testAddSameNote() {
        let notebook = FileNotebook()
        let note = Note(title: "", content: "", importance: Importance.common)
        
        notebook.add(note)
        
        XCTAssertFalse(notebook.add(note))
        XCTAssert(notebook.notes.count == 1)
    }
    
    func testAddDifferentNoteWithSameUid() {
        let notebook = FileNotebook()
        let note1 = Note(title: "", content: "", importance: Importance.common)
        let note2 = Note(uid: note1.uid, title: "", content: "", importance: Importance.low)
        notebook.add(note1)
        
        XCTAssertFalse(notebook.add(note2))
        XCTAssert(notebook.notes.count == 1)
    }
    
    func testRemoveExisting() {
        let notebook = FileNotebook()
        let note1 = Note(title: "", content: "", importance: Importance.common)
        let note2 = Note(title: "", content: "", importance: Importance.common)
        notebook.add(note1)
        notebook.add(note2)
        
        XCTAssert(notebook.removeNote(withUid: note2.uid))
        XCTAssert(notebook.notes.count == 1)
        XCTAssertFalse(notebook.notes.values.contains { $0.uid == note2.uid })
        
        XCTAssert(notebook.removeNote(withUid: note1.uid))
        XCTAssert(notebook.notes.count == 0)
        XCTAssertFalse(notebook.notes.values.contains { $0.uid == note1.uid })
    }
    
    func testRemoveNotExisting() {
        let notebook = FileNotebook()
        let note = Note(title: "", content: "", importance: Importance.common)
        
        XCTAssertFalse(notebook.removeNote(withUid: "123"))
        XCTAssert(notebook.notes.count == 0)
        
        notebook.add(note)
        
        XCTAssertFalse(notebook.removeNote(withUid: "321"))
        XCTAssert(notebook.notes.count == 1)
    }
}
