//
//  File.swift
//  
//
//  Created by Admin on 16/11/2024.
//

import WelcomeFeature
import Home
public protocol AppDIContainerProtocol {
    var welcomeDIContainer: WelcomeDIContainerProtocol { get }
    var homeDIContainer: HomeDIContainerProtocol { get }
}

public class AppDIContainerImpl: AppDIContainerProtocol {
    public init() {}
    //MARK: - Welcome
    public lazy var welcomeDIContainer: WelcomeDIContainerProtocol = {
        return WelcomeDIContainerImpl()
    }()
    //MARK: - Home
    public lazy var homeDIContainer: HomeDIContainerProtocol = {
        return HomeDIContainerImpl()
    }()
}
