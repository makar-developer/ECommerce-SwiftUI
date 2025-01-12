//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

// UserName.swift
public struct UserName: Hashable, Codable {
    public let rawValue: String

    public init?(rawValue: String) {
        // Validate that the name is not empty and has a reasonable length
        guard !rawValue.trimmingCharacters(in: .whitespaces).isEmpty,
              rawValue.count >= 2,
              rawValue.count <= 50 else {
            return nil
        }
        self.rawValue = rawValue
    }
}
