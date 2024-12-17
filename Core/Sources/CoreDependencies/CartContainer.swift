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
    
    // MARK: - Repositories
    var cartRepository: CartRepositoryProtocol { get }
}

public class CartDIContainerImpl: CartDIContainerProtocol {
    
    public var coreDataWrapper: CoreDataWrapperProtocol
    
    public init(coreDataWrapper: CoreDataWrapperProtocol) {
        self.coreDataWrapper = coreDataWrapper
    }
    
//    public lazy var coreDataWrapper: CoreDataWrapperProtocol = {
//       return CoreDataWrapper(modelName: "Cart")
//    }()
    
    // MARK: - Repositories
    public lazy var cartRepository: CartRepositoryProtocol = {
        return CartRepositoryImpl(coreDataWrapper: coreDataWrapper)
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
}
