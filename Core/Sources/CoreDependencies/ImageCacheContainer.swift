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
    // Use Case
    var getImageUseCase: GetImageUseCaseProtocol { get }
}

public struct ImageDIContainer: ImageDIContainerProtocol {
    
    private let diskImageCache: ImageCacheDataSourceProtocol
    private let imageRepository: ImageRepositoryProtocol
    
    public init() {
        self.diskImageCache = ImageCacheDataSourceImpl()
        self.imageRepository = ImageRepository(cache: diskImageCache)
    }

    // Use Case
    public var getImageUseCase: GetImageUseCaseProtocol {
        GetImageUseCase(repository: imageRepository)
    }
}
