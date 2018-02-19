import Vapor
import FluentSQLite

final class Activity: SQLiteModel {
    typealias ID = Int
    
    static let idKey: IDKey = \Activity.id
    
    var id: Int?
    var name: String?
    var thumbnail: String?
    
}

extension Activity: Migration { }

extension Activity: Content { }

extension Activity: Parameter { }
