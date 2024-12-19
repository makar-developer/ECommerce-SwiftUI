//
//  File.swift
//  
//
//  Created by Admin on 19/12/2024.
//

import SwiftUI
import CoreEntities
import CoreUseCases
import CoreStyleguide
// MARK: - ProductsGridView

struct ProductsGridView: View {
    let products: [Product]
    let getImageUseCase: GetImageUseCaseProtocol
    let onTap: (Product) -> Void
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            if products.isEmpty {
                Text("No products found.")
                    .foregroundColor(.gray)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(products) { product in
                        ProductCardView(product: product, onNavigation: { product in
                            onTap(product)
                        }, getImageUseCase: getImageUseCase)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
    }
}
