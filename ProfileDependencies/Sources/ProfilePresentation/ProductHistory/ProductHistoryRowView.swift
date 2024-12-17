//
//  File.swift
//  
//
//  Created by Admin on 17/12/2024.
//

import SwiftUI
import CoreEntities
import CoreUseCases
import CoreStyleguide
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
            }
            VStack(alignment: .leading) {
                Text(history.product.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(history.product.description)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
                Text("Viewed on \(formattedDate(history.timestamp))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .contentShape(Rectangle())
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
