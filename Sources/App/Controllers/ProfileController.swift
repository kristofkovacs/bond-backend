//
//  ProfileController.swift
//  App
//
//  Created by Gujgiczer Máté on 2018. 04. 25..
//

import Foundation

final class ProfileController {
    
    func showUser(_ req: Request) throws -> User {
        return try req.authStatus.authenticatedUser()
    }
    
    func addLocation(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.authStatus.authenticatedUser()
        
        try req.data["ids"]?.array?.forEach({ idNode in
            guard let id = idNode.string else { throw Abort.badRequest }
            if let _ = try user.locations.find(id) { throw Abort(.notModified) }
            guard let location = try Location.find(id) else { throw Abort.notFound }
            try user.locations.add(location)
        })
        
        return Response(status: .ok)
    }
    
    func removeLocation(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.authStatus.authenticatedUser()
        guard let location = try Location.find(req.data["id"]?.string) else { throw Abort.badRequest }
        
        try user.locations.remove(location)
        return Response(status: .ok)
    }
    
    func addActivity(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.authStatus.authenticatedUser()
        guard let activityId = req.data["id"]?.string else { throw Abort.badRequest } //TODO: - make plural like location
        if let _ = try user.activities.find(activityId) { throw Abort(.notModified) }
        guard let activity = try Activity.find(activityId) else { throw Abort(.notFound) }
        
        try user.activities.add(activity)
        return Response(status: .ok)
    }
    
    func removeActivity(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.authStatus.authenticatedUser()
        let activity = try req.parameters.next(Activity.self)
        guard try user.activities.isAttached(activity) else { throw Abort.badRequest }
        
        try user.activities.remove(activity)
        return Response(status: .ok)
    }
}
