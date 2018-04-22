import FluentProvider
import HTTP

final class Activity: Model {
    let storage = Storage()
    
    var name: String
    var thumbnail: String?
    
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let thumbnail = "thumbnail"
        static let tags = "tags"
    }
    
    init(name: String, thumbnail: String?) {
        self.name = name
        self.thumbnail = thumbnail
    }
    
    init(row: Row) throws {
        name = try row.get(Activity.Keys.name)
        thumbnail = try row.get(Activity.Keys.thumbnail)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Activity.Keys.name, name)
        try row.set(Activity.Keys.thumbnail, thumbnail)
        return row
    }
    
    var users: Siblings<Activity, User, Pivot<Activity, User>> {
        return siblings()
    }
    
}

extension Activity {
    var tags: Siblings<Activity, Tag, Pivot<Activity, Tag>> {
        return siblings()
    }
}

extension Activity: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Activity.Keys.name)
            builder.string(Activity.Keys.thumbnail)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Activity: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(name: json.get(Keys.name),
                      thumbnail: json.get(Keys.thumbnail))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        if let id: Identifier = self.id {
            try json.set(Keys.id, id)
        }
        try json.set(Keys.name, name)
        try json.set(Keys.thumbnail, thumbnail)
        try json.set(Keys.tags, try tags.all().flatMap { try $0.makeSiblingJSON() } )
        return json
    }
    
    func makeSiblingJSON() throws -> JSON {
        var json = JSON()
        
        if let id: Identifier = self.id {
            try json.set(Keys.id, id)
        }
        try json.set(Keys.name, name)
        try json.set(Keys.thumbnail, thumbnail)
        return json
    }
    
}

extension Activity: ResponseRepresentable { }

