//
//  GetImageUseCase.swift
//
//
//  Created by Admin on 08/12/2024.
//

import CoreRepositories
import UIKit

/// Get cached image, or else - load.
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

public final class MockGetImageUseCase: GetImageUseCaseProtocol {
    // Track calls:
    private(set) var executeCallCount = 0
    private(set) var requestedURLs = [URL]()

    // Control behavior:
    var imageToReturn: UIImage?
    var errorToThrow: Error?

    public init() {}

    public func execute(url: URL) async throws -> UIImage {
        executeCallCount += 1
        requestedURLs.append(url)

        // Simulate error if set, otherwise return image
        if let errorToThrow = errorToThrow {
            throw errorToThrow
        }
        guard let image = imageToReturn else {
            throw NSError(domain: "MockGetImageUseCase", code: -1, userInfo: nil)
        }
        return image
    }
}
