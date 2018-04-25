import FluentProvider
import MongoProvider

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupMiddleware()
        try setupProviders()
        try setupPreparations()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(MongoProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations.append(Activity.self)
        preparations.append(Conversation.self)
        preparations.append(Event.self)
        preparations.append(Message.self)
        preparations.append(Tag.self)
        preparations.append(User.self)
        preparations.append(Location.self)
        
        preparations.append(Pivot<Tag, Activity>.self)
        preparations.append(Pivot<Activity, Tag>.self)
        
        preparations.append(Pivot<Event, User>.self)
        preparations.append(Pivot<User, Event>.self)
        
        preparations.append(Pivot<User, Activity>.self)
        preparations.append(Pivot<Activity, User>.self)
    }
    
    private func setupMiddleware() throws {
        addConfigurable(middleware: AuthMiddleware(), name: "auth" )
    }
}
