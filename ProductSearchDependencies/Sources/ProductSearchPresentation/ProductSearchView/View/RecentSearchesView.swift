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
                Spacer()
                Button(action: onDeleteAll) {
                    Text("Delete All")
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 5)
            
            if recentQueries.isEmpty {
                Text("No recent searches.")
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            } else {
                List {
                    ForEach(recentQueries) { query in
                        Text(query.query)
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
            }
        }
    }
}
