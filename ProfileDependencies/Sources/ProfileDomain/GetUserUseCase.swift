//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//

//import Foundation
//import ProfileRepositoryProtocol
//import CoreEntities
//public protocol GetUserUseCaseProtocol {
//    func execute(with userId: UUID) async throws -> User
//}
//
//
//public class GetUserUseCase: GetUserUseCaseProtocol {
//    private let repository: ProfileRepositoryProtocol
//
//    public init(repository: ProfileRepositoryProtocol) {
//        self.repository = repository
//    }
//
//    public func execute(with userId: UUID) async throws -> User {
//        return try await repository.getUser(by: userId)
//    }
//}
