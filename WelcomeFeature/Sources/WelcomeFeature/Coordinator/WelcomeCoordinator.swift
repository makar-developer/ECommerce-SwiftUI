//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import SwiftUI
import WelcomePresentation
import WelcomeDomain
import WelcomeData
final class WelcomeCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: WelcomeDIContainerProtocol
    
    init(container: WelcomeDIContainerProtocol) {
        self.container = container
    }
    
    private func push(screen: WelcomeScreen) {
        path.append(screen)
    }
    
    private func pop() {
        path.removeLast()
    }
    
    @ViewBuilder
    func build(screen: WelcomeScreen) -> some View {
        switch screen {
        case .welcome:
            WelcomeView(viewModel: WelcomeViewModel(getAllUsersUseCase: GetAllUsersUseCase(welcomeRepository: WelcomeRepositoryImpl()), logoutUserUseCase: LogoutUserUseCase(welcomeRepository: WelcomeRepositoryImpl())))
        }
    }
}
