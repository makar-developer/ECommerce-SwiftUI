//
//  CategoryResposne.swift
//
//
//  Created by Admin on 11/12/2024.
//

import Foundation

public struct CategoryResponse: Codable, Identifiable, Equatable, Hashable {
    public let id: UUID = .init() // Since the API doesn't provide an 'id', we generate one
    public let slug: String
    public let name: String
    public let url: String

    enum CodingKeys: String, CodingKey {
        case slug, name, url
    }
}
