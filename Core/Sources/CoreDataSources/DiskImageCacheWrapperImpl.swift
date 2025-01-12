//
//  File.swift
//  
//
//  Created by Admin on 07/12/2024.
//

import UIKit
public protocol DiskImageCacheWrapperProtocol {
    func image(for url: URL) -> UIImage?
    func save(_ image: UIImage, for url: URL)
}

public final class DiskImageCacheWrapperImpl: DiskImageCacheWrapperProtocol {
    private let cacheDirectory: URL

    public init() {
        cacheDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("ImageCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }

    public func image(for url: URL) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(cacheKey(for: url))
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }

    public func save(_ image: UIImage, for url: URL) {
        let fileURL = cacheDirectory.appendingPathComponent(cacheKey(for: url))
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }

    private func cacheKey(for url: URL) -> String {
        // Use a hash for the cache key to handle complex URLs
        return String(url.absoluteString.hashValue)
    }
}


final class MockDiskImageCacheWrapper: DiskImageCacheWrapperProtocol {
    private var storedImages: [URL: UIImage] = [:]
    
    init() {}
    
    func image(for url: URL) -> UIImage? {
        storedImages[url]
    }
    
    func save(_ image: UIImage, for url: URL) {
        storedImages[url] = image
    }
}

