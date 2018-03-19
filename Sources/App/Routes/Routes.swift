import Vapor

extension Droplet {
    func setupRoutes() throws {
        try resource("activity", ActivityController.self)
        try resource("tags", TagController.self)
        
//        let activityController = ActivityController()
//        activityController.addRoutes(to: self)
//        let tagController = TagController()
//        tagController.addRoutes(to: self)
    }
}
