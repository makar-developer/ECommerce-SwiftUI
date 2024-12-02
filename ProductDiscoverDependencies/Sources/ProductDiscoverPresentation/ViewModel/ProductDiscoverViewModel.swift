//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import CoreEntities
import ProductDiscoverDomain
import Foundation

public final class ProductDiscoverViewModel: ObservableObject {
    // Published properties for the view to observe
    @Published var hotSalesProducts: [Product] = []
    @Published var recommendedProducts: [Product] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingNextPage: Bool = false
    @Published var errorMessage: String?
    
    private let getHotSalesUseCase: GetHotSalesUseCaseProtocol
    private let getRecommendedForYouUseCase: GetRecommendedForYouUseCaseProtocol
    
    private var currentPage = 0
    private var isLastPage = false
    
    public init(getHotSalesUseCase: GetHotSalesUseCaseProtocol,
                getRecommendedForYouUseCase: GetRecommendedForYouUseCaseProtocol) {
        self.getHotSalesUseCase = getHotSalesUseCase
        self.getRecommendedForYouUseCase = getRecommendedForYouUseCase
    }
    
    @MainActor
    func loadHotSalesProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let products = try await getHotSalesUseCase.execute()
            self.hotSalesProducts = products
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func loadRecommendedProducts() async {
        guard !isLastPage else { return }
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }
        currentPage += 1
        do {
            let products = try await getRecommendedForYouUseCase.execute(page: currentPage)
            if products.isEmpty {
                isLastPage = true
            } else {
                self.recommendedProducts.append(contentsOf: products)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func resetRecommendedProducts() {
        currentPage = 0
        isLastPage = false
        recommendedProducts.removeAll()
    }
}
