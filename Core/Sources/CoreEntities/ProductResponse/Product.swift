//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

public struct Product: Codable, Identifiable, Equatable, Hashable {
    public let id: Int
    public let price: Double
    public let title: String
    public let description: String
    public let category: String
    public let thumbnail: String
    public let brand: String? // Optional
    public let images: [String]
    public let discountPercentage: Double
    public let rating: Double
    public let stock: Int

    enum CodingKeys: String, CodingKey {
        case id, price, title, description, brand, category, thumbnail, images, discountPercentage, rating, stock
    }

    // Equatable conformance
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
