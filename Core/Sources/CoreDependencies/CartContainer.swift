//
//  CartContainer.swift
//
//
//  Created by Admin on 04/12/2024.
//

import CoreDataSources
import CoreRepositories
import CoreUseCases

public protocol CartDIContainerProtocol {
    // MARK: - Use Cases

    func makeAddProductToCartUseCase() -> AddProductToCartUseCaseProtocol
    func makeRemoveAllProductsFromCartUseCase() -> RemoveAllProductsFromCartUseCaseProtocol
    func makeGetAllProductsUseCase() -> GetAllProductsUseCaseProtocol
    func makeRemoveProductFromCartUseCase() -> RemoveProductFromCartUseCaseProtocol
    func makeRemoveEntireItemFromCartUseCase() -> RemoveEntireItemFromCartUseCaseProtocol
    var getImageUseCase: GetImageUseCaseProtocol { get }
}

public struct CartDIContainerImpl: CartDIContainerProtocol {
    public let getImageUseCase: GetImageUseCaseProtocol
    private let coreDataDataSource: CoreDataDataSourceProtocol

    public init(coreDataDataSource: CoreDataDataSourceProtocol, getImageCacheUseCase: GetImageUseCaseProtocol) {
        getImageUseCase = getImageCacheUseCase
        self.coreDataDataSource = coreDataDataSource

        cartRepository = CartRepositoryImpl(coreDataDataSource: coreDataDataSource)
    }

    // MARK: - Repositories

    private var cartRepository: any CoreRepositories.CartRepositoryProtocol

    // MARK: - Use Cases

    public func makeAddProductToCartUseCase() -> AddProductToCartUseCaseProtocol {
        return AddProductToCartUseCase(cartRepository: cartRepository)
    }

    public func makeRemoveAllProductsFromCartUseCase() -> RemoveAllProductsFromCartUseCaseProtocol {
        return RemoveAllProductsFromCartUseCase(cartRepository: cartRepository)
    }

    public func makeGetAllProductsUseCase() -> GetAllProductsUseCaseProtocol {
        return GetAllProductsUseCase(cartRepository: cartRepository)
    }

    public func makeRemoveProductFromCartUseCase() -> RemoveProductFromCartUseCaseProtocol {
        return RemoveProductFromCartUseCase(cartRepository: cartRepository)
    }

    public func makeRemoveEntireItemFromCartUseCase() -> RemoveEntireItemFromCartUseCaseProtocol {
        return RemoveEntireItemFromCartUseCase(cartRepository: cartRepository)
    }
}
