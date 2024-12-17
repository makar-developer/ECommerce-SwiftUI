//
//  File.swift
//  
//
//  Created by Admin on 17/12/2024.
//

import Foundation
import CoreUseCases
import CoreEntities

public final class ProductHistoryViewModel: ObservableObject {
    public enum NavigationTarget {
        case productDetails(Product)
        case profile
    }
    
    @Published var productHistories: [ProductHistory] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: AlertError?

    private let getProductHistoryUseCase: GetProductHistoryUseCaseProtocol
    private let removeProductFromHistoryUseCase: RemoveProductFromHistoryUseCaseProtocol
    private let removeAllHistoryUseCase: RemoveAllHistoryUseCaseProtocol
    let getImageUseCase: GetImageUseCaseProtocol
    private let userId: UUID
    private let onNavigation: (ProductHistoryViewModel.NavigationTarget) -> Void
    
    public init(
        userId: UUID,
        getProductHistoryUseCase: GetProductHistoryUseCaseProtocol,
        removeProductFromHistoryUseCase: RemoveProductFromHistoryUseCaseProtocol,
        removeAllHistoryUseCase: RemoveAllHistoryUseCaseProtocol,
        getImageUseCase: GetImageUseCaseProtocol,
        onNavigation: @escaping (ProductHistoryViewModel.NavigationTarget) -> Void
    ) {
        self.userId = userId
        self.getProductHistoryUseCase = getProductHistoryUseCase
        self.removeProductFromHistoryUseCase = removeProductFromHistoryUseCase
        self.removeAllHistoryUseCase = removeAllHistoryUseCase
        self.getImageUseCase = getImageUseCase
        self.onNavigation = onNavigation
    }
    
    func loadHistory() {
        isLoading = true
        Task {
            do {
                let histories = try await getProductHistoryUseCase.execute(for: userId)
                
                // Filter duplicates: Keep only the latest history for each product
                let filteredHistories = histories
                    .sorted { $0.timestamp > $1.timestamp } // Sort by latest timestamp first
                    .reduce(into: [Int: ProductHistory]()) { result, history in
                        if result[history.product.id] == nil {
                            result[history.product.id] = history
                        }
                    }
                    .map { $0.value } // Extract the filtered histories
                
                DispatchQueue.main.async {
                    self.productHistories = filteredHistories
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = AlertError(message: error.localizedDescription)
                    self.isLoading = false
                }
            }
        }
    }

    
    func removeProductHistory(_ history: ProductHistory) {
        Task {
            do {
                try await removeProductFromHistoryUseCase.execute(productHistory: history, for: userId)
                DispatchQueue.main.async {
                    self.productHistories.removeAll { $0.id == history.id }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = AlertError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func clearHistory() {
        Task {
            do {
                try await removeAllHistoryUseCase.execute(for: userId)
                DispatchQueue.main.async {
                    self.productHistories.removeAll()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = AlertError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func selectProduct(_ product: Product) {
        onNavigation(.productDetails(product))
    }
    
    func backToProfile() {
        onNavigation(.profile)
    }
}

struct AlertError: Identifiable {
    let id = UUID()
    let message: String
}
