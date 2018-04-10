import FluentProvider

final class TagController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Tag.all().makeJSON()
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        let tag = try Tag(json: json)
        try tag.save()
        
        if let activities = json["activities"]?.array {
            for activityJSON in activities {
                if let activity = try Activity.find(activityJSON["id"]) {
                    try tag.activities.add(activity)
                }
            }
        }
        return tag
    }
    
    func update(_ req: Request, tag: Tag) throws -> ResponseRepresentable {
        guard let json = req.json else { throw Abort.badRequest }
        if let activities = json["activities"]?.array {
            for activityJSON in activities {
                if let activity = try Activity.find(activityJSON["id"]) {
                    try tag.activities.add(activity)
                }
            }
        }
        return tag
    }
    
    func makeResource() -> Resource<Tag> {
        return Resource(
            index: index,
            store: store,
            update: update
        )
    }
}

extension Request {
    func tag() throws -> Tag {
        guard let json = json else { throw Abort.badRequest }
        return try Tag(json: json)
    }
}

extension TagController: EmptyInitializable { }
