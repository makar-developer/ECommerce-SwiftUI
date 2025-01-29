//
//  File.swift
//  
//
//  Created by Admin on 08/12/2024.
//

import UIKit
import CoreDataSources
public protocol ImageRepositoryProtocol {
    func getImage(url: URL) async throws -> UIImage
}

public final class ImageRepository: ImageRepositoryProtocol {
    private let cache: DiskImageCacheDataSourceProtocol
    private let session: URLSession
    private let maxRetries = 3

    public init(cache: DiskImageCacheDataSourceProtocol, session: URLSession = .shared) {
        self.cache = cache
        self.session = session
    }

    public func getImage(url: URL) async throws -> UIImage {
        // Check cache first
        if let cachedImage = cache.image(for: url) {
            return cachedImage
        }

        // Fetch image with retries
        for attempt in 1...maxRetries {
            do {
                let (data, _) = try await session.data(from: url)
                if let image = UIImage(data: data) {
                    cache.save(image, for: url)
                    return image
                } else {
                    throw URLError(.cannotDecodeContentData)
                }
            } catch {
                if attempt == maxRetries {
                    throw error
                }
                // Wait before retrying
                try await Task.sleep(nanoseconds: 2_000_000_000)
            }
        }
        throw URLError(.unknown)
    }
}

public final class MockImageRepository: ImageRepositoryProtocol {
    
    public var imageToReturn: UIImage?
    public var errorToThrow: Error?
    
    public init() {}
    
    public func getImage(url: URL) async throws -> UIImage {
        if let error = errorToThrow {
            throw error
        }
        if let image = imageToReturn {
            return image
        }
        // If nothing is set, return an empty placeholder
        return UIImage()
    }
}
