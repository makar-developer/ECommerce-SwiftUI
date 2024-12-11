//
//  File.swift
//  
//
//  Created by Admin on 11/12/2024.
//

import Foundation

public struct SearchQuery: Codable, Identifiable, Equatable {
    public let id: UUID
    public let query: String
    public let creationDate: Date

    public init(id: UUID = UUID(), query: String, creationDate: Date = Date()) {
        self.id = id
        self.query = query
        self.creationDate = creationDate
    }
}
