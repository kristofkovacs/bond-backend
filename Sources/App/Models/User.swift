import Foundation
import FluentSQLite
import Vapor

final class User: SQLiteStringModel {
    
    
    var id: String?
    var email: String?
    var name: String?
    var profile_picture: String?
    
}

extension User {
//    var activities: Siblings<User, Activity, UserActivityPivot> {
//        return siblings()
//    }
}

extension User: Migration { }

extension User: Content { }

extension User: Parameter { }
