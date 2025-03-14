//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import Foundation

public struct ProductHistory: Identifiable, Hashable, Codable {
    public let id: UUID
    public let product: Product
    public let timestamp: Date
    
    public init(id: UUID = UUID(), product: Product, timestamp: Date = Date()) {
        self.id = id
        self.product = product
        self.timestamp = timestamp
    }
}
