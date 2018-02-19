import FluentSQLite
import Foundation
import Vapor

final class Event: SQLiteModel {
    typealias ID = String
    static let idKey: IDKey = \.id
    
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

