import Foundation
import FluentSQLite
import Vapor

//final class UserActivityPivot: ModifiablePivot {
//    static var leftIDKey: WritableKeyPath<UserActivityPivot, String> = \UserActivityPivot.userId
//    
//    static var rightIDKey: WritableKeyPath<UserActivityPivot, Int> = \UserActivityPivot.activityId
//    
//    typealias Left = User
//    
//    typealias Right = Activity
//    
//    typealias Database = SQLiteDatabase
//    
//    typealias ID = String
//    
//    static let idKey: IDKey = \UserActivityPivot.id
//    
//    var id: ID?
//    var userId: User.ID?
//    var activityId: Activity.ID?
//    
//    init(_ left: UserActivityPivot.Left, _ right: UserActivityPivot.Right) throws {
//        userId = try left.requireID()
//        activityId = try right.requireID()
//    }
//    
//}

