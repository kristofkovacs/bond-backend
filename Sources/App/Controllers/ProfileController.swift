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
            guard let location = (try? Location.find(id)) ?? nil else { throw Abort.notFound }
            if try user.locations.isAttached(location) { throw Abort(.notModified) }
            try user.locations.add(location)
        })
        
        return Response(status: .ok)
    }
    
    func removeLocation(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.authStatus.authenticatedUser()
        let location = try req.parameters.next(Location.self)
        guard try user.locations.isAttached(location) else { throw Abort(.notModified)  }
        
        try user.locations.remove(location)
        return Response(status: .ok)
    }
    
    func addActivity(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.authStatus.authenticatedUser()
        
        try req.data["ids"]?.array?.forEach({ idNode in
            guard let id = idNode.string else { throw Abort.badRequest }
            guard let activity = (try? Activity.find(id)) ?? nil else { throw Abort.notFound }
            if try user.activities.isAttached(activity) { throw Abort(.notModified) }
            try user.activities.add(activity)
        })
        
        return Response(status: .ok)
    }
    
    func removeActivity(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.authStatus.authenticatedUser()
        let activity = try req.parameters.next(Activity.self)
        guard try user.activities.isAttached(activity) else { throw Abort(.notModified)  }
        
        try user.activities.remove(activity)
        return Response(status: .ok)
    }
}
