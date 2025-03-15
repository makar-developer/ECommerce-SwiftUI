//
//  HistoryContainer.swift
//
//
//  Created by Admin on 17/12/2024.
//

import CoreDataSources
import CoreRepositories
import CoreUseCases
import Foundation

public protocol ProductHistoryDIContainerProtocol {
    // Use Cases
    func makeGetProductHistoryUseCase() -> GetProductHistoryUseCaseProtocol
    func makeRemoveProductFromHistoryUseCase() -> RemoveProductFromHistoryUseCaseProtocol
    func makeRemoveAllHistoryUseCase() -> RemoveAllHistoryUseCaseProtocol
    func makeRemoveHistoryOlderThanUseCase() -> RemoveHistoryOlderThanUseCaseProtocol
    func makeAddProductToHistoryUseCase() -> AddProductToHistoryUseCaseProtocol
}

public struct ProductHistoryDIContainerImpl: ProductHistoryDIContainerProtocol {
    private let coreDataDataSource: CoreDataDataSourceProtocol
    private let productHistoryRepository: ProductHistoryRepositoryProtocol

    public init(coreDataDataSource: CoreDataDataSourceProtocol) {
        self.coreDataDataSource = coreDataDataSource
        productHistoryRepository = ProductHistoryRepository(coreDataDataSource: coreDataDataSource)
    }

    // Use Cases
    public func makeGetProductHistoryUseCase() -> GetProductHistoryUseCaseProtocol {
        GetProductHistoryUseCase(repository: productHistoryRepository)
    }

    public func makeRemoveProductFromHistoryUseCase() -> RemoveProductFromHistoryUseCaseProtocol {
        RemoveProductFromHistoryUseCase(repository: productHistoryRepository)
    }

    public func makeRemoveAllHistoryUseCase() -> RemoveAllHistoryUseCaseProtocol {
        RemoveAllHistoryUseCase(repository: productHistoryRepository)
    }

    public func makeRemoveHistoryOlderThanUseCase() -> RemoveHistoryOlderThanUseCaseProtocol {
        RemoveHistoryOlderThanUseCase(repository: productHistoryRepository)
    }

    public func makeAddProductToHistoryUseCase() -> AddProductToHistoryUseCaseProtocol {
        AddProductToHistoryUseCase(repository: productHistoryRepository)
    }
}
