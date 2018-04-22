import FluentProvider
import HTTP

final class Tag: Model {
    let storage = Storage()
    
    var name: String
    
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let activities = "activities"
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(row: Row) throws {
        name = try row.get(Tag.Keys.name)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Tag.Keys.name, name)
        return row
    }
    
}

extension Tag {
    var activities: Siblings<Tag, Activity, Pivot<Tag, Activity>> {
        return siblings()
    }
}

extension Tag: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Tag.Keys.name)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Tag: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(name: json.get(Tag.Keys.name))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        if let id: Identifier = self.id {
            try json.set(Keys.id, id)
        }
        try json.set(Keys.name, name)
        try json.set(Keys.activities, try activities.all().compactMap { try $0.makeSiblingJSON() } )
        return json
    }
    
    func makeSiblingJSON() throws -> JSON {
        var json = JSON()
        if let id: Identifier = self.id {
            try json.set(Keys.id, id)
        }
        try json.set(Keys.name, name)
        return json
    }
}

extension Tag: ResponseRepresentable { }
