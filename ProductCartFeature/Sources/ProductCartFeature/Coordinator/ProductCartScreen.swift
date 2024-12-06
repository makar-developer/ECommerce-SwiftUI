//
//  File.swift
//  
//
//  Created by Admin on 05/12/2024.
//

import Foundation
import CoreEntities
enum ProductCartScreen: Identifiable, Hashable {
    case productCart
    var id: String {
        switch self {
        case .productCart:
            return "productCart"
        }
    }
}


