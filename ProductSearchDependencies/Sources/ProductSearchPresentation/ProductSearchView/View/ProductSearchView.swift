//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import SwiftUI
import Combine
import CoreEntities
import CoreUseCases
import ProductSearchEntities
import Core
import CoreStyleguide


// MARK: - ProductSearchView

public struct ProductSearchView: View {
    @StateObject private var viewModel: ProductSearchViewModel
    @Environment(\.screenWidth) private var screenWidth
    @FocusState private var isKeyboardFocused: Bool

    public init(viewModel: ProductSearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBarView(
                    text: $viewModel.searchText,
                    isFocused: $viewModel.isSearchFocused,
                    onCommit: {
                        viewModel.saveCurrentSearch()
                    }
                )
                .padding(.top, 8)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.backgroundSecondary.opacity(0.8), Color.backgroundSecondary]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)

                // Recent Searches
                if viewModel.isSearchFocused && viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    RecentSearchesView(
                        recentQueries: viewModel.recentSearchQueries,
                        onSelect: { query in
                            viewModel.performSearch(from: query)
                        },
                        onDelete: { query in
                            viewModel.deleteSearchQuery(query)
                        },
                        onDeleteAll: {
                            viewModel.showDeleteAllConfirmation = true
                        }
                    )
                    .padding(.horizontal)
                    .background(Color.backgroundPrimary)
                }

                // Categories or Products Grid
                if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    CategoriesGridView(
                        categories: viewModel.categories,
                        getImageUseCase: viewModel.getImageUseCase,
                        thumbnails: viewModel.categoryThumbnails,
                        onTap: { category in
                            viewModel.onNavigation(.categoryDetails(category))
                        }
                    )
                } else {
                    ProductsGridView(
                        products: viewModel.products,
                        getImageUseCase: viewModel.getImageUseCase,
                        onTap: { product in
                            viewModel.onNavigation(.productDetails(product))
                        }
                    )
                }
            }
            .alert(isPresented: $viewModel.showDeleteAllConfirmation) {
                Alert(
                    title: Text(String(localized: "Delete All Searches")),
                    message: Text(String(localized: "Are you sure you want to delete all recent searches?")),
                    primaryButton: .destructive(Text(String(localized: "Delete All"))) {
                        viewModel.deleteAllSearchQueries()
                    },
                    secondaryButton: .cancel()
                )
            }
            .background(Color.backgroundPrimary)
        }
    }
}









