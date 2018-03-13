import Vapor
import FluentSQLite

final class Activity: SQLiteModel {
    
    var id: Int?
    var name: String?
    var thumbnail: String?
    
}

extension Activity: Migration { }

extension Activity: Content { }

extension Activity: Parameter { }
