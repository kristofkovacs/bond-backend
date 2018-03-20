import FluentProvider

final class Event: Model {
    let storage = Storage()
    
    var creator: String
    var minCount: Int
    var maxCount: Int
    var startDate: String
    var endDate: String
    var description: String
    var isPrivate: Bool = false
    
    struct Keys {
        static let id = "_id"
        static let creator = "creator"
        static let minCount = "minCount"
        static let maxCount = "maxCount"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let description = "description"
        static let isPrivate = "isPrivate"
    }
    
    init(from json: JSON) throws {
        creator = try json.get(Keys.creator)
        minCount = try json.get(Keys.minCount)
        maxCount = try json.get(Keys.maxCount)
        startDate = try json.get(Keys.startDate)
        endDate = try json.get(Keys.endDate)
        description = try json.get(Keys.description)
        isPrivate = try json.get(Keys.isPrivate)
    }
    
    init(row: Row) throws {
        creator = try row.get(Keys.creator)
        minCount = try row.get(Keys.minCount)
        maxCount = try row.get(Keys.maxCount)
        startDate = try row.get(Keys.startDate)
        endDate = try row.get(Keys.endDate)
        description = try row.get(Keys.description)
        isPrivate = try row.get(Keys.isPrivate)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.creator, creator)
        try row.set(Keys.minCount, minCount)
        try row.set(Keys.maxCount, maxCount)
        try row.set(Keys.startDate, startDate)
        try row.set(Keys.endDate, endDate)
        try row.set(Keys.description, description)
        try row.set(Keys.isPrivate, description)
        return row
    }
    
}

extension Event: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.creator)
            builder.int(Keys.minCount)
            builder.int(Keys.maxCount)
            builder.string(Keys.startDate)
            builder.string(Keys.endDate)
            builder.string(Keys.description)
            builder.bool(Keys.isPrivate)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension Event: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        if let id = self.id {
            try json.set(Keys.id, id)
        }
        try json.set(Keys.creator, creator)
        try json.set(Keys.minCount, minCount)
        try json.set(Keys.maxCount, maxCount)
        try json.set(Keys.startDate, startDate)
        try json.set(Keys.endDate, endDate)
        try json.set(Keys.description, description)
        try json.set(Keys.isPrivate, isPrivate)
        return json
    }
    
    convenience init(json: JSON) throws {
        try self.init(from: json)
    }
    
    
}



extension Event: ResponseRepresentable {
    
}

