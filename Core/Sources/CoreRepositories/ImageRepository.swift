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

public class ImageRepository: ImageRepositoryProtocol {
    private let cache: DiskImageCacheWrapperProtocol
    private let session: URLSession
    private let maxRetries = 3

    public init(cache: DiskImageCacheWrapperProtocol, session: URLSession = .shared) {
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
