//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

// UserName.swift
public struct UserName: Hashable, Codable {
    public let rawValue: String

    public init?(_ rawValue: String) {
        // Validate that the name is not empty
        guard !rawValue.isEmpty else {
            return nil
        }
        self.rawValue = rawValue
    }
}
