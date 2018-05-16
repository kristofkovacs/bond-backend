import FluentProvider

final class User: Model {
    let storage = Storage()
    
    var name: String?
    var profilePic: String?
    
    var userName: String
    var password: String // TODO: - hash later
    
    var activities: Siblings<User, Activity, Pivot<User, Activity>> {
        return siblings()
    }
    
    var goings: Siblings<User, Event, Pivot<User, Event>> {
        return siblings()
    }
    
    var locations: Siblings<User, Location, Pivot<User, Location>> {
        return siblings()
    }
    
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let profilePic = "profilePic"
        static let goings = "goings"
        static let activities = "activities"
        static let userName = "userName"
        static let password = "password"
        static let locations = "locations"
    }
    
    init(name: String?, profilePic: String?, userName: String, password: String) {
        self.name = name
        self.profilePic = profilePic
        self.userName = userName
        self.password = password
    }
    
    init(row: Row) throws {
        name = try row.get(Keys.name)
        profilePic = try row.get(Keys.profilePic)
        userName = try row.get(Keys.userName)
        password = try row.get(Keys.password)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.name, name)
        try row.set(Keys.profilePic, profilePic)
        try row.set(Keys.userName, userName)
        try row.set(Keys.password, password)
        return row
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.name)
            builder.string(Keys.profilePic)
            builder.string(Keys.userName)
            builder.string(Keys.password)
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
        try json.set(Keys.userName, userName)
        try json.set(Keys.name, name)
        try json.set(Keys.profilePic, profilePic)
        try json.set(Keys.goings, try goings.all().flatMap { $0.id } )
        try json.set(Keys.activities, try activities.all().flatMap { $0.id } )
        try json.set(Keys.locations, try locations.all().flatMap( { $0.id }))
        return json
    }
  
  func makeDetailJSON() throws -> JSON {
      var json = JSON()
      if let id: Identifier = self.id {
        try json.set(Keys.id, id)
      }
      try json.set(Keys.userName, userName)
      try json.set(Keys.name, name)
      try json.set(Keys.profilePic, profilePic)
      try json.set(Keys.activities, try activities.all().makeJSON() )
      return json
  }
  
//  func makeProfileJSON() throws -> JSON {
//    
//  }
    
    convenience init(json: JSON) throws {
        self.init(name: try json.get(Keys.name),
                  profilePic: try json.get(Keys.profilePic),
                  userName: try json.get(Keys.userName),
                  password: try json.get(Keys.password))
    }
}

extension User: ResponseRepresentable { }

extension User: Updateable {
    
    public static var updateableKeys: [UpdateableKey<User>] {
        return [
            UpdateableKey(Keys.profilePic, String.self) { user, picUrl in
                user.profilePic = picUrl
            },
            UpdateableKey(Keys.name, String.self) { user, name in
                user.name = name
            },
            UpdateableKey(Keys.userName, String.self) { user, userName in
                user.userName = userName
            },
            UpdateableKey(Keys.password, String.self) { user, password in
                user.password = password
            }
        ]
    }
}

extension User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

