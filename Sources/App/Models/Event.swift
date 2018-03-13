import FluentSQLite
import Foundation
import Vapor

final class Event: SQLiteStringModel {
    
    var id: String?
    var activityId: String?
    var creatorId: String?
    var dateBegin: Int?
    var dateEnd: Int?
    var spotsMin: Int?
    var spotsMax: Int?
    var spotsRemaining: Int?
    var description: String?
    var isPrivate: Bool = false
    var createdAt: Date?
    var updatedAt: Date?
    
}

extension Event {
    var conversations: Children<Event, Conversation> {
        return children(\.id)
    }
}

extension Event: Migration { }

extension Event: Content { }

extension Event: Parameter { }

//extension Event: Timestampable {
//    static var createdAtKey: ReferenceWritableKeyPath<Event, Date?> {
//        <#code#>
//    }
//
//    static var updatedAtKey: ReferenceWritableKeyPath<Event, Date?> {
//        <#code#>
//    }
//
//}

