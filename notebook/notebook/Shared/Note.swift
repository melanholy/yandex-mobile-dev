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

private let whiteColorHex = "#ffffff"

struct Note: Equatable {
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
         destroyDate: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.destroyDate = destroyDate
    }
    
    func isRelevant() -> Bool {
        return destroyDate == nil ? true : Date() < destroyDate!
    }
    
    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.uid == rhs.uid
            && lhs.title == rhs.title
            && lhs.content == rhs.content
            && lhs.color == rhs.color
            && lhs.importance == rhs.importance
            && lhs.destroyDate == rhs.destroyDate
    }
}

extension Note {
    var json: [String: Any] {
        get {
            var result: [String: Any] = [
                "uid": uid.lowercased(),
                "title": title,
                "content": content
            ]
            
            if let relevantTo = destroyDate {
                result["destroy_date"] = Int(relevantTo.timeIntervalSince1970)
            }
            
            if importance != Importance.common {
                result["importance"] = importance.rawValue
            }
            
            if let hexColor = color.toHexString(), hexColor != whiteColorHex {
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
        
        var destroyDate: Date? = nil
        if let destroyDateEntry = json["destroy_date"] as? TimeInterval {
            destroyDate = Date(timeIntervalSince1970: destroyDateEntry)
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
            destroyDate: destroyDate)
    }
}
