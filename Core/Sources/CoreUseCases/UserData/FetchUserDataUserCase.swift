//
//  File.swift
//  
//
//  Created by Admin on 18/12/2024.
//

import Foundation
import CoreRepositories
import Foundation
public protocol FetchUserDataUseCaseProtocol {
    func execute(userId: UUID) async throws -> UUID?
}

public final class FetchUserDataUseCase: FetchUserDataUseCaseProtocol {
    private let userDataRepository: UserDataRepositoryProtocol

    public init(userDataRepository: UserDataRepositoryProtocol) {
        self.userDataRepository = userDataRepository
    }

    public func execute(userId: UUID) async throws -> UUID? {
        try await userDataRepository.fetchUserData(byId: userId)
    }
}

public final class MockFetchUserDataUseCase: FetchUserDataUseCaseProtocol {
    public var shouldThrowError = false

    public var userDataMap: [UUID: UUID?] = [:]

    public init() {}
    
    public func execute(userId: UUID) async throws -> UUID? {
        if shouldThrowError {
            throw NSError(domain: "FetchUserDataError", code: 1, userInfo: nil)
        }
        return userDataMap[userId] ?? nil
    }
}
