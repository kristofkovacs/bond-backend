import FluentProvider

struct Coordinates: JSONConvertible {
    let latitude: Float
    let longitude: Float
    
    struct Keys {
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    init(json: JSON) throws {
        latitude = try json.get(Keys.latitude)
        longitude = try json.get(Keys.longitude)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keys.latitude, latitude)
        try json.set(Keys.longitude, longitude)
        return json
    }
    
}

final class Location: Model {
    let storage = Storage()
    
    var name: String
    var description: String
//    var latitude: Double = 0.0
//    var longitude: Double = 0.0
    
    var relatedUsers: Siblings<Location, User, Pivot<Location, User>> {
        return siblings()
    }
    
    struct Keys {
        static let id = "_id"
        static let name = "name"
        static let description = "description"
//        static let latitude = "latitude"
//        static let longitude = "longitude"
//        static let nearLocation = "nearLocation"
    }
    
    init(name: String, description: String){
        self.name = name
        self.description = description
    }
    
    init(row: Row) throws {
        name = try row.get(Keys.name)
        description = try row.get(Keys.description)
//        latitude = try row.get(Keys.latitude)
//        longitude = try row.get(Keys.longitude)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.name, name)
        try row.set(Keys.description, description)
//        try row.set(Keys.latitude, latitude)
//        try row.set(Keys.longitude, longitude)
        return row
    }
}

extension Location: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.name)
            builder.string(Keys.description)
//            builder.double(Keys.latitude)
//            builder.double(Keys.longitude)
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
        return json
    }
    
    convenience init(json: JSON) throws {
        self.init(name: try json.get(Keys.name),
                      description: try json.get(Keys.description))
    }
    
}

extension Location: ResponseRepresentable { }



