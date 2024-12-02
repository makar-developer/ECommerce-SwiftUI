//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import SwiftUI
import Core
import CoreEntities
public struct ProductCardView: View {
    let product: Product
    let onNavigation: (Product) -> Void

    @Environment(\.screenWidth) private var screenWidth
    
    public init(product: Product, onNavigation: @escaping (Product) -> Void) {
        self.product = product
        self.onNavigation = onNavigation
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            // Image
            AsyncImage(url: URL(string: product.thumbnail)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
//                        .frame(height: screenWidth * 0.25)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
//                        .frame(height: screenWidth * 0.25)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
//                        .frame(height: screenWidth * 0.25)
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(8)
            
            // Title
            Text(product.title)
                .font(.headline)
                .lineLimit(1)
                .padding(.top, 5)
            
            // Description
            Text(product.description)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundColor(.secondary)
                .padding(.top, 1)
            
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
            .padding(.top, 5)
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
