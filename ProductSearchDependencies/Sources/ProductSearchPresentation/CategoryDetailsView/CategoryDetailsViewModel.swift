//
//  File.swift
//  
//
//  Created by Admin on 12/12/2024.
//

import Foundation
import CoreEntities
import ProductSearchDomain
import CoreUseCases
import ProductSearchEntities
public class CategoryDetailsViewModel: ObservableObject {
    
    public enum NavigationTarget {
        case productSearch
        case productDetails(Product)
    }
    
    let onNavigation: (CategoryDetailsViewModel.NavigationTarget) -> Void
    
    @Published var products: [Product] = []
    
    let categoryResponse: CategoryResponse
    private let user: User
    private let getAllProductsUseCase: GetAllProductsFromCategoryUseCaseProtocol
    let getImageUseCase: GetImageUseCaseProtocol
    
    public init(categoryResponse: CategoryResponse,
         user: User,
         getAllProductsUseCase: GetAllProductsFromCategoryUseCaseProtocol,
         getImageUseCase: GetImageUseCaseProtocol,
                onNavigation: @escaping (CategoryDetailsViewModel.NavigationTarget) -> Void) {
        self.categoryResponse = categoryResponse
        self.user = user
        self.getAllProductsUseCase = getAllProductsUseCase
        self.getImageUseCase = getImageUseCase
        self.onNavigation = onNavigation
    }
    
    func fetchProducts() {
        Task {
            do {
                let fetchedProducts = try await getAllProductsUseCase.execute(categorySlug: categoryResponse.slug)
                DispatchQueue.main.async {
                    self.products = fetchedProducts
                }
            } catch {
                print("Error fetching products: \(error)")
            }
        }
    }
    
    func showProductDetails(product: Product) {
        onNavigation(.productDetails(product))
    }
}
