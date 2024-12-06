//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import Foundation

public struct Cart: Identifiable, Hashable, Codable {
    
    public var userId: UUID
    public let id: UUID
    public var products: [CartItem]

    public init(products: [CartItem] = [], id: UUID = UUID(), userId: UUID) {
        self.id = id
        self.products = products
        self.userId = userId
    }
    
    // Equitable conformance
    public static func == (lhs: Cart, rhs: Cart) -> Bool {
        return lhs.id == rhs.id
    }
}
