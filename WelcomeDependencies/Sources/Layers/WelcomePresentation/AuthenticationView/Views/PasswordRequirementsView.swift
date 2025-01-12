//
//  File.swift
//  
//
//  Created by Admin on 02/01/2025.
//

import SwiftUI

// MARK: - PasswordRequirementsView

struct PasswordRequirementsView: View {
    let password: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(String(localized: "Password Requirements:"))
                .font(.headline)
                .foregroundColor(Color.accentSecondary)

            RequirementRow(
                condition: password.count >= 8,
                text: String(localized: "At least 8 characters")
            )

            RequirementRow(
                condition: password.range(of: "[A-Z]", options: .regularExpression) != nil,
                text: String(localized: "At least one uppercase letter")
            )

            RequirementRow(
                condition: password.range(of: "[a-z]", options: .regularExpression) != nil,
                text: String(localized: "At least one lowercase letter")
            )

            RequirementRow(
                condition: password.range(of: "\\d", options: .regularExpression) != nil,
                text: String(localized: "At least one number")
            )

            RequirementRow(
                condition: password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil,
                text: String(localized: "At least one special character")
            )
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.backgroundSecondary.opacity(0.25))
        )
    }
}

struct PasswordRequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRequirementsView(password: "StrongP@ssw0rd")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
