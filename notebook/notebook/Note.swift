//
//  Note.swift
//  notebook
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

enum Importance: Int {
    case low = 0
    case common = 1
    case high = 2
}

struct Note {
    private static let defaultRelevantInterval: TimeInterval = 7 * 24 * 60 * 60
    
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let relevantTo: Date
    
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
        if let relevantTo = relevantTo {
            self.relevantTo = relevantTo
        } else {
            self.relevantTo = Date().addingTimeInterval(Note.defaultRelevantInterval)
        }
    }
    
    func isRelevant() -> Bool {
        return Date() < relevantTo
    }
}

extension Note {
    var json: [String: Any] {
        get {
            var result: [String: Any] = [
                "uid": uid,
                "title": title,
                "content": content,
                "relevantTo": relevantTo.timeIntervalSince1970
            ]
            
            if importance != Importance.common {
                result["importance"] = importance.rawValue
            }
            
            if color != UIColor.white {
                result["color"] = color.cgColor.components
            }
            
            return result
        }
    }
    
    static func parse(json: [String: Any]) -> Note? {
        guard let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String,
            let relevantTo = json["relevantTo"] as? TimeInterval else {
                return nil
        }
        
        let importanceEntry = json["importance"] as? Int
        var importance = Importance.common
        if let importanceEntry = importanceEntry {
            guard let value = Importance(rawValue: importanceEntry) else {
                return nil
            }
            importance = value
        }
        
        let colorEntry = json["color"] as? [CGFloat]
        var color = UIColor.white
        if let colorEntry = colorEntry {
            if colorEntry.count == 2 {
                color = UIColor(white: colorEntry[0], alpha: colorEntry[1])
            } else if colorEntry.count == 4 {
                color = UIColor(
                    red: colorEntry[0],
                    green: colorEntry[1],
                    blue: colorEntry[2],
                    alpha: colorEntry[3])
            } else {
                return nil
            }
        }
        
        return Note(
            uid: uid,
            title: title,
            content: content,
            color: color,
            importance: importance,
            relevantTo: Date(timeIntervalSince1970: relevantTo))
    }
}
