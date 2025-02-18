//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//


import CoreData
import Foundation

public protocol CoreDataDataSourceProtocol {
    var context: NSManagedObjectContext { get }
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) async throws -> [T]
    func save() async throws
    func delete<T: NSManagedObject>(_ object: T) async throws
}

public final class CoreDataDataSourceImpl: CoreDataDataSourceProtocol {
    
    public let context: NSManagedObjectContext
    private let persistentContainer: NSPersistentContainer
    
    public init(modelName: String) {
        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Failed to find Core Data model in package.")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model from package.")
        }
        
        persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: model)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData load error: \(error)")
            }
        }
        
        context = persistentContainer.newBackgroundContext()
    }
    
    public func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) async throws -> [T] {
        try await context.perform {
            return try self.context.fetch(request)
        }
    }
    
    public func save() async throws {
        if context.hasChanges {
            try await context.perform {
                try self.context.save()
            }
        }
    }
    
    public func delete<T: NSManagedObject>(_ object: T) async throws {
        await context.perform {
            self.context.delete(object)
        }
        try await save()
    }
}

/// A generic, in-memory mock for CoreDataDataSourceProtocol.
public final class MockCoreDataDataSource: CoreDataDataSourceProtocol {

    // We store objects keyed by entity name:
    private var inMemoryStore: [String: [NSManagedObject]] = [:]
    private let persistentContainer: NSPersistentContainer

    public init(modelName: String) {
        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Could not load model for MockCoreDataDataSource.")
        }
        persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: model)
        
        // Use in-memory store
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
    }
    
    /// Return the in-memory NSManagedObjectContext
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Fetch objects from the in-memory store using the NSFetchRequest.
    public func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) async throws -> [T] {
        await context.perform {
            let entityName = request.entityName ?? String(describing: T.self)
            // Get stored objects by entity name.
            let allObjects = self.inMemoryStore[entityName] ?? []
            let typedObjects = allObjects.compactMap { $0 as? T }
            
            // If a predicate is provided, filter based on it.
            if let predicate = request.predicate {
                return typedObjects.filter { predicate.evaluate(with: $0) }
            }
            return typedObjects
        }
    }
    
    /// Emulate saving changes. For the mock, this is a no-op.
    public func save() async throws {
        await context.perform {
            // No operation needed: our in-memory store is updated immediately.
        }
    }
    
    /// Delete object: remove from our in-memory dictionary.
    public func delete<T: NSManagedObject>(_ object: T) async throws {
        await context.perform {
            let entityName = object.entity.name ?? "UnknownEntity"
            var objects = self.inMemoryStore[entityName] ?? []
            objects.removeAll(where: { $0 == object })
            self.inMemoryStore[entityName] = objects
            print("[MockCoreDataDataSource.delete] Removed object from \(entityName). Now the store has \(objects.count) objects.")
        }
        try await save()
    }
    
    // Optional helper: Insert object into the in-memory store.
    public func insert<T: NSManagedObject>(_ object: T) async throws {
        await context.perform {
            let entityName = object.entity.name ?? "UnknownEntity"
            if self.inMemoryStore[entityName] == nil {
                self.inMemoryStore[entityName] = []
            }
            // Simulate an update: remove if already exists.
            self.inMemoryStore[entityName]?.removeAll(where: { $0 == object })
            self.inMemoryStore[entityName]?.append(object)
        }
    }
}
