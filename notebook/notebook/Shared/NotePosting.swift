//
//  NotePosting.swift
//  notebook
//
//  Created by Павел Кошара on 08/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

protocol NotePosting: class {
    func post(_ note: Note, callback: (() -> Void)?)
    func getPosts(callback: (() -> Void)?)
}
