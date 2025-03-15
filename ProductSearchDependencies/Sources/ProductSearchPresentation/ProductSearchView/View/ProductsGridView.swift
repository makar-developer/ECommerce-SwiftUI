//
//  ProductsGridView.swift
//
//
//  Created by Admin on 19/12/2024.
//

import CoreEntities
import CoreStyleguide
import CoreUseCases
import SwiftUI

// MARK: - ProductsGridView

struct ProductsGridView: View {
    let products: [Product]
    let getImageUseCase: GetImageUseCaseProtocol
    let onTap: (Product) -> Void
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            if products.isEmpty {
                Text("No products found.")
                    .foregroundColor(.textSecondary)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(products) { product in
                        ProductCardView(
                            product: product,
                            onNavigation: { product in
                                onTap(product)
                            },
                            getImageUseCase: getImageUseCase
                        )
                    }
                    .background(Color.backgroundPrimary)
                }
                .padding(.horizontal)
                .padding(.top)
                .background(Color.backgroundPrimary)
            }
        }
        .background(Color.backgroundPrimary)
    }
}
