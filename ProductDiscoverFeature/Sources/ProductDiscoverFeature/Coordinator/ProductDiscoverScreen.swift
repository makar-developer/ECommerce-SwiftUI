//
//  File.swift
//  
//
//  Created by Admin on 29/11/2024.
//


enum ProductDiscoverScreen: Identifiable, Hashable {
    case productDiscover
    
    var id: String {
        switch self {
        case .productDiscover:
            return "productDiscover"
        }
    }
}
