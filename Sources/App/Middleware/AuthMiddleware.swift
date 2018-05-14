//
//  AuthMiddleware.swift
//  App
//
//  Created by Gujgiczer Máté on 2018. 04. 23..
//

import Foundation
import HTTP
import Cache

final class AuthMiddleware: Middleware {
    
    static var sharedCache: CacheProtocol!
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        request.authStatus = try AuthStatus.create(from: try AuthMiddleware.sharedCache.get(request.accessToken ?? "")?.string)
        return try next.respond(to: request)
    }
}

// TODO: - make configurable
//extension AuthMiddleware: ConfigInitializable {
//
//    convenience init(config: Config) throws {
//        let count = config["auth", "exclamationCount"]?.int ?? 3
//    }
//}

// TODO: - encapsulate usage
extension AuthMiddleware {
    
    static func login(_ user: User) throws -> String {
        guard let userID = user.id?.string else { throw Abort(.internalServerError) }
        let newToken = UUID().uuidString
        try sharedCache.set(newToken, userID, expiration: Date(timeIntervalSinceNow: 60 * 60 * 24 * 7))
        return newToken
    }
    
    static func logout(_ request: Request) throws {
        _  = try request.authStatus.authenticatedUser()
        guard let token = request.accessToken else { throw Abort(.unauthorized) }
        try sharedCache.delete(token)
    }
}

extension Request {
    
    var authStatus: AuthStatus {
        get { return storage["auth"] as? AuthStatus ?? .unknown }
        set { storage["auth"] = newValue }
    }
    
    var accessToken: String? {
        return headers["access_token"]
    }
}
