//
//  File.swift
//  
//
//  Created by Admin on 02/01/2025.
//

import SwiftUI
// MARK: - InputField View

struct InputField: View {
    let title: String
    @Binding var text: String
    let error: String
    let icon: String
    let isSecure: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.accentSecondary)
                if isSecure {
                    SecureField(title, text: $text)
                        .autocapitalization(.none)
                        .foregroundColor(Color.accentSecondary)
                } else {
                    TextField(title, text: $text)
                        .autocapitalization(.words)
                        .foregroundColor(Color.accentSecondary)
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(error.isEmpty ? Color.borderColor.opacity(0.5) : Color.errorColor, lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.backgroundSecondary.opacity(0.15)))
            )

            if !error.isEmpty {
                Text(error)
                    .foregroundColor(Color.errorColor)
                    .font(.caption)
                    .padding(.leading, 8)
            }
        }
    }
}
