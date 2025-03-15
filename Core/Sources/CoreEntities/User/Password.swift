//
//  Password.swift
//
//
//  Created by Admin on 26/11/2024.
//

// Password.swift
public struct Password: Hashable, Codable {
    public let rawValue: String

    public init?(rawValue: String) {
        // Validate password:
        // - Minimum 8 characters
        // - At least one uppercase letter
        // - At least one lowercase letter
        // - At least one number
        // - At least one special character
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+{}|:<>?~-]).{8,}$"
        guard rawValue.range(of: regex, options: .regularExpression) != nil else {
            return nil
        }
        self.rawValue = rawValue
    }
}
