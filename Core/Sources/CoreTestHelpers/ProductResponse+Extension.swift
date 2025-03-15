//
//  ProductResponse+Extension.swift
//
//
//  Created by Admin on 07/01/2025.
//

import CoreEntities

public extension ProductResponse {
    static func getOneOfThis() -> ProductResponse {
        // Return the first page, containing the first 10 products
        let products = Array(allProducts[0 ..< 10])
        return ProductResponse(products: products, total: 30, skip: 0, limit: 10)
    }

    static func getAnArrayOfThese() -> [ProductResponse] {
        // Return an array of 3 ProductResponse items, each containing 10 products
        return [
            ProductResponse(products: Array(allProducts[0 ..< 10]), total: 30, skip: 0, limit: 10),
            ProductResponse(products: Array(allProducts[10 ..< 20]), total: 30, skip: 10, limit: 10),
            ProductResponse(products: Array(allProducts[20 ..< 30]), total: 30, skip: 20, limit: 10),
        ]
    }

    static let allProducts: [Product] = [
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
        Product(
            id: 4,
            price: 12.99,
            title: "Red Lipstick",
            description: "The Red Lipstick is a final classic and bold choice for adding a pop of color to your lips. With a creamy and pigmented formula, it provides a vibrant and long-lasting finish.",
            category: "beauty",
            thumbnail: "https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/thumbnail.png",
            brand: "Chic Cosmetics",
            images: [
                "https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/1.png",
            ],
            discountPercentage: 19.03,
            rating: 2.51,
            stock: 68
        ),
        Product(
            id: 5,
            price: 8.99,
            title: "Red Nail Polish",
            description: "The Red Nail Polish offers a rich and glossy red hue for vibrant and polished nails. With a quick-drying formula, it provides a salon-quality finish at home.",
            category: "beauty",
            thumbnail: "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/thumbnail.png",
            brand: "Nail Couture",
            images: [
                "https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/1.png",
            ],
            discountPercentage: 2.46,
            rating: 3.91,
            stock: 71
        ),
        Product(
            id: 6,
            price: 49.99,
            title: "Calvin Klein CK One",
            description: "CK One by Calvin Klein is a final classic unisex fragrance, known for its fresh and clean scent. It's a versatile fragrance suitable for everyday wear.",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/products/images/fragrances/Calvin%20Klein%20CK%20One/thumbnail.png",
            brand: "Calvin Klein",
            images: [
                "https://cdn.dummyjson.com/products/images/fragrances/Calvin%20Klein%20CK%20One/1.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Calvin%20Klein%20CK%20One/2.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Calvin%20Klein%20CK%20One/3.png",
            ],
            discountPercentage: 0.32,
            rating: 4.85,
            stock: 17
        ),
        Product(
            id: 7,
            price: 129.99,
            title: "Chanel Coco Noir Eau De",
            description: "Coco Noir by Chanel is an elegant and mysterious fragrance, featuring notes of grapefruit, rose, and sandalwood. Perfect for evening occasions.",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/thumbnail.png",
            brand: "Chanel",
            images: [
                "https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/1.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/2.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/3.png",
            ],
            discountPercentage: 18.64,
            rating: 2.76,
            stock: 41
        ),
        Product(
            id: 8,
            price: 89.99,
            title: "Dior J'adore",
            description: "J'adore by Dior is a luxurious and floral fragrance, known for its blend of ylang-ylang, rose, and jasmine. It embodies femininity and sophistication.",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/products/images/fragrances/Dior%20J'adore/thumbnail.png",
            brand: "Dior",
            images: [
                "https://cdn.dummyjson.com/products/images/fragrances/Dior%20J'adore/1.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Dior%20J'adore/2.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Dior%20J'adore/3.png",
            ],
            discountPercentage: 17.44,
            rating: 3.31,
            stock: 91
        ),
        Product(
            id: 9,
            price: 69.99,
            title: "Dolce Shine Eau de",
            description: "Dolce Shine by Dolce & Gabbana is a vibrant and fruity fragrance, featuring notes of mango, jasmine, and blonde woods. It's a joyful and youthful scent.",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/products/images/fragrances/Dolce%20Shine%20Eau%20de/thumbnail.png",
            brand: "Dolce & Gabbana",
            images: [
                "https://cdn.dummyjson.com/products/images/fragrances/Dolce%20Shine%20Eau%20de/1.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Dolce%20Shine%20Eau%20de/2.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Dolce%20Shine%20Eau%20de/3.png",
            ],
            discountPercentage: 11.47,
            rating: 2.68,
            stock: 3
        ),
        Product(
            id: 10,
            price: 79.99,
            title: "Gucci Bloom Eau de",
            description: "Gucci Bloom by Gucci is a floral and captivating fragrance, with notes of tuberose, jasmine, and Rangoon creeper. It's a modern and romantic scent.",
            category: "fragrances",
            thumbnail: "https://cdn.dummyjson.com/products/images/fragrances/Gucci%20Bloom%20Eau%20de/thumbnail.png",
            brand: "Gucci",
            images: [
                "https://cdn.dummyjson.com/products/images/fragrances/Gucci%20Bloom%20Eau%20de/1.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Gucci%20Bloom%20Eau%20de/2.png",
                "https://cdn.dummyjson.com/products/images/fragrances/Gucci%20Bloom%20Eau%20de/3.png",
            ],
            discountPercentage: 8.9,
            rating: 2.69,
            stock: 93
        ),
        Product(
            id: 11,
            price: 1899.99,
            title: "Annibale Colombo Bed",
            description: "The Annibale Colombo Bed is a luxurious and elegant bed frame, crafted with high-quality materials for a comfortable and stylish bedroom.",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/thumbnail.png",
            brand: "Annibale Colombo",
            images: [
                "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/1.png",
                "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/2.png",
                "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/3.png",
            ],
            discountPercentage: 0.29,
            rating: 4.14,
            stock: 47
        ),
        Product(
            id: 12,
            price: 2499.99,
            title: "Annibale Colombo Sofa",
            description: "The Annibale Colombo Sofa is a sophisticated and comfortable seating option, featuring exquisite design and premium upholstery for your living room.",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Sofa/thumbnail.png",
            brand: "Annibale Colombo",
            images: [
                "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Sofa/1.png",
                "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Sofa/2.png",
                "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Sofa/3.png",
            ],
            discountPercentage: 18.54,
            rating: 3.08,
            stock: 16
        ),
        Product(
            id: 13,
            price: 299.99,
            title: "Bedside Table African Cherry",
            description: "The Bedside Table in African Cherry is a stylish and functional addition to your bedroom, providing convenient storage space and a touch of elegance.",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/products/images/furniture/Bedside%20Table%20African%20Cherry/thumbnail.png",
            brand: "Furniture Co.",
            images: [
                "https://cdn.dummyjson.com/products/images/furniture/Bedside%20Table%20African%20Cherry/1.png",
                "https://cdn.dummyjson.com/products/images/furniture/Bedside%20Table%20African%20Cherry/2.png",
                "https://cdn.dummyjson.com/products/images/furniture/Bedside%20Table%20African%20Cherry/3.png",
            ],
            discountPercentage: 9.58,
            rating: 4.48,
            stock: 16
        ),
        Product(
            id: 14,
            price: 499.99,
            title: "Knoll Saarinen Executive Conference Chair",
            description: "The Knoll Saarinen Executive Conference Chair is a modern and ergonomic chair, perfect for your office or conference room with its timeless design.",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/products/images/furniture/Knoll%20Saarinen%20Executive%20Conference%20Chair/thumbnail.png",
            brand: "Knoll",
            images: [
                "https://cdn.dummyjson.com/products/images/furniture/Knoll%20Saarinen%20Executive%20Conference%20Chair/1.png",
                "https://cdn.dummyjson.com/products/images/furniture/Knoll%20Saarinen%20Executive%20Conference%20Chair/2.png",
                "https://cdn.dummyjson.com/products/images/furniture/Knoll%20Saarinen%20Executive%20Conference%20Chair/3.png",
            ],
            discountPercentage: 15.23,
            rating: 4.11,
            stock: 47
        ),
        Product(
            id: 15,
            price: 799.99,
            title: "Wooden Bathroom Sink With Mirror",
            description: "The Wooden Bathroom Sink with Mirror is a unique and stylish addition to your bathroom, featuring a wooden sink countertop and a matching mirror.",
            category: "furniture",
            thumbnail: "https://cdn.dummyjson.com/products/images/furniture/Wooden%20Bathroom%20Sink%20With%20Mirror/thumbnail.png",
            brand: "Bath Trends",
            images: [
                "https://cdn.dummyjson.com/products/images/furniture/Wooden%20Bathroom%20Sink%20With%20Mirror/1.png",
                "https://cdn.dummyjson.com/products/images/furniture/Wooden%20Bathroom%20Sink%20With%20Mirror/2.png",
                "https://cdn.dummyjson.com/products/images/furniture/Wooden%20Bathroom%20Sink%20With%20Mirror/3.png",
            ],
            discountPercentage: 11.22,
            rating: 3.26,
            stock: 95
        ),
        Product(
            id: 16,
            price: 1.99,
            title: "Apple",
            description: "Fresh and crisp apples, perfect for snacking or incorporating into various recipes.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Apple/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Apple/1.png",
            ],
            discountPercentage: 1.97,
            rating: 2.96,
            stock: 9
        ),
        Product(
            id: 17,
            price: 12.99,
            title: "Beef Steak",
            description: "High-quality beef steak, great for grilling or cooking to your preferred level of doneness.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Beef%20Steak/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Beef%20Steak/1.png",
            ],
            discountPercentage: 17.99,
            rating: 2.83,
            stock: 96
        ),
        Product(
            id: 18,
            price: 8.99,
            title: "Cat Food",
            description: "Nutritious cat food formulated to meet the dietary needs of your feline friend.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Cat%20Food/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Cat%20Food/1.png",
            ],
            discountPercentage: 9.57,
            rating: 2.88,
            stock: 13
        ),
        Product(
            id: 19,
            price: 9.99,
            title: "Chicken Meat",
            description: "Fresh and tender chicken meat, suitable for various culinary preparations.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Chicken%20Meat/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Chicken%20Meat/1.png",
                "https://cdn.dummyjson.com/products/images/groceries/Chicken%20Meat/2.png",
            ],
            discountPercentage: 10.46,
            rating: 4.61,
            stock: 69
        ),
        Product(
            id: 20,
            price: 4.99,
            title: "Cooking Oil",
            description: "Versatile cooking oil suitable for frying, sautéing, and various culinary applications.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Cooking%20Oil/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Cooking%20Oil/1.png",
            ],
            discountPercentage: 18.89,
            rating: 4.01,
            stock: 22
        ),
        Product(
            id: 21,
            price: 1.49,
            title: "Cucumber",
            description: "Crisp and hydrating cucumbers, ideal for salads, snacks, or as a refreshing side.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Cucumber/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Cucumber/1.png",
            ],
            discountPercentage: 11.44,
            rating: 4.71,
            stock: 22
        ),
        Product(
            id: 22,
            price: 10.99,
            title: "Dog Food",
            description: "Specially formulated dog food designed to provide essential nutrients for your canine companion.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Dog%20Food/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Dog%20Food/1.png",
            ],
            discountPercentage: 18.15,
            rating: 2.74,
            stock: 40
        ),
        Product(
            id: 23,
            price: 2.99,
            title: "Eggs",
            description: "Fresh eggs, a versatile ingredient for baking, cooking, or breakfast.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Eggs/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Eggs/1.png",
            ],
            discountPercentage: 5.8,
            rating: 4.46,
            stock: 10
        ),
        Product(
            id: 24,
            price: 14.99,
            title: "Fish Steak",
            description: "Quality fish steak, suitable for grilling, baking, or pan-searing.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Fish%20Steak/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Fish%20Steak/1.png",
            ],
            discountPercentage: 7.0,
            rating: 4.83,
            stock: 99
        ),
        Product(
            id: 25,
            price: 1.29,
            title: "Green Bell Pepper",
            description: "Fresh and vibrant green bell pepper, perfect for adding color and flavor to your dishes.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Green%20Bell%20Pepper/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Green%20Bell%20Pepper/1.png",
            ],
            discountPercentage: 15.5,
            rating: 4.28,
            stock: 89
        ),
        Product(
            id: 26,
            price: 0.99,
            title: "Green Chili Pepper",
            description: "Spicy green chili pepper, ideal for adding heat to your favorite recipes.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Green%20Chili%20Pepper/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Green%20Chili%20Pepper/1.png",
            ],
            discountPercentage: 18.51,
            rating: 4.43,
            stock: 8
        ),
        Product(
            id: 27,
            price: 6.99,
            title: "Honey Jar",
            description: "Pure and natural honey in a convenient jar, perfect for sweetening beverages or drizzling over food.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Honey%20Jar/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Honey%20Jar/1.png",
            ],
            discountPercentage: 1.91,
            rating: 3.5,
            stock: 25
        ),
        Product(
            id: 28,
            price: 5.49,
            title: "Ice Cream",
            description: "Creamy and delicious ice cream, available in various flavors for a delightful treat.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Ice%20Cream/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Ice%20Cream/1.png",
                "https://cdn.dummyjson.com/products/images/groceries/Ice%20Cream/2.png",
                "https://cdn.dummyjson.com/products/images/groceries/Ice%20Cream/3.png",
                "https://cdn.dummyjson.com/products/images/groceries/Ice%20Cream/4.png",
            ],
            discountPercentage: 7.58,
            rating: 3.77,
            stock: 76
        ),
        Product(
            id: 29,
            price: 3.99,
            title: "Juice",
            description: "Refreshing fruit juice, packed with vitamins and great for staying hydrated.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Juice/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Juice/1.png",
            ],
            discountPercentage: 5.45,
            rating: 3.41,
            stock: 99
        ),
        Product(
            id: 30,
            price: 2.49,
            title: "Kiwi",
            description: "Nutrient-rich kiwi, perfect for snacking or adding a tropical twist to your dishes.",
            category: "groceries",
            thumbnail: "https://cdn.dummyjson.com/products/images/groceries/Kiwi/thumbnail.png",
            brand: "N/A",
            images: [
                "https://cdn.dummyjson.com/products/images/groceries/Kiwi/1.png",
            ],
            discountPercentage: 10.32,
            rating: 4.37,
            stock: 1
        ),
    ]
}
