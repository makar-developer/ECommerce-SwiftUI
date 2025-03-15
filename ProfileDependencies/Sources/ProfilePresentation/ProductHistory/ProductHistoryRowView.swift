//
//  ProductHistoryRowView.swift
//
//
//  Created by Admin on 17/12/2024.
//

import CoreEntities
import CoreStyleguide
import CoreUseCases
import SwiftUI

struct ProductHistoryRowView: View {
    let history: ProductHistory
    let getImageUseCase: GetImageUseCaseProtocol
    let onSelect: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack {
            if let url = URL(string: history.product.thumbnail) {
                CustomAsyncImage(
                    url: url,
                    getImageUseCase: getImageUseCase,
                    placeholder: {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentPrimary))
                    },
                    image: { image in
                        image
                            .resizable()
                    }
                )
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.textSecondary)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(history.product.title)
                    .font(.headline)
                    .foregroundColor(.textBackground)
                    .lineLimit(1)
                Text(history.product.description)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                Text(String(localized: "Viewed on \(formattedDate(history.timestamp))"))
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.errorColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .background(Color.backgroundPrimary)
        .cornerRadius(10)
        .shadow(color: Color.borderColor.opacity(0.1), radius: 2, x: 0, y: 1)
        .onTapGesture {
            onSelect()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
