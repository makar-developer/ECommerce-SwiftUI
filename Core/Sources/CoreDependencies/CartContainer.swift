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
    
    var getImageUseCase: GetImageUseCaseProtocol { get }
    // MARK: - Repositories
    var cartRepository: CartRepositoryProtocol { get }
    // MARK: - DataSources
    var imageCacheDataSource: ImageCacheDataSourceProtocol { get }
}

public final class CartDIContainerImpl: CartDIContainerProtocol {
    
    public var getImageUseCase: GetImageUseCaseProtocol

    public var coreDataDataSource: CoreDataDataSourceProtocol
    public var imageCacheDataSource: ImageCacheDataSourceProtocol
    
    public init(coreDataDataSource: CoreDataDataSourceProtocol, imageCacheDataSource: ImageCacheDataSourceProtocol, getImageCacheUseCase: GetImageUseCaseProtocol) {
        self.getImageUseCase = getImageCacheUseCase
        self.coreDataDataSource = coreDataDataSource
        self.imageCacheDataSource = imageCacheDataSource
    }
    
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
