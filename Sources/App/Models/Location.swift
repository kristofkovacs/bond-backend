import FluentProvider

final class Location: Model {
    let storage = Storage()
    
    var name: String
    var description: String

    var coordinates: Coordinates? {
        return (try? children().first()) ?? nil
    }
    
    var relatedUsers: Siblings<Location, User, Pivot<Location, User>> {
        return siblings()
    }
    
    struct Keys {
        static let id = "_id"
        static let name = "name"
        static let description = "description"
        static let coordinates = "coordinates"
    }
    
    init(name: String, description: String){
        self.name = name
        self.description = description
    }
    
    init(row: Row) throws {
        name = try row.get(Keys.name)
        description = try row.get(Keys.description)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.name, name)
        try row.set(Keys.description, description)
        return row
    }
}

extension Location: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.name)
            builder.string(Keys.description)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Location: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        if let id = self.id { try json.set(Keys.id, id) }
        try json.set(Keys.name, name)
        try json.set(Keys.description, description)
        if let coordinates = coordinates {
            try json.set(Keys.coordinates, try coordinates.makeJSON())
        }
        return json
    }
    
    convenience init(json: JSON) throws {
        self.init(name: try json.get(Keys.name),
                      description: try json.get(Keys.description))
    }
    
}

extension Location: ResponseRepresentable { }



