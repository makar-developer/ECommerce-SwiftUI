//
//  File.swift
//  
//
//  Created by Admin on 08/12/2024.
//

import CoreRepositories
import CoreDataSources
import CoreUseCases
public protocol ImageDIContainerProtocol {
    // MARK: - Use Cases
    var getImageUseCase: GetImageUseCaseProtocol { get }
    
    // MARK: - Repositories
    var imageRepository: ImageRepositoryProtocol { get }
    
    // MARK: - Cache
    var diskImageCache: ImageCacheDataSourceProtocol { get }
}

public final class ImageDIContainer: ImageDIContainerProtocol {

    public init() {}
    
    // MARK: - Cache
    public lazy var diskImageCache: ImageCacheDataSourceProtocol = {
        return ImageCacheDataSourceImpl()
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
