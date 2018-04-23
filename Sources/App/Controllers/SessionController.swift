//
//  SessionController.swift
//  App
//
//  Created by Gujgiczer Máté on 2018. 04. 10..
//

import FluentProvider

final class SessionController: ResourceRepresentable {
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        //let credetial = try req.credential()
        // TODO: - get user by credentail
        guard let testUser = try User.all().first else { throw Abort(.notImplemented) }
        let token = try AuthMiddleware.login(testUser)
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
    
    func credential() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(json: json)
    }
}
