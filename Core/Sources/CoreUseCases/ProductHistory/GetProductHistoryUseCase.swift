//
//  File.swift
//  
//
//  Created by Admin on 18/12/2024.
//
import CoreEntities
import CoreRepositories
import Foundation
public protocol GetProductHistoryUseCaseProtocol {
    func execute(for userId: UUID) async throws -> [ProductHistory]
}
public final class GetProductHistoryUseCase: GetProductHistoryUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol
    
    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(for userId: UUID) async throws -> [ProductHistory] {
        try await repository.getAllHistory(for: userId)
    }
}
