//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//

import CoreRepositories
import CoreDataSources
import CoreUseCases
public protocol CartDIContainerProtocol {
    // MARK: - Use Cases
    var addProductToCartUseCase: AddProductToCartUseCaseProtocol { get }
    var removeAllProductsFromCartUseCase: RemoveAllProductsFromCartUseCaseProtocol { get }
    var getAllProductsUseCase: GetAllProductsUseCaseProtocol { get }
    var removeProductFromCartUseCase: RemoveProductFromCartUseCaseProtocol { get }
    var removeEntireItemFromCartUseCase: RemoveEntireItemFromCartUseCaseProtocol { get }
    // MARK: - Repositories
    var cartRepository: CartRepositoryProtocol { get }
}

public final class CartDIContainerImpl: CartDIContainerProtocol {
    
    public var coreDataDataSource: CoreDataDataSourceProtocol
    
    public init(coreDataDataSource: CoreDataDataSourceProtocol) {
        self.coreDataDataSource = coreDataDataSource
    }
    
//    public lazy var coreDataDataSource: CoreDataDataSourceProtocol = {
//       return CoreDataDataSource(modelName: "Cart")
//    }()
    
    // MARK: - Repositories
    public lazy var cartRepository: CartRepositoryProtocol = {
        return CartRepositoryImpl(coreDataDataSource: coreDataDataSource)
    }()
    
    // MARK: - Use Cases
    public lazy var addProductToCartUseCase: AddProductToCartUseCaseProtocol = {
        return AddProductToCartUseCase(cartRepository: cartRepository)
    }()
    
    public lazy var removeAllProductsFromCartUseCase: RemoveAllProductsFromCartUseCaseProtocol = {
        return RemoveAllProductsFromCartUseCase(cartRepository: cartRepository)
    }()
    
    public lazy var getAllProductsUseCase: GetAllProductsUseCaseProtocol = {
        return GetAllProductsUseCase(cartRepository: cartRepository)
    }()
    
    public lazy var removeProductFromCartUseCase: RemoveProductFromCartUseCaseProtocol = {
        return RemoveProductFromCartUseCase(cartRepository: cartRepository)
    }()
    
    public lazy var removeEntireItemFromCartUseCase: RemoveEntireItemFromCartUseCaseProtocol = {
        return RemoveEntireItemFromCartUseCase(cartRepository: cartRepository)
    }()
}
