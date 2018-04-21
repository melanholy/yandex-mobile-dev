//
//  Note.swift
//  notebook
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

enum Importance: Int {
    case low
    case common
    case high
}

private let whiteColorSerialized = "#ffffff"

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let destroyDate: Date?
    
    init(uid: String = UUID().uuidString,
         title: String,
         content: String,
         color: UIColor = UIColor.white,
         importance: Importance,
         relevantTo: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.destroyDate = relevantTo
    }
    
    func isRelevant() -> Bool {
        return destroyDate == nil ? true : Date() < destroyDate!
    }
}

extension Note {
    var json: [String: Any] {
        get {
            var result: [String: Any] = [
                "uid": uid,
                "title": title,
                "content": content
            ]
            
            if let relevantTo = destroyDate {
                result["destroy_date"] = Int(relevantTo.timeIntervalSince1970)
            }
            
            if importance != Importance.common {
                result["importance"] = importance.rawValue
            }
            
            if let hexColor = color.toHexString(), hexColor != whiteColorSerialized {
                result["color"] = hexColor
            }

            return result
        }
    }
    
    static func parse(json: [String: Any]) -> Note? {
        guard let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String else {
                return nil
        }
        
        var relevantTo: Date? = nil
        if let destroyDateEntry = json["destroy_date"] as? TimeInterval {
            relevantTo = Date(timeIntervalSince1970: destroyDateEntry)
        }
        
        let importanceEntry = json["importance"] as? Int
        var importance = Importance.common
        if let importanceEntry = importanceEntry {
            guard let value = Importance(rawValue: importanceEntry) else {
                return nil
            }
            importance = value
        }
        
        let colorEntry = json["color"] as? String
        let color: UIColor
        if let colorEntry = colorEntry {
            guard let parsed = UIColor.parseFromHex(string: colorEntry) else {
                return nil
            }
            
            color = parsed
        } else {
            color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return Note(
            uid: uid,
            title: title,
            content: content,
            color: color,
            importance: importance,
            relevantTo: relevantTo)
    }
}
