import Vapor

extension Droplet {
    
    func setupRoutes() throws {
        
        // MARK: - Activities
        try resource("activities", ActivityController.self)
        
        // MARK: Tags
        try resource("tags", TagController.self)
        
        // MARK: - Events
        let eventController = EventController()
        
        group("events", Event.parameter, "interested") { interested in
            interested.post(handler: eventController.addUserToInterested)
            interested.delete(User.parameter, handler: eventController.removeUserFromInterested)
        }
        
        group("events", Event.parameter, "going") { interested in
            interested.post(handler: eventController.addUserToGoing)
            interested.delete(User.parameter, handler: eventController.removeUserFromGoing)
        }
        
        group("events", Event.parameter, "conversations") { interested in
            interested.post(handler: eventController.createConversation)
        }
        
        try resource("events", EventController.self)
        
        // MARK: - Users
        let userController = UserController()
        
        group("users", User.parameter, "locations") { user in
            user.post(handler: userController.addLocation)
            user.delete(Location.parameter, handler: userController.removeLocation)
        }
        
        group("users", User.parameter, "activities") { user in
            user.post(handler: userController.addActivity)
            user.delete(Activity.parameter, handler: userController.removeActivity)
        }
        
        try resource("users", UserController.self)
        
        // MARK: - Conversations
        let conversationController = ConversationController()
        
        group("conversations", Conversation.parameter, "messages") { builder in
            builder.post(handler: conversationController.addMessage)
        }
        
        try resource("conversations", ConversationController.self)
        
        // MARK: - Locations
        try resource("locations", LocationController.self)
        
        // TODO: - others
    }
}
