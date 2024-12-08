//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import SwiftUI
import Core
import CoreEntities
import CoreUseCases
public struct ProductCardView: View {
    let product: Product
    let onNavigation: (Product) -> Void
    let getImageUseCase: GetImageUseCaseProtocol

    @Environment(\.screenWidth) private var screenWidth

    public init(product: Product, onNavigation: @escaping (Product) -> Void, getImageUseCase: GetImageUseCaseProtocol) {
        self.product = product
        self.onNavigation = onNavigation
        self.getImageUseCase = getImageUseCase
    }

    public var body: some View {
        VStack(alignment: .center) {
            // Image
            if let url = URL(string: product.thumbnail) {
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
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenWidth * 0.33)
            }

            // Title
            Text(product.title)
                .font(.headline)
                .lineLimit(1)
            // Description
            Text(product.description)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundColor(.secondary)
            // Rating and Price
            HStack {
                Label("\(product.rating, specifier: "%.1f")", systemImage: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.subheadline)
                Spacer()
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .onTapGesture {
            onNavigation(product)
        }
    }
}

