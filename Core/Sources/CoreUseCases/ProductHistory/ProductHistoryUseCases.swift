//
//  File.swift
//  
//
//  Created by Admin on 17/12/2024.
//

import Foundation
import CoreEntities
import CoreRepositories


public protocol GetProductHistoryUseCaseProtocol {
    func execute(for userId: UUID) async throws -> [ProductHistory]
}

public protocol AddProductToHistoryUseCaseProtocol {
    func execute(product: Product, for userId: UUID) async throws
}

public protocol RemoveProductFromHistoryUseCaseProtocol {
    func execute(productHistory: ProductHistory, for userId: UUID) async throws
}

public protocol RemoveAllHistoryUseCaseProtocol {
    func execute(for userId: UUID) async throws
}

public protocol RemoveHistoryOlderThanUseCaseProtocol {
    func execute(olderThan date: Date, for userId: UUID) async throws
}

// Implementations
public class GetProductHistoryUseCase: GetProductHistoryUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol
    
    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(for userId: UUID) async throws -> [ProductHistory] {
        try await repository.getAllHistory(for: userId)
    }
}

public class AddProductToHistoryUseCase: AddProductToHistoryUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol
    
    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(product: Product, for userId: UUID) async throws {
        try await repository.addProductToHistory(product, for: userId)
    }
}

public class RemoveProductFromHistoryUseCase: RemoveProductFromHistoryUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol
    
    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(productHistory: ProductHistory, for userId: UUID) async throws {
        try await repository.removeProductFromHistory(productHistory, for: userId)
    }
}

public class RemoveAllHistoryUseCase: RemoveAllHistoryUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol
    
    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(for userId: UUID) async throws {
        try await repository.removeAllHistory(for: userId)
    }
}

public class RemoveHistoryOlderThanUseCase: RemoveHistoryOlderThanUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol
    
    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(olderThan date: Date, for userId: UUID) async throws {
        try await repository.removeHistory(olderThan: date, for: userId)
    }
}
