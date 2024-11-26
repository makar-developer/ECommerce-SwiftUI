//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

// Login.swift
public struct Login: Hashable, Codable {
    public let rawValue: String

    public init?(_ rawValue: String) {
        // Validate login: minimum 4 characters, alphanumeric
        let regex = "^[a-zA-Z0-9]{4,}$"
        guard rawValue.range(of: regex, options: .regularExpression) != nil else {
            return nil
        }
        self.rawValue = rawValue
    }
}
