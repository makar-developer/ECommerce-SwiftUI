//
//  File.swift
//  
//
//  Created by Admin on 08/12/2024.
//

import CoreRepositories
import UIKit
public protocol GetImageUseCaseProtocol {
    func execute(url: URL) async throws -> UIImage
}

public final class GetImageUseCase: GetImageUseCaseProtocol {
    private let repository: ImageRepositoryProtocol

    public init(repository: ImageRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(url: URL) async throws -> UIImage {
        return try await repository.getImage(url: url)
    }
}
