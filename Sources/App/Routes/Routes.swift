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
            interested.delete(String.parameter, handler: eventController.removeUserFromInterested)
        }
        
        group("events", Event.parameter, "going") { interested in
            interested.post(handler: eventController.addUserToGoing)
            interested.delete(String.parameter, handler: eventController.removeUserFromGoing)
        }
        
        group("events", Event.parameter, "conversations") { interested in
            interested.post(handler: eventController.createConveration)
        }
        
        try resource("events", EventController.self)
        
        // TODO: - others
    }
}
