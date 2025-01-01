//
//  File.swift
//  
//
//  Created by Admin on 02/01/2025.
//

import SwiftUI
// MARK: - BackButton View

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.accentSecondary)
                Text(String(localized: "Back"))
                    .foregroundColor(Color.accentSecondary)
            }
        }
    }
}
