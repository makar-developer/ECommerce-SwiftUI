//
//  File.swift
//  
//
//  Created by Admin on 19/12/2024.
//

import SwiftUI
import ProductSearchEntities

// MARK: - RecentSearchesView

struct RecentSearchesView: View {
    let recentQueries: [SearchQuery]
    let onSelect: (SearchQuery) -> Void
    let onDelete: (SearchQuery) -> Void
    let onDeleteAll: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recent Searches")
                    .font(.headline)
                    .foregroundColor(.textBackground)
                Spacer()
                Button(action: onDeleteAll) {
                    Text("Delete All")
                        .foregroundColor(.errorColor)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            if recentQueries.isEmpty {
                Text("No recent searches.")
                    .foregroundColor(.textSecondary)
                    .padding(.top, 5)
            } else {
                List {
                    ForEach(recentQueries) { query in
                        Text(query.query)
                            .foregroundColor(.accentSecondary)
                            .listRowBackground(Color.backgroundSecondary) // Fix: Explicitly set list row background
                            .onTapGesture {
                                onSelect(query)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    onDelete(query)
                                } label: {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: min(CGFloat(recentQueries.count) * 44, 200))
                 .background(Color.backgroundPrimary) // Ensure the List itself has the correct background
                 .cornerRadius(12) // Optional: Add corner radius for visual consistency


            }
        }

    }
}
