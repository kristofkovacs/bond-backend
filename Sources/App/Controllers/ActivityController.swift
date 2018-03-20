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
