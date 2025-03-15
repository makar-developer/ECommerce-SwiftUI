//
//  ImageEntity.swift
//
//
//  Created by Admin on 21/12/2024.
//

import CoreData

public extension ImageEntity {
    func toImageURL() -> String? {
        return image
    }
}

public extension String {
    func toImageEntity(context: NSManagedObjectContext) -> ImageEntity {
        let imageEntity = ImageEntity(context: context)
        imageEntity.image = self
        return imageEntity
    }
}
