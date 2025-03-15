//
//  Product+Extension.swift
//
//
//  Created by Admin on 07/01/2025.
//

import CoreEntities

public extension Product {
    static func getOneOfThis() -> Product {
        return Product(
            id: 1,
            price: 9.99,
            title: "Essence Mascara Lash Princess",
            description: "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects. Achieve dramatic lashes with this long-lasting and cruelty-free formula.",
            category: "beauty",
            thumbnail: "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png",
            brand: "Essence",
            images: [
                "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png",
            ],
            discountPercentage: 7.17,
            rating: 4.94,
            stock: 5
        )
    }

    static func getAnArrayOfThese() -> [Product] {
        return [
            Product(
                id: 1,
                price: 9.99,
                title: "Essence Mascara Lash Princess",
                description: "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects. Achieve dramatic lashes with this long-lasting and cruelty-free formula.",
                category: "beauty",
                thumbnail: "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png",
                brand: "Essence",
                images: [
                    "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png",
                ],
                discountPercentage: 7.17,
                rating: 4.94,
                stock: 5
            ),
            Product(
                id: 2,
                price: 19.99,
                title: "Eyeshadow Palette with Mirror",
                description: "The Eyeshadow Palette with Mirror offers a versatile range of eyeshadow shades for creating stunning eye looks. With a built-in mirror, it's convenient for on-the-go makeup application.",
                category: "beauty",
                thumbnail: "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png",
                brand: "Glamour Beauty",
                images: [
                    "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/1.png",
                ],
                discountPercentage: 5.5,
                rating: 3.28,
                stock: 44
            ),
            Product(
                id: 3,
                price: 14.99,
                title: "Powder Canister",
                description: "The Powder Canister is a finely milled setting powder designed to set makeup and control shine. With a lightweight and translucent formula, it provides a smooth and matte finish.",
                category: "beauty",
                thumbnail: "https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png",
                brand: "Velvet Touch",
                images: [
                    "https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/1.png",
                ],
                discountPercentage: 18.14,
                rating: 3.82,
                stock: 59
            ),
        ]
    }
}
