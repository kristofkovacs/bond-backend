import FluentProvider

protocol Controller {
    func addRoutes(to drop: Droplet)
    func create(_ req: Request) throws -> ResponseRepresentable
    func all(_ req: Request) throws -> ResponseRepresentable
    func get(_ req: Request) throws -> ResponseRepresentable
}


final class ActivityController: ResourceRepresentable {
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Activity.all().makeJSON()
    }
    
    func makeResource() -> Resource<Post> {
        return Resource(
            index: index
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

//struct ActivityController: Controller {
//
//    func addRoutes(to drop: Droplet) {
//        let activityGroup = drop.grouped("api", "activities")
//        activityGroup.get(handler: all)
//        activityGroup.post("create", handler: create)
//        activityGroup.get(Activity.parameter, handler: get)
//        activityGroup.get(Activity.parameter, "tags", handler: getTagsForActivity)
//    }
//
//    func create(_ req: Request) throws -> ResponseRepresentable {
//        guard let json = req.json else {
//            throw Abort.badRequest
//        }
//        let activity = try Activity(json: json)
//        try activity.save()
//
//        if let tags = json["tags"]?.array {
//            try tags.flatMap({ return try Tag.find($0["_id"]) }).forEach({ try activity.tags.add($0) })
//
////            for tagJSON in tags {
////                if let tag = try Tag.find(tagJSON["_id"]) {
////                    try activity.tags.add(tag)
////                }
////            }
//        }
//        return activity
//    }
//
//    func all(_ req: Request) throws -> ResponseRepresentable {
//        let activities = try Activity.all()
//        return try activities.makeJSON()
//    }
//
//    func get(_ req: Request) throws -> ResponseRepresentable {
//        let activity = try req.parameters.next(Activity.self)
//        return activity
//    }
//
//    func getTagsForActivity(_ req: Request) throws -> ResponseRepresentable {
//        let activity = try req.parameters.next(Activity.self)
//        return try activity.tags.all().makeJSON()
//    }
//
//}

