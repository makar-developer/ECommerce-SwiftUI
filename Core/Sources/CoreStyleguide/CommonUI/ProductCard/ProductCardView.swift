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

    @Environment(\.screenHeight) private var screenHeight

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
                        ZStack {
                            ProgressView()
                                .tint(.accentPrimary)
                            Color.gray.opacity(0.1)
                        }
                    },
                    image: { image in
                        image
                    }
                )
                .scaledToFit()
                .clipped()
                .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
            VStack {
                // Title
                Text(product.title)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.accentSecondary)
                    .saturation(1.7)
                // Description
                Text(product.description)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.textSecondary)
                    .saturation(1.5)
                // Rating and Price
                HStack {
                    Label("\(product.rating, specifier: "%.1f")", systemImage: "star.fill")
                        .foregroundColor(.accentPrimary)
                        .font(.subheadline)
                    Spacer()
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.accentPrimary)
                }
            }
        }
        .frame(height: screenHeight * 0.6)
        .padding(.horizontal)
        .padding(.bottom)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
        .shadow(color: Color.borderColor.opacity(0.5), radius: 4, x: 0, y: 2)
        .onTapGesture {
            onNavigation(product)
        }

    }
}
