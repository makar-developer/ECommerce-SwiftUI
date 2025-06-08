//
//  CoreDataDataSourceImpl.swift
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
            try self.context.fetch(request)
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

/// A generic, in-memory mock for CoreDataDataSourceProtocol that correctly mimics the real implementation.
/// It uses a real NSPersistentContainer configured for in-memory storage, ensuring that relationships,
/// fetching, and saving behave as they would in production, but without side effects on disk.
public final class MockCoreDataDataSource: CoreDataDataSourceProtocol {
    public let context: NSManagedObjectContext
    private let persistentContainer: NSPersistentContainer

    public init(modelName: String) {
        // `Bundle.module` is a special SPM-generated accessor for the module's resource bundle.
        // This is the correct way to load a model from within the same Swift package.
        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Could not load Core Data model `\(modelName)` from the CoreDataSources module bundle.")
        }
        
        persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: model)

        // Configure the persistent store for in-memory storage.
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        // Load the persistent stores.
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory persistent store: \(error)")
            }
        }
        
        // Use a background context, just like the real implementation,
        // to catch potential threading issues during tests.
        context = persistentContainer.newBackgroundContext()
    }

    /// Fetches objects from the in-memory store using the context.
    public func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) async throws -> [T] {
        try await context.perform {
            try self.context.fetch(request)
        }
    }

    /// Saves any pending changes in the context to the in-memory store.
    public func save() async throws {
        if context.hasChanges {
            try await context.perform {
                try self.context.save()
            }
        }
    }

    /// Deletes an object from the context and saves the change.
    public func delete<T: NSManagedObject>(_ object: T) async throws {
        await context.perform {
            self.context.delete(object)
        }
        try await save()
    }
}
