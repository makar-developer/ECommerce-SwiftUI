//
//  UIImage+Extension.swift
//
//
//  Created by Admin on 12/01/2025.
//

import UIKit

// This approach is used for simplicity. Normally images should've been accessible offline.
public extension UIImage {
    static func getOneOfThis() -> UIImage? {
        let url = URL.getOneOfThis()
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data)
        else {
            return nil
        }
        return image
    }

    static func getAnArrayOfThese() -> [UIImage] {
        let urls = URL.getAnArrayOfThese()
        var images: [UIImage] = []
        for url in urls {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data)
            {
                images.append(image)
            }
        }
        return images
    }
}
