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
    @FocusState private var isKeyboardFocused: Bool // Keep the focus state if you need it for keyboard management

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
                }

                // Categories or Products Grid
                if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    CategoriesGridView(
                        categories: viewModel.categories,
                        getImageUseCase: viewModel.getImageUseCase,
                        thumbnails: viewModel.categoryThumbnails, onTap: { category in
                            viewModel.onNavigation(.categoryDetails(category))
                        }
                    )
                } else {
                    ProductsGridView(products: viewModel.products, getImageUseCase: viewModel.getImageUseCase, onTap: { product in
                        viewModel.onNavigation(.productDetails(product))
                    })
                }
            }
            .alert(isPresented: $viewModel.showDeleteAllConfirmation) {
                Alert(
                    title: Text("Delete All Searches"),
                    message: Text("Are you sure you want to delete all recent searches?"),
                    primaryButton: .destructive(Text("Delete All")) {
                        viewModel.deleteAllSearchQueries()
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Product Search")
        }
    }
}










