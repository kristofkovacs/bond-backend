import Foundation
import FluentSQLite
import Vapor

final class Message: SQLiteModel {
    typealias ID = String
    static let idKey: IDKey = \Message.id
    
    var id: String?
    var conversationId: String?
    var senderId: String?
    var recipientId: String?
    var content: String?
    var isRead: Bool?
    var date: Int? // if we implement Timestampable protocol, we will have createdAt date by default.
    
}

extension Message {
    var conversation: Parent<Message, Conversation>? {
        return parent(\.conversationId)
    }
}

extension Message: Migration { }

extension Message: Content { }

extension Message: Parameter { }
