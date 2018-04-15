import FluentProvider

final class Conversation: Model {
    func makeRow() throws -> Row {
        let row = Row()
        return row
    }
    
    init(row: Row) throws {
        
    }
    
    init() { }
    
    let storage = Storage()
    
    struct Keys {
        static let id = "_id"
        static let messages = "messages"
    }
}

extension Conversation {
    var messages: Children<Conversation, Message> {
        return children()
    }
}

extension Conversation: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
        }
    }
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension Conversation: JSONConvertible {
    convenience init(json: JSON) throws {
        // TODO: - init from JSON !!
        self.init()
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        if let id: Identifier = self.id {
            try json.set(Keys.id, id)
        }
        try json.set(Keys.messages, try messages.all().makeJSON())
        return json
    }
}

extension Conversation: ResponseRepresentable { }

