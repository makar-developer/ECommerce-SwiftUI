//
//  File.swift
//  
//
//  Created by Admin on 15/12/2024.
//

import CoreRepositories
import CoreEntities
import Foundation
public protocol SignInUseCaseProtocol {
    func execute(user: User) async throws
}

public final class SignInUseCase: SignInUseCaseProtocol {
    private let repository: AuthenticationRepositoryProtocol

    public init(repository: AuthenticationRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(user: User) async throws {
        try await repository.signIn(user: user)
    }
}

public final class MockSignInUseCase: SignInUseCaseProtocol {
    public var shouldThrowError = false
    public var signedInUserIDs: [UUID] = []

    public init() {}
    
    public func execute(user: User) async throws {
        if shouldThrowError {
            throw NSError(domain: "SignInError", code: 1, userInfo: nil)
        }
        signedInUserIDs.append(user.id)
    }
}
