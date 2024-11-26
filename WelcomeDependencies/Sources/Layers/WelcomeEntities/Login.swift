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
        // Validate login (e.g., minimum length)
        guard rawValue.count >= 4 else {
            return nil
        }
        self.rawValue = rawValue
    }
}
