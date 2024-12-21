//
//  File.swift
//  
//
//  Created by Admin on 04/12/2024.
//

import CoreEntities
import CoreData
public extension ProductEntity {
    func toProduct() -> Product? {
        guard let title = self.title,
              let description = self.productDescription,
              let category = self.category,
              let thumbnail = self.thumbnail else {
            return nil
        }
        
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
    func toCoreDataEntity(context: NSManagedObjectContext) -> ProductEntity {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", self.id)
        
        let imageEntities = self.images.map { imageURL -> ImageEntity in
            let imageEntity = ImageEntity(context: context)
            imageEntity.image = imageURL
            return imageEntity
        }
        
        if let existingEntity = try? context.fetch(fetchRequest).first {
            return existingEntity
        } else {
            let entity = ProductEntity(context: context)
            entity.id = Int64(self.id)
            entity.price = self.price
            entity.title = self.title
            entity.category = self.category
            entity.thumbnail = self.thumbnail
            entity.brand = self.brand
            entity.productDescription = self.description
            entity.discountPercentage = self.discountPercentage
            entity.rating = self.rating
            entity.stock = Int32(self.stock)
            
            entity.images = NSSet(array: imageEntities)
            return entity
        }
    }
}
