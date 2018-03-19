import FluentProvider

final class TagController: ResourceRepresentable {
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Tag.all().makeJSON()
    }
    
    func makeResource() -> Resource<Tag> {
        return Resource(
            index: index
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

//struct TagController: Controller {
//    func addRoutes(to drop: Droplet) {
//        let tagGroup = drop.grouped("api", "tags")
//        tagGroup.get(handler: all)
//        tagGroup.post("create", handler: create)
//        tagGroup.get(Tag.parameter, handler: get)
//        tagGroup.get(Tag.parameter, "activities", handler: getActivitiesForTag)
//    }
//
//    func create(_ req: Request) throws -> ResponseRepresentable {
//        func saveTag(json: JSON) throws -> Tag {
//            let tag = try Tag(json: json)
//            try tag.save()
//            return tag
//        }
//
//        guard let json = req.json else {
//            throw Abort.badRequest
//        }
//        guard let tagArray = json.array else {
//            return try saveTag(json: json)
//        }
//        return try tagArray.flatMap({ (tagJSON) -> Tag? in
//            try saveTag(json: tagJSON)
//        }).makeJSON()
//    }
//
//    func all(_ req: Request) throws -> ResponseRepresentable {
//        let tags = try Tag.all()
//        return try tags.makeJSON()
//    }
//
//    func get(_ req: Request) throws -> ResponseRepresentable {
//        let tag = try req.parameters.next(Tag.self)
//        return tag
//    }
//
//    func getActivitiesForTag(_ req: Request) throws -> ResponseRepresentable {
//        let tag = try req.parameters.next(Tag.self)
//        return try tag.activities.all().makeJSON()
//    }
//}

