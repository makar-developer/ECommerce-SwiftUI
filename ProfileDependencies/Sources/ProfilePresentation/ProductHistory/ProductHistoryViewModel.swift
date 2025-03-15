//
//  ProductHistoryViewModel.swift
//
//
//  Created by Admin on 17/12/2024.
//

import Foundation

import CoreEntities
import CoreUseCases

@MainActor
public final class ProductHistoryViewModel: ObservableObject {
    public enum NavigationTarget {
        case productDetails(Product)
        case profile
    }

    @Published private(set) var productHistories: [ProductHistory] = []
    @Published private(set) var isLoading: Bool = false
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

    func loadHistory() async {
        isLoading = true
        do {
            let histories = try await getProductHistoryUseCase.execute(for: userId)

            // Sort histories by timestamp in descending order (newest first)
            let sortedHistories = histories.sorted { $0.timestamp > $1.timestamp }

            // Use a Set to keep track of seen product IDs
            var seenProductIDs = Set<Int>()
            var uniqueHistories: [ProductHistory] = []

            for history in sortedHistories {
                if !seenProductIDs.contains(history.product.id) {
                    uniqueHistories.append(history)
                    seenProductIDs.insert(history.product.id)
                }
            }

            productHistories = uniqueHistories
            isLoading = false
        } catch {
            errorMessage = AlertError(message: error.localizedDescription)
            isLoading = false
        }
    }

    func removeProductHistory(_ history: ProductHistory) {
        Task {
            do {
                try await removeProductFromHistoryUseCase.execute(product: history.product, for: userId)
                self.productHistories.removeAll { $0.id == history.id }
            } catch {
                self.errorMessage = AlertError(message: error.localizedDescription)
            }
        }
    }

    func clearHistory() {
        Task {
            do {
                try await removeAllHistoryUseCase.execute(for: userId)
                self.productHistories.removeAll()
            } catch {
                self.errorMessage = AlertError(message: error.localizedDescription)
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
