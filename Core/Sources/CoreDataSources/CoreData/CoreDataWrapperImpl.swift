//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//


import CoreData
import Foundation

public protocol CoreDataWrapperProtocol {
    func fetch<T: NSManagedObject>(entityName: String, predicate: NSPredicate?) async throws -> [T]
    func save<T: NSManagedObject>(_ object: T) async throws
    func delete<T: NSManagedObject>(_ object: T) async throws
    var context: NSManagedObjectContext { get }
}

public final class CoreDataWrapperImpl: CoreDataWrapperProtocol {
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
    }
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func fetch<T>(entityName: String, predicate: NSPredicate? = nil) async throws -> [T] where T : NSManagedObject {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        return try context.fetch(request)
    }
    
    public func save<T>(_ object: T) async throws where T : NSManagedObject {
        if context.hasChanges {
            try context.save()
        }
    }
    
    public func delete<T>(_ object: T) async throws where T : NSManagedObject {
        context.delete(object)
        if context.hasChanges {
            try context.save()
        }
    }
}

/// A generic, in-memory mock for CoreDataWrapperProtocol.
/// It does not persist anything to disk; everything is stored only in memory.
public final class MockCoreDataWrapper: CoreDataWrapperProtocol {
    
    // We store objects keyed by entity name:
    private var inMemoryStore: [String: [NSManagedObject]] = [:]
    
    /// Use a real NSPersistentContainer in memory (storeType = NSInMemoryStoreType).
    /// This lets us provide a functional NSManagedObjectContext.
    private let persistentContainer: NSPersistentContainer
    
    public init(modelName: String) {
        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Could not load model for MockCoreDataWrapper.")
        }
        persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: model)
        
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType  // keep it all in memory
        
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
    
    /// Fetch objects in memory. Filter with predicate if needed.
    public func fetch<T>(entityName: String, predicate: NSPredicate? = nil) async throws -> [T] where T: NSManagedObject {
        
        // 1) Get all objects for this entity name
        let allObjects = inMemoryStore[entityName] ?? []
        
        // 2) Narrow to those matching T's type
        let typedObjects = allObjects.compactMap { $0 as? T }
        
        // 3) If there is a predicate, evaluate it
        guard let predicate = predicate else {
            return typedObjects
        }
        
        let filtered = typedObjects.filter { predicate.evaluate(with: $0) }
        return filtered
    }
    
    /// Save object: we just keep it in memory dictionary
    public func save<T>(_ object: T) async throws where T: NSManagedObject {
        let entityName = object.entity.name ?? "UnknownEntity"
        // If we don’t have an array for this entityName, start one
        if inMemoryStore[entityName] == nil {
            inMemoryStore[entityName] = []
        }
        
        // If the object is already in the store, remove it (simulate an update)
        inMemoryStore[entityName]?.removeAll(where: { $0 == object })
        
        // Then add
        inMemoryStore[entityName]?.append(object)
    }
    
    /// Delete object: remove from our in-memory dictionary
    public func delete<T>(_ object: T) async throws where T: NSManagedObject {
        let entityName = object.entity.name ?? "UnknownEntity"
        guard var existingArray = inMemoryStore[entityName] else { return }
        
        existingArray.removeAll(where: { $0 == object })
        inMemoryStore[entityName] = existingArray
        print("[MockCoreDataWrapper.delete] Removed object from \(entityName). Now the store has \(existingArray.count) objects.")

    }
}
