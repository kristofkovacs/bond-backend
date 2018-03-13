import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    
    // Example of creating a Service and using it.
    router.get("hash", String.parameter) { req -> String in
        // Create a BCryptHasher using the Request's Container
        let hasher = try req.make(BCryptHasher.self)

        // Fetch the String parameter (as described in the route)
        let string = try req.parameter(String.self)

        // Return the hashed string!
        return try hasher.make(string)
    }
    
    let activityController = ActivityController()
    router.get("activity", use: activityController.index)
    router.get("activity", Activity.parameter, use: activityController.getActivity)
    router.post(Activity.self, at: "activity", use: activityController.create)
    router.delete("activity", use: activityController.delete)
    
    // Example of configuring a controller
    
}
