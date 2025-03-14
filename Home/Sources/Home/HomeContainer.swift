//
//  File.swift
//  
//
//  Created by Admin on 29/11/2024.
//

import SwiftUI
import ProductDiscoverFeature
import CoreDependencies
import ProductSearchFeature
import ProfileFeature
import CoreDataSources
// MARK: - HomeDIContainerProtocol
public protocol HomeDIContainerProtocol {
    func makeProductDiscoverDIContainer() -> ProductDiscoverDIContainerProtocol
    func makeCartDIContainer() -> CartDIContainerProtocol
    func makeProductSearchDIContainer() -> ProductSearchDIContainerProtocol
    func makeProfileDIContainer() -> ProfileDIContainerProtocol
    func makeProductHistoryDIContainer() -> ProductHistoryDIContainerProtocol
    
    var imageCacheContainer: ImageDIContainerProtocol { get }
}

// MARK: - Dependency Injection Container Implementation
public struct HomeDIContainerImpl: HomeDIContainerProtocol {
    public var imageCacheContainer: any CoreDependencies.ImageDIContainerProtocol
    
    public let coreDataDataSource: CoreDataDataSourceProtocol
    
    public init(coreDataDataSource: CoreDataDataSourceProtocol) {
        self.coreDataDataSource = coreDataDataSource
        self.imageCacheContainer = ImageDIContainer()
    }
    
    public func makeProductHistoryDIContainer() -> ProductHistoryDIContainerProtocol {
        return ProductHistoryDIContainerImpl(coreDataDataSource: coreDataDataSource)
    }
    
    public func makeProductDiscoverDIContainer() -> ProductDiscoverDIContainerProtocol {
        return ProductDiscoverDIContainerImpl()
    }
    
    public func makeCartDIContainer() -> CartDIContainerProtocol {
        return CartDIContainerImpl(
            coreDataDataSource: coreDataDataSource,
            getImageCacheUseCase: imageCacheContainer.getImageUseCase
        )
    }
    
    public func makeProductSearchDIContainer() -> ProductSearchDIContainerProtocol {
        return ProductSearchDIContainerImpl(
            getImageUseCase: imageCacheContainer.getImageUseCase
        )
    }
    
    public func makeProfileDIContainer() -> ProfileDIContainerProtocol {
        return ProfileDIContainerImpl()
    }
}
