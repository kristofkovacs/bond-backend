import Foundation
import FluentSQLite
import Vapor

final class Conversation: SQLiteModel {
    typealias ID = String
    static let idKey: IDKey = \.id
    
    var id: String?
    var eventId: String?
    
}

extension Conversation {
    var messages: Children<Conversation, Message> {
        return children(\.id)
    }
    
    var event: Parent<Conversation, Event> {
        return parent(\.eventId)!
    }
}

extension Conversation: Migration { }

extension Conversation: Content { }

extension Conversation: Parameter { }
