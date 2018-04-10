import FluentProvider

final class Event: Model {
    let storage = Storage()
    
    var creator: String
    var minCount: Int
    var maxCount: Int
    var startDate: String
    var endDate: String
    var latitude: Double?
    var longitude: Double?
    var description: String
    var isPrivate: Bool = false
    
    var activityId: Identifier?
    
    struct Keys {
        static let id = "_id"
        static let creator = "creator"
        static let minCount = "minCount"
        static let maxCount = "maxCount"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let description = "description"
        static let isPrivate = "isPrivate"
        static let activityId = "activityId"
        static let goings = "goings"
        static let activityName = "activityName"
    }
    
    init(from json: JSON, activity: Activity) throws {
        creator = try json.get(Keys.creator)
        minCount = try json.get(Keys.minCount)
        maxCount = try json.get(Keys.maxCount)
        startDate = try json.get(Keys.startDate)
        endDate = try json.get(Keys.endDate)
        latitude = try json.get(Keys.latitude)
        longitude = try json.get(Keys.longitude)
        description = try json.get(Keys.description)
        isPrivate = try json.get(Keys.isPrivate)
        activityId = activity.id
    }
    
    init(row: Row) throws {
        creator = try row.get(Keys.creator)
        minCount = try row.get(Keys.minCount)
        maxCount = try row.get(Keys.maxCount)
        startDate = try row.get(Keys.startDate)
        endDate = try row.get(Keys.endDate)
        latitude = try row.get(Keys.latitude)
        longitude = try row.get(Keys.longitude)
        description = try row.get(Keys.description)
        isPrivate = try row.get(Keys.isPrivate)
        activityId = try row.get(Activity.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.creator, creator)
        try row.set(Keys.minCount, minCount)
        try row.set(Keys.maxCount, maxCount)
        try row.set(Keys.startDate, startDate)
        try row.set(Keys.endDate, endDate)
        try row.set(Keys.latitude, latitude)
        try row.set(Keys.longitude, longitude)
        try row.set(Keys.description, description)
        try row.set(Keys.isPrivate, isPrivate)
        try row.set(Activity.foreignIdKey, activityId)
        return row
    }
    
    var usersGoing: Siblings<Event, User, Pivot<Event, User>> {
        return siblings()
    }
    
}

extension Event: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.creator)
            builder.int(Keys.minCount)
            builder.int(Keys.maxCount)
            builder.string(Keys.startDate)
            builder.string(Keys.endDate)
            builder.double(Keys.latitude)
            builder.double(Keys.longitude)
            builder.string(Keys.description)
            builder.bool(Keys.isPrivate)
            builder.parent(Activity.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension Event: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        if let id = self.id {
            try json.set(Keys.id, id)
        }
        try json.set(Keys.creator, creator)
        try json.set(Keys.minCount, minCount)
        try json.set(Keys.maxCount, maxCount)
        try json.set(Keys.startDate, startDate)
        try json.set(Keys.endDate, endDate)
        try json.set(Keys.longitude, longitude)
        try json.set(Keys.latitude, latitude)
        try json.set(Keys.description, description)
        try json.set(Keys.isPrivate, isPrivate)
        try json.set(Keys.activityId, try activity.get()?.id)
        try json.set(Keys.activityName, try activity.get()?.name)
        try json.set(Keys.goings, try usersGoing.all().flatMap({ $0.id }))
        
        return json
    }
    
    convenience init(json: JSON) throws {
        let activityId: Identifier = try json.get("activityId")
        guard let activity = try Activity.find(activityId) else {
            throw Abort.badRequest
        }
        try self.init(from: json, activity: activity)
    }
    
   
    
}

extension Event {
    var activity: Parent<Event, Activity> {
        return parent(id: activityId)
    }
}

extension Event: ResponseRepresentable { }

extension Event: Updateable {
    
    public static var updateableKeys: [UpdateableKey<Event>] {
        return [] // TODO: -
    }
}

