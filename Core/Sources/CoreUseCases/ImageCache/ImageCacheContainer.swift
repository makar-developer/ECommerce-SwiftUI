//
//  File.swift
//  
//
//  Created by Admin on 08/12/2024.
//

import CoreRepositories

public protocol ImageDIContainerProtocol {
    // MARK: - Use Cases
    var getImageUseCase: GetImageUseCaseProtocol { get }
    
    // MARK: - Repositories
    var imageRepository: ImageRepositoryProtocol { get }
    
    // MARK: - Cache
    var diskImageCache: DiskImageCacheProtocol { get }
}

public final class ImageDIContainer: ImageDIContainerProtocol {

    public init() {}
    
    // MARK: - Cache
    public lazy var diskImageCache: DiskImageCacheProtocol = {
        return DiskImageCache()
    }()
    
    // MARK: - Repositories
    public lazy var imageRepository: ImageRepositoryProtocol = {
        return ImageRepository(cache: diskImageCache)
    }()
    
    // MARK: - Use Cases
    public lazy var getImageUseCase: GetImageUseCaseProtocol = {
        return GetImageUseCase(repository: imageRepository)
    }()
}
