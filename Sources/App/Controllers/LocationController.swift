import FluentProvider

final class LocationController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Location.all().makeJSON()
    }
    
    func show(_ req: Request, location: Location) throws -> ResponseRepresentable {
        return location
    }
    
    func makeResource() -> Resource<Location> {
        return Resource(
            index: index,
            show: show
        )
    }
}

extension LocationController: EmptyInitializable { }
