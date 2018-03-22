import FluentProvider

final class TagController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Tag.all().makeJSON()
    }
    
    func makeResource() -> Resource<Tag> {
        return Resource(
            index: index
        )
    }
}

extension Request {
    func tag() throws -> Tag {
        guard let json = json else { throw Abort.badRequest }
        return try Tag(json: json)
    }
}

extension TagController: EmptyInitializable { }
