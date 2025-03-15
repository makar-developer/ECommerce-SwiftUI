//
//  CategoriesGridView.swift
//
//
//  Created by Admin on 19/12/2024.
//

import CoreUseCases
import ProductSearchEntities
import SwiftUI

// MARK: - CategoriesGridView

struct CategoriesGridView: View {
    let categories: [CategoryResponse]
    let getImageUseCase: GetImageUseCaseProtocol
    let thumbnails: [String: String]
    let onTap: (CategoryResponse) -> Void
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            if categories.isEmpty {
                Text(String(localized: "No categories available."))
                    .foregroundColor(.textSecondary)
                    .padding()
            } else {
                LazyVGrid(columns: columns) {
                    ForEach(categories, id: \.slug) { category in
                        CategoryCardView(
                            category: category,
                            getImageUseCase: getImageUseCase,
                            thumbnailUrl: thumbnails[category.slug]
                        )
                        .onTapGesture {
                            onTap(category)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .background(Color.backgroundPrimary)
    }
}
