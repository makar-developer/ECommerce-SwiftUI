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
                    onCommit: { // Add onCommit handler
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
                Group {
                    // Categories or Products Grid
                    if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        CategoriesGridView(
                            categories: viewModel.categories,
                            getImageUseCase: viewModel.getImageUseCase,
                            thumbnails: viewModel.categoryThumbnails
                        )
                        
                    } else {
                        ProductsGridView(products: viewModel.products, getImageUseCase: viewModel.getImageUseCase)
                    }
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

// MARK: - SearchBarView

struct SearchBarView: View {
    @Binding var text: String
    @Binding var isFocused: Bool
    var onCommit: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search products...", text: $text, onEditingChanged: { editing in
                withAnimation {
                    isFocused = editing
                }
            }, onCommit: onCommit)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
        }
    }
}

// MARK: - RecentSearchesView

struct RecentSearchesView: View {
    let recentQueries: [SearchQuery]
    let onSelect: (SearchQuery) -> Void
    let onDelete: (SearchQuery) -> Void
    let onDeleteAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recent Searches")
                    .font(.headline)
                Spacer()
                Button(action: onDeleteAll) {
                    Text("Delete All")
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 5)
            
            if recentQueries.isEmpty {
                Text("No recent searches.")
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            } else {
                List {
                    ForEach(recentQueries) { query in
                        Text(query.query)
                            .onTapGesture {
                                onSelect(query)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    onDelete(query)
                                } label: {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: min(CGFloat(recentQueries.count) * 44, 200))
            }
        }
    }
}

// MARK: - CategoriesGridView

struct CategoriesGridView: View {
    let categories: [CategoryResponse]
    let getImageUseCase: GetImageUseCaseProtocol
    let thumbnails: [String: String]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            if categories.isEmpty {
                Text("No categories available.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(categories, id: \.slug) { category in
                        CategoryCardView(
                            category: category,
                            getImageUseCase: getImageUseCase,
                            thumbnailUrl: thumbnails[category.slug]
                        )
                        .onTapGesture {
                            print("Category tapped: \(category.name)")
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CategoryCardView: View {
    let category: CategoryResponse
    let getImageUseCase: GetImageUseCaseProtocol
    let thumbnailUrl: String?
    
    @Environment(\.screenWidth) private var screenWidth
    
    var body: some View {
        VStack {
            if let thumbnailUrlString = thumbnailUrl,
               let url = URL(string: thumbnailUrlString) {
                CustomAsyncImage(
                    url: url,
                    getImageUseCase: getImageUseCase,
                    placeholder: {
                        ProgressView()
                            .frame(height: screenWidth * 0.33)
                    },
                    image: { image in
                        image
                    }
                )
                .scaledToFit()
                .frame(height: screenWidth * 0.33)
                .clipped()
                .cornerRadius(8)
            } else {
                ZStack {
                    Color(.gray)
                        .opacity(0.1)
                        .scaledToFit()
                        .frame(height: screenWidth * 0.33)
                    ProgressView()
                }
            }
            
            Text(category.name)
                .font(.headline)
                .lineLimit(1)
                .padding(.top, 5)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
// MARK: - ProductsGridView

struct ProductsGridView: View {
    let products: [Product]
    let getImageUseCase: GetImageUseCaseProtocol
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            if products.isEmpty {
                Text("No products found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(products) { product in
                        ProductCardView(product: product, onNavigation: { product in
                            print("Product tapped: \(product.title)")
                        }, getImageUseCase: getImageUseCase)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}



