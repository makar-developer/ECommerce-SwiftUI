//
//  File.swift
//  
//
//  Created by Admin on 16/11/2024.
//

import WelcomeFeature
import Home
import CoreDataSources
import CoreDependencies

/// App-level DI container - provides Feature-level DI containers. Feature-level DI Containers provide necessary Layer dependencies (e.g. UseCases, Repositories) within boundaries of some specific Feature.
public protocol AppDIContainerProtocol {
    func makeWelcomeDIContainer() -> WelcomeDIContainerProtocol
    func makeHomeDIContainer() -> HomeDIContainerProtocol
    func makeUserDataDIContainer() -> UserDataDIContainerProtocol
}

public struct AppDIContainerImpl: AppDIContainerProtocol {
    public init() {}

    public func makeWelcomeDIContainer() -> WelcomeDIContainerProtocol {
        return WelcomeDIContainerImpl()
    }
    
    public func makeHomeDIContainer() -> HomeDIContainerProtocol {
        return HomeDIContainerImpl(coreDataDataSource: coreDataDataSource)
    }
    
    public func makeUserDataDIContainer() -> UserDataDIContainerProtocol {
        return UserDataDIContainerImpl(coreDataDataSource: coreDataDataSource)
    }
    
    public var coreDataDataSource: CoreDataDataSourceProtocol {
        return CoreDataDataSourceImpl(modelName: "UserData")
    }
}
