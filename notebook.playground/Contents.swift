import UIKit

enum Importance: Int {
    case low
    case common
    case high
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
        self.relevantTo = relevantTo ?? Date().addingTimeInterval(Note.defaultRelevantInterval)
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

class FileNotebook {
    private static let storeFilename = "notes.json"
    
    private(set) var notes = [Note]()
    
    static var filePath: String? {
        guard let dir = NSSearchPathForDirectoriesInDomains(
                            .documentDirectory,
                            .allDomainsMask,
                            true).first else {
            return nil
        }
        
        let path = "\(dir)/\(storeFilename)"

        return path
    }
    
    func add(_ note: Note) -> Bool {
        if notes.contains(where: { $0.uid == note.uid }) {
            return false
        }
        
        notes.append(note)
        
        return true
    }
    
    func removeNote(withUid uid: String) -> Bool {
        guard let index = notes.index(where: { $0.uid == uid }) else {
            return false
        }
        
        notes.remove(at: index)
        
        return true
    }
    
    func save() throws {
        guard let filePath = FileNotebook.filePath else {
            return
        }
        
        let jsonNotes = notes.map { $0.json }
        
        let data = try JSONSerialization.data(withJSONObject: jsonNotes, options: [])
        guard let jsonString = String(data: data, encoding: .utf8) else {
            return
        }
        
        try jsonString.write(toFile: filePath, atomically: false, encoding: .utf8)
    }
    
    func load() throws {
        guard let filePath = FileNotebook.filePath else {
            return
        }
        
        let content = try String(contentsOfFile: filePath)
        guard let data = content.data(using: .utf8),
              let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return
        }
        
        var loadedNotes = [Note]()
        for obj in jsonArray {
            let note = Note.parse(json: obj)
            if let note = note {
                loadedNotes.append(note)
            }
        }
        
        notes = loadedNotes
    }
}

print(FileNotebook.filePath!)

let note1 = Note(title: "article", content: "good times!", color: UIColor.brown, importance: Importance.high)
let note2 = Note(uid: "23432", title: "news", content: "bad times :(", importance: Importance.common)
let note3 = Note(title: "oooo", content: "aaaa", importance: Importance.low, relevantTo: Date())

let notebook1 = FileNotebook()
notebook1.add(note1)
notebook1.add(note2)
notebook1.add(note3)
try! notebook1.save()

let notebook2 = FileNotebook()
try! notebook2.load()

print(notebook1.notes)
print(notebook2.notes)














