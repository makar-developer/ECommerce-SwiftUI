//
//  File.swift
//  
//
//  Created by Admin on 12/12/2024.
//

import CoreStyleguide
import SwiftUI

// MARK: - CategoryDetailsView

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
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.products) { product in
                    ProductCardView(
                        product: product,
                        onNavigation: { selectedProduct in
                            viewModel.showProductDetails(product: selectedProduct)
                        },
                        getImageUseCase: viewModel.getImageUseCase
                    )
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.categoryResponse.name)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.onNavigation(.productSearch)
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("Product Search")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
