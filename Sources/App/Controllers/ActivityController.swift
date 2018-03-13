import Vapor

final class ActivityController {
    
    func index(_ req: Request) throws -> Future<[Activity]> {
        return req.withPooledConnection(to: .sqlite) { db -> Future<[Activity]> in
            return Activity.query(on: req).all()
        }
    }
    
    func get(_ req: Request) throws -> Future<Activity> {
        return req.withPooledConnection(to: .sqlite) { db in
            return try req.parameter(Activity.self).flatMap(to: Activity.self) { activity in
                return activity.query(on: req).first().map(to: Activity.self) { activity in
                    guard let activity = activity else {
                        throw Abort(.notFound, reason: "No such activity")
                    }
                    return activity
                }
            }
        }
    }
    
    func getActivity(_ req: Request) throws -> Future<Activity> {
        return try req.parameter(Activity.self)
    }
    
    func create(_ req: Request, activity: Activity) throws -> Future<Activity> {
//        return req.withPooledConnection(to: .sqlite) { db -> Future<Activity> in
            return activity.save(on: req)
//        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        
        return try req.parameter(Activity.self).flatMap(to: Activity.self) { activity in
            return activity.delete(on: req)
        }.transform(to: .ok)
    }
    
}
