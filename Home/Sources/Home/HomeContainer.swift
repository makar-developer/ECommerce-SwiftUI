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
//import ProductCartFeature
import ProfileFeature
// MARK: - HomeDIContainerProtocol
public protocol HomeDIContainerProtocol {
    var productDiscoverDIContainer: ProductDiscoverDIContainerProtocol { get }
    var cartDIContainer: CartDIContainerProtocol { get }
    var imageCacheContainer: ImageDIContainerProtocol { get }
    var productSearchDIContainer: ProductSearchDIContainerProtocol { get }
//    var productCartDIContainer: ProductCartDIContainerProtocol { get }
    var profileDIContainer: ProfileDIContainerProtocol { get }
}

// MARK: - Dependency Injection Container Implementation
public class HomeDIContainerImpl: HomeDIContainerProtocol {
    public init() {}

    public lazy var productDiscoverDIContainer: ProductDiscoverDIContainerProtocol = {
        return ProductDiscoverDIContainerImpl()
    }()
    
    public lazy var cartDIContainer: CartDIContainerProtocol = {
        return CartDIContainerImpl()
    }()
    
    public lazy var imageCacheContainer: ImageDIContainerProtocol = {
       return ImageDIContainer()
    }()

    public lazy var productSearchDIContainer: ProductSearchDIContainerProtocol = {
        return ProductSearchDIContainerImpl()
    }()
    
    public lazy var profileDIContainer: ProfileDIContainerProtocol = {
        return ProfileDIContainerImpl()
    }()
}

