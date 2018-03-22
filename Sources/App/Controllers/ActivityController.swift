import FluentProvider

final class ActivityController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Activity.all().makeJSON()
    }
    
    func show(_ req: Request, activity: Activity) throws -> ResponseRepresentable {
        return activity
    }
    
    func makeResource() -> Resource<Activity> {
        return Resource(
            index: index,
            show:show
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
