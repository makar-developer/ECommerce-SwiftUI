//
//  File.swift
//  
//
//  Created by Admin on 17/12/2024.
//

import Foundation
import CoreUseCases
import CoreRepositories
import CoreDataSources
public protocol ProductHistoryDIContainerProtocol {
    // Use Cases
    var getProductHistoryUseCase: GetProductHistoryUseCaseProtocol { get }
    var removeProductFromHistoryUseCase: RemoveProductFromHistoryUseCaseProtocol { get }
    var removeAllHistoryUseCase: RemoveAllHistoryUseCaseProtocol { get }
    var removeHistoryOlderThanUseCase: RemoveHistoryOlderThanUseCaseProtocol { get }
    var addProductToHistoryUseCase: AddProductToHistoryUseCaseProtocol { get }
    // Repositories
    var productHistoryRepository: ProductHistoryRepositoryProtocol { get }
}

public class ProductHistoryDIContainerImpl: ProductHistoryDIContainerProtocol {
  

    // Repositories
    public lazy var productHistoryRepository: ProductHistoryRepositoryProtocol = {
        ProductHistoryRepository(coreDataWrapper: coreDataWrapper)
    }()
    
    // Use Cases
    
    public lazy var getProductHistoryUseCase: GetProductHistoryUseCaseProtocol = {
        GetProductHistoryUseCase(repository: productHistoryRepository)
    }()
    
    public lazy var removeProductFromHistoryUseCase: RemoveProductFromHistoryUseCaseProtocol = {
        RemoveProductFromHistoryUseCase(repository: productHistoryRepository)
    }()
    
    public lazy var removeAllHistoryUseCase: RemoveAllHistoryUseCaseProtocol = {
        RemoveAllHistoryUseCase(repository: productHistoryRepository)
    }()
    
    public lazy var removeHistoryOlderThanUseCase: RemoveHistoryOlderThanUseCaseProtocol = {
        RemoveHistoryOlderThanUseCase(repository: productHistoryRepository)
    }()
    
    public lazy var addProductToHistoryUseCase: AddProductToHistoryUseCaseProtocol = {
        AddProductToHistoryUseCase(repository: productHistoryRepository)
    }()
    // Core Data Wrapper
    public lazy var coreDataWrapper: CoreDataWrapperProtocol = {
       return CoreDataWrapper(modelName: "Cart")
    }()
    
    // Initialization
    public init() {}
}
