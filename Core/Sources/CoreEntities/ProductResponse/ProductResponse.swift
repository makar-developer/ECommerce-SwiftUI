//
//  File 2.swift
//  
//
//  Created by Admin on 02/12/2024.
//

public struct ProductResponse: Decodable {
    public let products: [Product]
    public let total: Int
    public let skip: Int
    public let limit: Int
}
