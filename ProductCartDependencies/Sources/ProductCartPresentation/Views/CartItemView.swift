//
//  File.swift
//  
//
//  Created by Admin on 22/12/2024.
//

import SwiftUI
import CoreEntities
import CoreStyleguide
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
                        .foregroundColor(.accentSecondary)
                    Spacer()
                    Menu {
                        Button(String(localized: "Delete from Cart"), role: .destructive) {
                            onDelete()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.accentSecondary)
                    }
                }
                
                Spacer()
                
                // Quantity Stepper and Price
                HStack {
                    // Quantity Stepper
                    HStack {
                        Button(action: onDecrement) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.accentPrimary)
                        }
                        Text("\(cartItem.quantity)")
                            .foregroundColor(.textSecondary)
                        Button(action: onIncrement) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.accentPrimary)
                        }
                    }
                    
                    Spacer()
                    
                    // Price
                    Text("$\(cartItem.product.price * Double(cartItem.quantity), specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.accentSecondary)
                }
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(15)
        .shadow(color: Color.borderColor.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
