@_exported import Vapor

extension Droplet {
    
    public func setup() throws {
        AuthMiddleware.sharedCache = cache
        
        try setupRoutes()
        // Do any additional droplet setup
    }
}
