import FluentProvider

final class User: Model {
    let storage = Storage()
    
    var name: String
    var profilePic: String
    
    struct Keys {
        static let _id = "_id"
        static let name = "name"
        static let profilePic = "profilePic"
    }
    
    init(name: String, profilePic: String) {
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

extension User: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        if let id: Identifier = self.id {
            try json.set(Keys._id, id)
        }
        try json.set(Keys.name, name)
        try json.set(Keys.profilePic, profilePic)
        return json
    }
}

extension User: ResponseRepresentable { }



