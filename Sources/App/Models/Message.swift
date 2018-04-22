import FluentProvider
import HTTP

final class Message: Model {
    let storage = Storage()
    
    var senderId: String
    var recipientId: String
    var content: String
//    var is_read: Bool = false
    var date: String
    var conversationId: Identifier?
    
    struct Keys {
        static let id = "id"
        static let conversationId = "conversationId"
        static let senderId = "senderId"
        static let recipientId = "recipientId"
        static let content = "content"
        static let date = "date"
    }
    
    init(senderId: String, recipientId: String, content: String, date: String?, conversation: Conversation) {
        self.senderId = senderId
        self.recipientId = recipientId
        self.content = content
        // TODO:
        self.date = date ?? ""
        self.conversationId = conversation.id
    }
    
    init(row: Row) throws {
        senderId = try row.get(Message.Keys.senderId)
        recipientId = try row.get(Message.Keys.recipientId)
        content = try row.get(Message.Keys.content)
        date = try row.get(Message.Keys.date)
        conversationId = try row.get(Conversation.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Message.Keys.senderId, senderId)
        try row.set(Message.Keys.recipientId, recipientId)
        try row.set(Message.Keys.content, content)
        try row.set(Message.Keys.date, date)
        try row.set(Conversation.foreignIdKey, conversationId)
        return row
    }
}

extension Message {
    var conversation: Parent<Message, Conversation> {
        return parent(id: conversationId)
    }
}

extension Message: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Message.Keys.senderId)
            builder.string(Message.Keys.recipientId)
            builder.string(Message.Keys.content)
            builder.string(Message.Keys.date)
            builder.parent(Conversation.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Message: JSONConvertible {
    convenience init(json: JSON) throws {
        let conversationId: Identifier = try json.get(Keys.conversationId)
        guard let conversation = try Conversation.find(conversationId) else {
            throw Abort.notFound
        }
        try self.init(senderId: json.get(Keys.senderId),
                      recipientId: json.get(Keys.recipientId),
                      content: json.get(Keys.content),
                      date: json.get(Keys.date),
                      conversation: conversation)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        if let id: Identifier = self.id {
            try json.set(Keys.id, id)
        }
        try json.set(Keys.senderId, senderId)
        try json.set(Keys.recipientId, recipientId)
        try json.set(Keys.content, content)
        try json.set(Keys.date, date)
        try json.set(Keys.conversationId, conversationId)
        return json
    }
    
}

extension Message: ResponseRepresentable { }


