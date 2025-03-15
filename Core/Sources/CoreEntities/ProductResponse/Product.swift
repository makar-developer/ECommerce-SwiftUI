//
//  Product.swift
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
    public let brand: String?
    public let images: [String]
    public let discountPercentage: Double
    public let rating: Double
    public let stock: Int

    public init(
        id: Int,
        price: Double,
        title: String,
        description: String,
        category: String,
        thumbnail: String,
        brand: String?,
        images: [String],
        discountPercentage: Double,
        rating: Double,
        stock: Int
    ) {
        self.id = id
        self.price = price
        self.title = title
        self.description = description
        self.category = category
        self.thumbnail = thumbnail
        self.brand = brand
        self.images = images
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
    }

    enum CodingKeys: String, CodingKey {
        case id, price, title, description, brand, category, thumbnail, images, discountPercentage, rating, stock
    }

    // Equatable conformance
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
