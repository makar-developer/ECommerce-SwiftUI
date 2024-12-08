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
    func update<T: NSManagedObject>(_ object: T) async throws
    func delete<T: NSManagedObject>(_ object: T) async throws
    var context: NSManagedObjectContext { get }
}

public class CoreDataWrapper: CoreDataWrapperProtocol {
    private let persistentContainer: NSPersistentContainer
    
    public init(modelName: String) {
        
        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Failed to find Core Data model in package.")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model from package.")
        }
        persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: model)
//        persistentContainer = NSPersistentContainer(name: modelName)
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
    
    public func update<T>(_ object: T) async throws where T : NSManagedObject {
        // In Core Data, updating is handled by modifying the managed object and saving the context
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
