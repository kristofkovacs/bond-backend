import Foundation
import FluentSQLite
import Vapor

final class User: SQLiteModel {
    typealias ID = String
    static let idKey: IDKey = \User.id
    
    var id: String?
    var email: String?
    var name: String?
    var profile_picture: String?
    
}



extension User {
    var activities: Siblings<User, Activity, UserActivityPivot> {
        return siblings()
    }
    
    
    
}

extension User: Migration { }

extension User: Content { }

extension User: Parameter { }
