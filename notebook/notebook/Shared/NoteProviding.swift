//
//  FileNotebookProvider.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

protocol NoteProviding: class {
    func getAll(callback: @escaping ([String: Note]?) -> Void)
    func save(callback: (() -> Void)?)
    func getNote(withUid uid: String, callback: @escaping (Note?) -> Void)
    func saveNote(_ note: Note, callback: (() -> Void)?)
    func removeNote(withUid uid: String, callback: (() -> Void)?)
}
