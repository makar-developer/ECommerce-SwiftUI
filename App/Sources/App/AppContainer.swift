//
//  File.swift
//  
//
//  Created by Admin on 16/11/2024.
//

import WelcomeFeature

public protocol AppDIContainerProtocol {
    //MARK: - Welcome
    var welcomeDIContainer: WelcomeDIContainerProtocol { get }
}

public class AppDIContainerImpl: AppDIContainerProtocol {
    public init() {}
    //MARK: - Welcome
    public lazy var welcomeDIContainer: WelcomeDIContainerProtocol = {
        return WelcomeDIContainerImpl()
    }()
}
