//
//  SearchBarView.swift
//
//
//  Created by Admin on 19/12/2024.
//

import SwiftUI

// MARK: - SearchBarView

struct SearchBarView: View {
    @Binding var text: String
    @Binding var isFocused: Bool
    var onCommit: () -> Void

    var body: some View {
        HStack {
            TextField(String(localized: "Search products..."), text: $text, onEditingChanged: { editing in
                withAnimation {
                    isFocused = editing
                }
            }, onCommit: onCommit)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color.backgroundSecondary)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.accentPrimary)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.accentSecondary)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
    }
}
