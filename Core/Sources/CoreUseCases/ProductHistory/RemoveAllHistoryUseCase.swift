//
//  File.swift
//  
//
//  Created by Admin on 18/12/2024.
//

import Foundation
import CoreRepositories

public protocol RemoveAllHistoryUseCaseProtocol {
    func execute(for userId: UUID) async throws
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
