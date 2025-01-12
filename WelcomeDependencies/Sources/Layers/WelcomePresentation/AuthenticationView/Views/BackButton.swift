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

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(action: {
            print("Back button tapped")
        })
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
