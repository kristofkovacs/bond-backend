import FluentProvider

final class ConversationController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Conversation.all().makeJSON()
    }
    
    func show(_ req: Request, conversation: Conversation) throws -> ResponseRepresentable {
        return conversation
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let conversation = try req.conversation()
        try conversation.save()
        return conversation.createdResponse
    }
    
    func delete(_ req: Request, conversation: Conversation) throws -> ResponseRepresentable {
        try conversation.delete()
        return Response(status: .ok)
    }
    
    func makeResource() -> Resource<Conversation> {
        return Resource(
            index: index,
            store: store,
            show: show,
            destroy: delete)
    }
    
}

extension ConversationController: EmptyInitializable { }

extension Request {
    func conversation() throws -> Conversation {
        guard let json = json else { throw Abort.badRequest }
        return try Conversation(json: json)
    }
}

extension ConversationController {
    func addMessage(_ req: Request) throws -> ResponseRepresentable {
        let conversation = try req.parameters.next(Conversation.self)
        guard let json = req.json else { throw Abort.badRequest }
        let message = try Message(json: json)
        try conversation.messages.save(message)
        // TODO: Should we return the conversation? or just the message?
        return try conversation.makeJSON()
    }
    
}

