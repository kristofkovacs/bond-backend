import Vapor
import FluentSQLite

final class Tag: SQLiteModel {
    typealias ID = Int
    static let idKey: IDKey = \Tag.id
    
    var id: Int?
    var name: String?
    
}

extension Tag: Migration { }

extension Tag: Content { }

extension Tag: Parameter { }
