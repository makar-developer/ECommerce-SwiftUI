//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

// Password.swift
public struct Password: Hashable, Codable {
    public let rawValue: String

    public init?(_ rawValue: String) {
        // Validate password (e.g., minimum length)
        guard rawValue.count >= 7 else {
            return nil
        }
        self.rawValue = rawValue
    }
}
