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
public class AddProductToHistoryUseCase: AddProductToHistoryUseCaseProtocol {
    private let repository: ProductHistoryRepositoryProtocol
    
    public init(repository: ProductHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(product: Product, for userId: UUID) async throws {
        try await repository.addProductToHistory(product, for: userId)
    }
}


