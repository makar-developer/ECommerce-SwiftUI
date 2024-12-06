//
//  File.swift
//  
//
//  Created by Admin on 05/12/2024.
//

import SwiftUI
import CoreEntities
public struct CartItemView: View {
    let cartItem: CartItem
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onDelete: () -> Void
    
    public var body: some View {
        HStack {
            // Product Image
            AsyncImage(url: URL(string: cartItem.product.thumbnail)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            
            VStack(alignment: .leading) {
                // Product Title and Context Menu
                HStack {
                    Text(cartItem.product.title)
                        .font(.headline)
                    Spacer()
                    Menu {
                        Button("Delete from Cart", role: .destructive) {
                            onDelete()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Quantity Stepper and Price
                HStack {
                    // Quantity Stepper
                    HStack {
                        Button(action: onDecrement) {
                            Image(systemName: "minus.circle")
                        }
                        Text("\(cartItem.quantity)")
                        Button(action: onIncrement) {
                            Image(systemName: "plus.circle")
                        }
                    }
                    
                    Spacer()
                    
                    // Price
                    Text("$\(cartItem.product.price * Double(cartItem.quantity), specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

public struct ProductCartView: View {
    @StateObject private var viewModel: ProductCartViewModel
    
    public init(viewModel: ProductCartViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            // Cart Items List
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.cartItems) { cartItem in
                        CartItemView(
                            cartItem: cartItem,
                            onIncrement: { viewModel.incrementQuantity(for: cartItem) },
                            onDecrement: { viewModel.decrementQuantity(for: cartItem) },
                            onDelete: { viewModel.removeItem(cartItem) }
                        )
                    }
                }
                .padding(.bottom, 120) // Space for checkout button
            }
            
            // Checkout Button
            VStack {
                Spacer()
                Button(action: viewModel.checkout) {
                    HStack {
                        Text("Checkout")
                        Spacer()
                        Text("$\(viewModel.totalPrice, specifier: "%.2f")")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadCartItems()
        }
    }
}
