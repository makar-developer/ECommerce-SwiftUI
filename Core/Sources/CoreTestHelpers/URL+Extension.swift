//
//  File.swift
//  
//
//  Created by Admin on 12/01/2025.
//

import Foundation

public extension URL {
    static func getOneOfThis() -> URL {
        return URL(string: "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png")!
    }
    
    static func getAnArrayOfThese() -> [URL] {
        return [
            URL(string: "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png")!,
            URL(string: "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png")!,
            URL(string: "https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png")!
        ]
    }
}
