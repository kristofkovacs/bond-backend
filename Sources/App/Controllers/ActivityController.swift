import FluentProvider

final class ActivityController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Activity.all().makeJSON()
    }
    
    func show(_ req: Request, activity: Activity) throws -> ResponseRepresentable {
        return activity
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        let activity = try Activity(json: json)
        try activity.save()
        
        if let tags = json["tags"]?.array {
            for tagJSON in tags {
                if let tag = try Tag.find(tagJSON["id"]) {
                    try activity.tags.add(tag)
                }
            }
        }
        return activity
    }
    
    func update(_ req: Request, activity: Activity) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        
        if let tags = json["tags"]?.array {
            for tagJSON in tags {
                if let tag = try Tag.find(tagJSON["id"]) {
                    try activity.tags.add(tag)
                }
            }
        }
        return activity
    }
    
    func makeResource() -> Resource<Activity> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update
        )
    }
    
}

extension Request {
    func activity() throws -> Activity {
        guard let json = json else { throw Abort.badRequest }
        return try Activity(json: json)
    }
}

extension ActivityController: EmptyInitializable { }
