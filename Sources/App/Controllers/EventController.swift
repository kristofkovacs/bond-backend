//
//  EventController.swift
//  Bond-v2PackageDescription
//
//  Created by Gujgiczer Máté on 2018. 03. 21..
//

import FluentProvider

final class EventController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Event.all().sorted(by: { $0.startDate < $1.startDate } ).makeJSON()
    }
    
    func show(_ req: Request, event: Event) throws -> ResponseRepresentable {
        return try event.makeDetailJSON()
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let event = try req.event()
        try event.save()
        return event.createdResponse
    }
    
    func delete(_ req: Request, event: Event) throws -> ResponseRepresentable {
        try event.delete()
        return Response(status: .ok)
    }
    
    func update(_ req: Request, event: Event) throws -> ResponseRepresentable {
        try event.update(for: req)
        try event.save()
        return Response(status: .ok)
    }
    
    func makeResource() -> Resource<Event> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            destroy: delete
        )
    }
}

extension Request {
    
    func event() throws -> Event {
        guard let json = json else { throw Abort.badRequest }
        return try Event(json: json)
    }
}

extension EventController: EmptyInitializable { }

extension EventController {
    
    func addUserToInterested(_ req: Request) throws -> ResponseRepresentable {
        let event = try req.parameters.next(Event.self)
        let user = try req.authStatus.authenticatedUser()
        throw Abort(.notImplemented, reason: "Should add \(user.userName) to \(event.description ?? "event") interested")
    }
    
    func removeUserFromInterested(_ req: Request) throws -> ResponseRepresentable {
        let event = try req.parameters.next(Event.self)
        let user = try req.authStatus.authenticatedUser()
        throw Abort(.notImplemented, reason: "Should remove \(user.userName) from \(event.description ?? "event") interested")
    }
    
    func addUserToGoing(_ req: Request) throws -> ResponseRepresentable {
        let event = try req.parameters.next(Event.self)
        let user = try req.authStatus.authenticatedUser()
        if try event.usersGoing.isAttached(user) { throw Abort(.notModified) }
        try event.usersGoing.add(user)
        return Response(status: .ok)
    }
    
    func removeUserFromGoing(_ req: Request) throws -> ResponseRepresentable {
        let event = try req.parameters.next(Event.self)
        let user = try req.authStatus.authenticatedUser()
        try event.usersGoing.remove(user)
        return Response(status: .ok)
    }
    
    func createConversation(_ req: Request) throws -> ResponseRepresentable {
        let event = try req.parameters.next(Event.self)
        throw Abort(.notImplemented, reason: "Should create a conversation for \(event.description ?? "event")")
    }
}
