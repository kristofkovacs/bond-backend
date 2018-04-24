//
//  SessionController.swift
//  App
//
//  Created by Gujgiczer Máté on 2018. 04. 10..
//

import FluentProvider

final class SessionController: ResourceRepresentable {
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let token = try AuthMiddleware.login(req.userByCredential())
        return try JSON(node: ["id": token])
    }
    
    func delete(_ req: Request) throws -> ResponseRepresentable {
        try AuthMiddleware.logout(req)
        return Response(status: .ok)
    }
    
    func makeResource() -> Resource<User> {
        return Resource(
            store: store,
            clear: delete
        )
    }
}

extension SessionController: EmptyInitializable { }

extension Request {
    
    func userByCredential() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        guard let userName = json["userName"]?.string else { throw Abort.badRequest }
        guard let password = json["password"]?.string else { throw Abort.badRequest }
        guard let user = try User.makeQuery().filter("userName", .equals, userName).first() else {
            throw Abort(.unauthorized) // No suc user
        }
        guard user.password == password else {
            throw Abort(.unauthorized) // Wong pass
        }
        return user
    }
}
