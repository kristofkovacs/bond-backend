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
