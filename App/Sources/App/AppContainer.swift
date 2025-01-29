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
    var welcomeDIContainer: WelcomeDIContainerProtocol { get }
    var homeDIContainer: HomeDIContainerProtocol { get }
    var userDataDIContainer: UserDataDIContainerProtocol { get }
}

public final class AppDIContainerImpl: AppDIContainerProtocol {
    public init() {}
    //MARK: - Welcome
    public lazy var welcomeDIContainer: WelcomeDIContainerProtocol = {
        return WelcomeDIContainerImpl()
    }()
    //MARK: - Home
    public lazy var homeDIContainer: HomeDIContainerProtocol = {
        return HomeDIContainerImpl(coreDataDataSource: coreDataDataSource)
    }()
    
    public lazy var userDataDIContainer: UserDataDIContainerProtocol = {
        return UserDataDIContainerImpl(coreDataDataSource: coreDataDataSource)
    }()
    
    public lazy var coreDataDataSource: CoreDataDataSourceProtocol = {
        return CoreDataDataSourceImpl(modelName: "UserData")
    }()
}
