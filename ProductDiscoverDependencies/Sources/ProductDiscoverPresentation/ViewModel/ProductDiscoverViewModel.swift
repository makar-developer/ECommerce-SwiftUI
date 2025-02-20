//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import Foundation
import ProductDiscoverDomain
import CoreEntities
import CoreUseCases
import CoreStyleguide

@MainActor
public final class ProductDiscoverViewModel: ObservableObject {
    @Published var hotSalesState: ScreenState<[Product]> = .loading
    @Published var recommendedState: ScreenState<[Product]> = .loading
    
    private let getHotSalesUseCase: GetHotSalesUseCaseProtocol
    private let getRecommendedForYouUseCase: GetRecommendedForYouUseCaseProtocol
    let getImageUseCase: GetImageUseCaseProtocol  // For ProductCardView(s)
    
    let onNavigation: (Product) -> Void
    
    private var currentPage = 1
    private var isLastPage = false
    
    public init(
        getHotSalesUseCase: GetHotSalesUseCaseProtocol,
        getRecommendedForYouUseCase: GetRecommendedForYouUseCaseProtocol,
        getImageUseCase: GetImageUseCaseProtocol,
        onNavigation: @escaping (Product) -> Void
    ) {
        self.getHotSalesUseCase = getHotSalesUseCase
        self.getRecommendedForYouUseCase = getRecommendedForYouUseCase
        self.getImageUseCase = getImageUseCase
        self.onNavigation = onNavigation
        loadHotSalesProducts()
        loadRecommendedProducts()
    }
    
    func loadHotSalesProducts() {
        Task {
            do {
                let products = try await getHotSalesUseCase.execute()
                hotSalesState = .loaded(data: products)
            } catch {
                hotSalesState.toError(error: error)
            }
        }
    }
    
    func loadRecommendedProducts() {
        Task {
            // Prevent fetching if we already know there's no more
            guard !isLastPage else { return }
            
            // If we already have some recommended products, hold onto them so we can append
            let existingProducts: [Product] = {
                if case let .loaded(data) = recommendedState {
                    return data
                } else {
                    return []
                }
            }()
            
            currentPage += 1
            
            do {
                let products = try await getRecommendedForYouUseCase.execute(page: currentPage)
                if products.isEmpty {
                    isLastPage = true
                }
                // Combine new products with existing if any
                recommendedState = .loaded(data: existingProducts + products)
            } catch {
                recommendedState.toError(error: error)
            }
        }
    }
    
    func showProductDetails(product: Product) {
        onNavigation(product)
    }
}
