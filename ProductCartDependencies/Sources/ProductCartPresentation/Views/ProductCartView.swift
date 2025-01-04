//
//  File.swift
//  
//
//  Created by Admin on 05/12/2024.
//


import SwiftUI
import CoreEntities
import CoreStyleguide

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
                            onDelete: { viewModel.removeEntireItem(cartItem) }
                        )
                    }
                }
                .padding(.bottom, 120) // Space for checkout button
                .background(Color.backgroundPrimary)
            }
            
            // Checkout Button
            VStack {
                Spacer()
                Button(action: {viewModel.checkout()}) {
                    HStack {
                        Text(String(localized: "Checkout"))
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text("$\(viewModel.totalPrice, specifier: "%.2f")")
                            .foregroundColor(.textPrimary)
                    }
                    .padding()
                    .background(Color.accentPrimary)
                    .cornerRadius(30)
                    .shadow(color: Color.accentPrimary.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadCartItems()
        }
        .background(Color.backgroundPrimary)
    }
}
