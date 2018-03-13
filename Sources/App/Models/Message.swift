import Foundation
import FluentSQLite
import Vapor

final class Message: SQLiteStringModel {
    
    
    var id: String?
    var conversationId: String?
    var senderId: String?
    var recipientId: String?
    var content: String?
    var isRead: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    
}

extension Message {
    var conversation: Parent<Message, Conversation>? {
        return parent(\.conversationId)
    }
}

extension Message: Timestampable {
    static var createdAtKey: WritableKeyPath<Message, Date?> {
        return \Message.createdAt
    }
    
    static var updatedAtKey: WritableKeyPath<Message, Date?> {
        return \Message.updatedAt
    }
}

extension Message: Migration { }

extension Message: Content { }

extension Message: Parameter { }
