//
//  Api.swift
//  notebook
//
//  Created by Павел Кошара on 15/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Api {
    private let authToken: String
    private let host: URL
    
    init(host: URL, authToken: String) {
        self.host = host
        self.authToken = authToken
    }
    
    public func getNotes(callback: @escaping ([Note]?) -> Void) {
        let path = "/notes"
        guard let url = URL(string: path, relativeTo: host) else {
            callback(nil)
            return
        }
        
        let request = buildRequest(url: url)
        
        DDLogInfo("Sending \(request.httpMethod ?? "unknown") request to \(url).")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var result: [Note]? = nil
            defer { callback(result) }
            
            guard error == nil,
                let response = response as? HTTPURLResponse else {
                DDLogError("Request for \(path) failed because \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            if response.statusCode >= 400 {
                self.logError(path: path, data: data, response: response)
                return
            }
            
            guard let data = data,
                let jsonArray = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String: Any]] else {
                    DDLogError("Api didn't return a valid answer for \(path)")
                    return
            }
            
            var notes = [Note]()
            for item in jsonArray {
                if let note = Note.parse(json: item) {
                    notes.append(note)
                }
            }
            result = notes
            
            DDLogInfo("Got \(notes.count) notes from server.")
        }.resume()
    }
    
    public func getNote(withUid noteUid: String, callback: @escaping (Note?) -> Void) {
        let path = "/notes/\(noteUid)"
        guard let url = URL(string: path, relativeTo: host) else {
            callback(nil)
            return
        }
        
        let request = buildRequest(url: url)
        
        DDLogInfo("Sending \(request.httpMethod ?? "unknown") request to \(url).")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var result: Note? = nil
            defer { callback(result) }
            
            guard error == nil,
                let response = response as? HTTPURLResponse else {
                    DDLogError("Request for \(path) failed because \(error?.localizedDescription ?? "unknown")")
                    return
            }
            
            if response.statusCode >= 400 {
                self.logError(path: path, data: data, response: response)
            }
            
            guard let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let note = Note.parse(json: json) else {
                    DDLogError("Api didn't return a valid answer for \(path)")
                    return
            }
            result = note
            
            DDLogInfo("Got note with uid=\(note.uid) from server.")
        }.resume()
    }
    
    public func save(note: Note, exists: Bool, callback: @escaping () -> Void) {
        let path = "/notes" + (exists ? "/\(note.uid)" : "")
        guard let url = URL(string: path, relativeTo: host) else {
            callback()
            return
        }
        
        guard let noteData = try? JSONSerialization.data(withJSONObject: note.json, options: []) else {
            DDLogError("Failed to serialize note with uid=\(note.uid)")
            callback()
            return
        }

        var request = buildRequest(url: url)
        request.httpMethod = exists ? "PUT" : "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = noteData
        
        DDLogInfo("Sending \(request.httpMethod ?? "unknown") request to \(url).")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { callback() }
            
            guard error == nil,
                let response = response as? HTTPURLResponse else {
                    DDLogError("Request for \(path) failed because \(error?.localizedDescription ?? "unknown")")
                    return
            }
            
            if response.statusCode >= 400 {
                self.logError(path: path, data: data, response: response)
            }
            
            DDLogInfo("Saved note with uid=\(note.uid) to server.")
        }.resume()
    }
    
    public func removeNote(withUid noteUid: String, callback: @escaping () -> Void) {
        let path = "/notes/\(noteUid)"
        guard let url = URL(string: path, relativeTo: host) else {
            callback()
            return
        }
        
        var request = buildRequest(url: url)
        request.httpMethod = "DELETE"
        
        DDLogInfo("Sending \(request.httpMethod ?? "unknown") request to \(url).")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer { callback() }
            
            guard error == nil,
                let response = response as? HTTPURLResponse else {
                    DDLogError("Request for \(path) failed because \(error?.localizedDescription ?? "unknown")")
                    return
            }
            
            if response.statusCode >= 400 {
                self.logError(path: path, data: data, response: response)
            }
            
            DDLogInfo("Removed note with uid=\(noteUid) from server.")
        }.resume()
    }
    
    private func buildRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("OAuth \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func logError(path: String, data: Data?, response: HTTPURLResponse) {
        guard let data = data,
            let errorData = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
            let message = errorData["message"] as? String else {
                DDLogError("Api returned \(response.statusCode) for \(path)")
                return
        }
        DDLogError("Api returned \(response.statusCode) for \(path): \(message)")
    }
}
