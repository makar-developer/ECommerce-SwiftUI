//
//  File.swift
//  
//
//  Created by Admin on 02/01/2025.
//

import SwiftUI

// MARK: - RequirementRow View

struct RequirementRow: View {
    let condition: Bool
    let text: String

    var body: some View {
        HStack {
            Image(systemName: condition ? "checkmark.circle" : "xmark.circle")
                .foregroundColor(condition ? Color.successColor : Color.errorColor)
            Text(text)
                .foregroundColor(Color.accentSecondary)
            Spacer()
        }
        .font(.caption)
    }
}
