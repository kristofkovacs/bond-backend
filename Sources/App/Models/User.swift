import FluentProvider

final class User: Model {
    let storage = Storage()
    
    var name: String
    var profilePic: String?
    
    struct Keys {
        static let id = "_id"
        static let name = "name"
        static let profilePic = "profilePic"
        static let goings = "goings"
        static let activities = "activities"
    }
    
    init(name: String, profilePic: String?) {
        self.name = name
        self.profilePic = profilePic
    }
    
    init(row: Row) throws {
        name = try row.get(Keys.name)
        profilePic = try row.get(Keys.profilePic)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.name, name)
        try row.set(Keys.profilePic, profilePic)
        return row
    }
    
    var activities: Siblings<User, Activity, Pivot<User, Activity>> {
        return siblings()
    }
    
    var goings: Siblings<User, Event, Pivot<User, Event>> {
        return siblings()
    }
    
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.name)
            builder.string(Keys.profilePic)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        if let id: Identifier = self.id {
            try json.set(Keys.id, id)
        }
        try json.set(Keys.name, name)
        try json.set(Keys.profilePic, profilePic)
        try json.set(Keys.goings, try goings.all().flatMap({ $0.id }))
        try json.set(Keys.activities, try activities.all().flatMap({ $0.id }))
        return json
    }
    
    convenience init(json: JSON) throws {
        self.init(name: try json.get(Keys.name),
                      profilePic: try json.get(Keys.profilePic))
    }
}

extension User: ResponseRepresentable { }

extension User: Updateable {
    
    public static var updateableKeys: [UpdateableKey<User>] {
        return [] // TODO: -
    }
}

