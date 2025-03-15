//
//  CategoryDetailsViewModel.swift
//
//
//  Created by Admin on 12/12/2024.
//

import Foundation

import CoreEntities
import CoreStyleguide
import CoreUseCases

import ProductSearchDomain
import ProductSearchEntities

@MainActor
public final class CategoryDetailsViewModel: ObservableObject {
    public enum NavigationTarget {
        case productSearch
        case productDetails(Product)
    }

    let onNavigation: (CategoryDetailsViewModel.NavigationTarget) -> Void

    @Published var productsState: ScreenState<[Product]> = .loading

    let categoryResponse: CategoryResponse
    private let user: User
    private let getAllProductsUseCase: GetAllProductsFromCategoryUseCaseProtocol
    let getImageUseCase: GetImageUseCaseProtocol

    public init(
        categoryResponse: CategoryResponse,
        user: User,
        getAllProductsUseCase: GetAllProductsFromCategoryUseCaseProtocol,
        getImageUseCase: GetImageUseCaseProtocol,
        onNavigation: @escaping (CategoryDetailsViewModel.NavigationTarget) -> Void
    ) {
        self.categoryResponse = categoryResponse
        self.user = user
        self.getAllProductsUseCase = getAllProductsUseCase
        self.getImageUseCase = getImageUseCase
        self.onNavigation = onNavigation

        Task {
            await fetchProducts()
        }
    }

    func showProductDetails(product: Product) {
        onNavigation(.productDetails(product))
    }

    @MainActor
    func fetchProducts() async {
        productsState = .loading
        do {
            let fetchedProducts = try await getAllProductsUseCase.execute(categorySlug: categoryResponse.slug)
            productsState = .loaded(data: fetchedProducts)
        } catch {
            productsState.toError(error: error)
        }
    }
}
