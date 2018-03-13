import Foundation
import FluentSQLite
import Vapor

//final class UserEventPivot: ModifiablePivot {
//    typealias Left = User
//    
//    typealias Right = Event
//    
//    typealias Database = SQLiteDatabase
//    
//    typealias ID = String
//    
//    static let idKey: IDKey = \UserEventPivot.id
//    static var leftIDKey: ReferenceWritableKeyPath<UserEventPivot, String> = \UserEventPivot.userId
//    
//    static var rightIDKey: ReferenceWritableKeyPath<UserEventPivot, String> = \UserEventPivot.eventId
//    
//    var id: ID?
//    var userId: User.ID
//    var eventId: Event.ID
//    
//    init(_ left: UserEventPivot.Left, _ right: UserEventPivot.Right) throws {
//        userId = try left.requireID()
//        eventId = try right.requireID()
//    }
//    
//}

