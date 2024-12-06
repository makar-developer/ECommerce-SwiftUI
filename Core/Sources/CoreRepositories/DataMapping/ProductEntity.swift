//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//

import CoreEntities

extension ProductEntity {
    func toProduct() -> Product? {
        guard let title = self.title,
              let description = self.productDescription,
              let category = self.category,
              let thumbnail = self.thumbnail else {
            return nil
        }
        
        
        return Product(
            id: Int(self.id),
            price: self.price,
            title: title,
            description: description,
            category: category,
            thumbnail: thumbnail,
            brand: self.brand,
            images: [], // Assuming images are handled separately or need to be added
            discountPercentage: self.discountPercentage,
            rating: self.rating,
            stock: Int(self.stock)
        )
    }
}
