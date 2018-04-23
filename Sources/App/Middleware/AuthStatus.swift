//
//  AuthStatus.swift
//  App
//
//  Created by Gujgiczer Máté on 2018. 04. 23..
//

import HTTP

enum AuthStatus {
    case unknown
    case unauthorized
    case expired
    case loggedIn(User)
}

extension AuthStatus {
    
    static func create(from userId: String?) throws -> AuthStatus {
        guard let userId = userId else { return .unauthorized }
        guard let user = try User.find(userId) else { return .expired }
        return .loggedIn(user)
    }
}

extension AuthStatus: Equatable {
    
    static func == (lhs: AuthStatus, rhs: AuthStatus) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown), (.unauthorized, .unauthorized), (.expired, .expired):
            return true
        case let (.loggedIn(user1), .loggedIn(user2)) where user1 == user2:
            return true
        default:
            return false
        }
    }
}

extension AuthStatus {
    
    func authenticatedUser() throws -> User {
        switch self {
        case let .loggedIn(user):
            return user
        default:
            throw Abort(.unauthorized)
        }
    }
}
