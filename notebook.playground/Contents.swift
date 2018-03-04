import UIKit

enum Importance: Int {
    case low = 0
    case common = 1
    case high = 2
}

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    
    init(uid: String = UUID().uuidString,
         title: String,
         content: String,
         color: UIColor = UIColor.white,
         importance: Importance) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
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
            if importance != Importance.common {
                result["importance"] = importance.rawValue
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
        
        let importanceEntry = json["importance"] as? Int
        var importance: Importance = Importance.common
        if (importanceEntry != nil) {
            guard let value = Importance(rawValue: importanceEntry!) else {
                return nil
            }
            importance = value
        }
        
        return Note(uid: uid, title: title, content: content, color: UIColor.white, importance: importance)
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
    
    func addNote(note: Note) -> Bool {
        if notes.contains(where: { (existingNote) -> Bool in
            return existingNote.uid == note.uid
        }) {
            return false
        }
        
        notes.append(note)
        
        return true
    }
    
    func removeNote(withUid uid: String) -> Bool {
        guard let index = notes.index(where: { (note) -> Bool in
            return note.uid == uid
        }) else {
            return false
        }
        
        notes.remove(at: index)
        
        return true
    }
    
    func save() throws {
        guard let filePath = FileNotebook.filePath else {
            return
        }
        
        let jsonNotes = notes.map { (note) -> [String: Any] in
            return note.json
        }
        
        let data = try! JSONSerialization.data(withJSONObject: jsonNotes, options: [])
        guard let jsonString = String(data: data, encoding: .utf8) else {
            return
        }
        
        try! jsonString.write(toFile: filePath, atomically: false, encoding: .utf8)
    }
    
    func load() throws {
        guard let filePath = FileNotebook.filePath else {
            return
        }
        
        let content = try! String(contentsOfFile: filePath)
        guard let data = content.data(using: .utf8),
              let jsonArray = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return
        }
        
        var loadedNotes = [Note]()
        for obj in jsonArray {
            let note = Note.parse(json: obj)
            if note != nil {
                loadedNotes.append(note!)
            }
        }
        
        notes = loadedNotes
    }
}

let note1 = Note(title: "article", content: "good times!", color: UIColor.black, importance: Importance.high)
let note2 = Note(uid: "23432", title: "news", content: "bad times :(", importance: Importance.common)

let notebook1 = FileNotebook()
notebook1.addNote(note: note1)
notebook1.addNote(note: note2)
print(FileNotebook.filePath!)
try! notebook1.save()

let notebook2 = FileNotebook()
try! notebook2.load()
print(notebook2.notes)














