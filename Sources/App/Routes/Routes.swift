import Vapor

extension Droplet {
    
    func setupRoutes() throws {
        
        // MARK: - Activities
        try resource("activities", ActivityController.self)
        
        // MARK: - Tags
        try resource("tags", TagController.self)
        
        // MARK: - Locations
        try resource("locations", LocationController.self)
        
        // MARK- Users
        try resource("users", UserController.self)
        
        // MARK: - Session
        try resource("session", SessionController.self)
        
        // MARK: - Events
        let eventController = EventController()
        
        group("events", Event.parameter, "interested") { interested in
            interested.post(handler: eventController.addUserToInterested)
            interested.delete(handler: eventController.removeUserFromInterested)
        }
        
        group("events", Event.parameter, "going") { going in
            going.post(handler: eventController.addUserToGoing)
            going.delete(handler: eventController.removeUserFromGoing)
        }
        
        group("events", Event.parameter, "conversations") { conversation in
            conversation.post(handler: eventController.createConversation)
        }
        
        try resource("events", EventController.self)
        
        // MARK: - Profile
        let profileController = ProfileController()
        
        group("me") { me in
            
            me.get(handler: profileController.showUser)
            
            me.group("locations") { locations in
                locations.post(handler: profileController.addLocation)
                locations.delete(Location.parameter, handler: profileController.removeLocation)
            }
        
            me.group("activities") { activities in
                activities.post(handler: profileController.addActivity)
                activities.delete(Activity.parameter, handler: profileController.removeActivity)
            }
        }
        
        // MARK: - Conversations
        let conversationController = ConversationController()
        
        group("conversations", Conversation.parameter, "messages") { builder in
            builder.post(handler: conversationController.addMessage)
        }
        
        try resource("conversations", ConversationController.self)
    }
}
