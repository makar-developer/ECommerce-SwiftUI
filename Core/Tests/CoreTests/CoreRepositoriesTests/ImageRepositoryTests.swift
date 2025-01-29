//
//  File.swift
//  
//
//  Created by Admin on 12/01/2025.
//


import XCTest
import UIKit
@testable import CoreDataSources
@testable import CoreRepositories
@testable import CoreTestHelpers

final class ImageRepositoryTests: XCTestCase {
    
    private var mockCache: MockDiskImageCacheDataSource!
    private var mockSession: URLSession!
    private var sut: ImageRepository!
    
    override func setUp() {
        super.setUp()
        mockCache = MockDiskImageCacheDataSource()
        mockSession = .shared
        
        sut = ImageRepository(cache: mockCache, session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        mockCache = nil
        super.tearDown()
    }
    
    func testGetImage_ReturnsCachedImage_IfAlreadyInCache() async throws {
        //given
        guard let testImage = UIImage.getOneOfThis() else {
            XCTFail("Failed to create test image from extension.")
            return
        }
        let url = URL.getOneOfThis()
        
        // Place testImage into the cache first
        mockCache.save(testImage, for: url)
        
        //when
        // The repository should return the cached image without calling the network
        let result = try await sut.getImage(url: url)
        
        //then
        XCTAssertEqual(result, testImage, "Expected the cached image to be returned immediately.")
        // Confirm that mockSession had no data set, so if it attempted a network fetch, it might fail
    }
}
