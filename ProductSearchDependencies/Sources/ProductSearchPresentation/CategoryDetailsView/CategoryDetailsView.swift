//
//  File.swift
//  
//
//  Created by Admin on 12/12/2024.
//

import CoreStyleguide
import SwiftUI

// MARK: - CategoryDetailsView

import SwiftUI
public struct CategoryDetailsView: View {
    @StateObject private var viewModel: CategoryDetailsViewModel

    public init(viewModel: CategoryDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    public var body: some View {
        ScrollView {
            LoadableScreen($viewModel.productsState) { products in
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(products) { product in
                        ProductCardView(
                            product: product,
                            onNavigation: { selectedProduct in
                                viewModel.showProductDetails(product: selectedProduct)
                            },
                            getImageUseCase: viewModel.getImageUseCase
                        )
                        .background(Color.backgroundSecondary)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                }
                .padding()
                .background(Color.backgroundPrimary)
            }
            .background(Color.backgroundPrimary)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
        .navigationTitle(viewModel.categoryResponse.name)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.onNavigation(.productSearch)
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.accentPrimary)
                        Text(String(localized: "Product Search"))
                            .foregroundColor(Color.accentPrimary)
                    }
                }
            }
        }
        .background(Color.backgroundPrimary)
    }
}
