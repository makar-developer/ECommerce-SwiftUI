//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import Foundation

public struct Cart: Identifiable, Hashable, Codable {
    
    
    public let id: UUID
    public var products: [CartItem]

    public init(products: [CartItem] = []) {
        self.id = UUID()
        self.products = products
    }
    
    // Equitable conformance
    public static func == (lhs: Cart, rhs: Cart) -> Bool {
        return lhs.id == rhs.id
    }
}
