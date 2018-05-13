//
//  Coordinates.swift
//  App
//
//  Created by Gujgiczer Máté on 2018. 05. 09..
//

import FluentProvider

final class Coordinates: Model {
    let storage = Storage()
    
    var latitude: Float
    var longitude: Float
    var locationId: Identifier?
    
    init(latitude: Float, longitude: Float, locationId: Identifier) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationId = locationId
    }
    
    init(latitude: Float, longitude: Float, location: Location) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationId = location.id
    }
    
    struct Keys {
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let locationId = "locationId"
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.latitude, latitude)
        try row.set(Keys.longitude, longitude)
        try row.set(Keys.locationId, locationId)
        return row
    }
    
    init(row: Row) throws {
        self.latitude = try row.get(Keys.latitude)
        self.longitude = try row.get(Keys.longitude)
        self.locationId = try row.get(Keys.locationId)
    }
}

extension Coordinates: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Coordinates.Keys.latitude)
            builder.string(Coordinates.Keys.longitude)
            builder.parent(Location.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Coordinates: JSONConvertible {
    
    convenience init(json: JSON) throws {
        try self.init(latitude: json.get(Keys.latitude),
                      longitude: json.get(Keys.longitude),
                      locationId: json.get(Keys.locationId))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keys.latitude, latitude)
        try json.set(Keys.longitude, longitude)
        return json
    }
}
