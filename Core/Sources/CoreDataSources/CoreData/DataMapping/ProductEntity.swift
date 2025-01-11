//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//

import CoreEntities
import CoreData

public extension ProductEntity {
    func toDomain() -> Product? {
        guard
            let title = self.title,
            let description = self.productDescription,
            let category = self.category,
            let thumbnail = self.thumbnail
        else { return nil }
        
        let imageSet = (self.images as? Set<ImageEntity>) ?? []
        let imageURLs = imageSet.compactMap { $0.image }
        
        return Product(
            id: Int(self.id),
            price: self.price,
            title: title,
            description: description,
            category: category,
            thumbnail: thumbnail,
            brand: self.brand,
            images: imageURLs,
            discountPercentage: self.discountPercentage,
            rating: self.rating,
            stock: Int(self.stock)
        )
    }
}

public extension Product {
    func toCoreData(context: NSManagedObjectContext) -> ProductEntity {
        let entity = ProductEntity(context: context)
        entity.id = Int64(id)
        entity.price = price
        entity.title = title
        entity.category = category
        entity.thumbnail = thumbnail
        entity.brand = brand
        entity.productDescription = description
        entity.discountPercentage = discountPercentage
        entity.rating = rating
        entity.stock = Int32(stock)
        
        let imageEntities = images.map { url -> ImageEntity in
            let imageEntity = ImageEntity(context: context)
            imageEntity.image = url
            return imageEntity
        }
        entity.images = NSSet(array: imageEntities)
        
        return entity
    }
}
