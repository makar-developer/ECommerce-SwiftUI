//
//  ProductEntity.swift
//
//
//  Created by Admin on 04/12/2024.
//

import CoreData
import CoreEntities

public extension ProductEntity {
    func toDomain() -> Product? {
        guard
            let title = title,
            let description = productDescription,
            let category = category,
            let thumbnail = thumbnail
        else { return nil }

        let imageSet = (images as? Set<ImageEntity>) ?? []
        let imageURLs = imageSet.compactMap { $0.image }

        return Product(
            id: Int(id),
            price: price,
            title: title,
            description: description,
            category: category,
            thumbnail: thumbnail,
            brand: brand,
            images: imageURLs,
            discountPercentage: discountPercentage,
            rating: rating,
            stock: Int(stock)
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
