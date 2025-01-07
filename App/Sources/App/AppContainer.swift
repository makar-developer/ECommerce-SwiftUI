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
        return HomeDIContainerImpl(coreDataWrapper: coreDataWrapper)
    }()
    
    public lazy var userDataDIContainer: UserDataDIContainerProtocol = {
        return UserDataDIContainerImpl(coreDataWrapper: coreDataWrapper)
    }()
    
    public lazy var coreDataWrapper: CoreDataWrapperProtocol = {
        return CoreDataWrapperImpl(modelName: "UserData")
    }()
}
