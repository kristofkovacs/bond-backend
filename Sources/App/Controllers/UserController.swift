import FluentProvider

final class UserController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try User.all().makeJSON()
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.user()
        try user.save()
        return user.createdResponse
    }
    
    func show(_ req: Request, user: User) throws -> ResponseRepresentable {
        return user
    }
    
    func delete(_ req: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return Response(status: .ok)
    }
    
    func update(_ req: Request, user: User) throws -> ResponseRepresentable {
        try user.update(for: req)
        try user.save()
        return Response(status: .ok)
    }
    
    func makeResource() -> Resource<User> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            destroy: delete
        )
    }
}

extension UserController: EmptyInitializable { }

extension Request {
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(json: json)
    }
}

extension UserController {
    func addLocation(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.parameters.next(User.self)
        guard let locationId = req.data["id"]?.string else { throw Abort.badRequest }
        throw Abort(.notImplemented, reason: "Should add \(locationId) to \(user.name) as a new preferred location.")
    }
    
    func removeLocation(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.parameters.next(User.self)
        guard let locationId = req.data["id"]?.string else { throw Abort.badRequest }
        throw Abort(.notImplemented, reason: "Should remove \(locationId) from \(user.name)'s preferred locations.")
    }
    
    func addActivity(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.parameters.next(User.self)
        guard let activityId = req.data["id"]?.string else { throw Abort.badRequest }
        throw Abort(.notImplemented, reason: "Should add \(activityId) to \(user.name) as a new preferred activity.")
    }
    
    func removeActivity(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.parameters.next(User.self)
        guard let activityId = req.data["id"]?.string else { throw Abort.badRequest }
        throw Abort(.notImplemented, reason: "Should remove \(activityId) from \(user.name)'s preferred activities.")
    }
}

