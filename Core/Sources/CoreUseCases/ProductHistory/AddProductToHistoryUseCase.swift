//
//  File.swift
//  
//
//  Created by Admin on 18/12/2024.
//

import Foundation
import CoreEntities
import CoreRepositories

public protocol AddProductToHistoryUseCaseProtocol {
    func execute(product: Product, for userId: UUID) async throws
}
public final class AddProductToHistoryUseCase: AddProductToHistoryUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol
    
    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(product: Product, for userId: UUID) async throws {
        try await repository.addProductToHistory(product, for: userId)
    }
}

public final class MockAddProductToHistoryUseCase: AddProductToHistoryUseCaseProtocol {
    
    // Track calls
    private(set) var executeCallCount = 0
    
    // Track parameters
    private(set) var passedProduct: Product?
    private(set) var passedUserId: UUID?
    
    // Optional error
    public var errorToThrow: Error?
    
    public init() {} 
    
    public func execute(product: Product, for userId: UUID) async throws {
        executeCallCount += 1
        passedProduct = product
        passedUserId = userId
        
        if let error = errorToThrow {
            throw error
        }
    }
}

