//
//  File.swift
//  
//
//  Created by Admin on 03/12/2024.
//

import Foundation
import CoreEntities

public class ProductDetailsViewModel: ObservableObject {
    @Published var user: User
    @Published var product: Product
    @Published var currentImageIndex: Int = 0  // For the carousel

    public init(user: User, product: Product) {
        self.user = user
        self.product = product
    }
}
	
