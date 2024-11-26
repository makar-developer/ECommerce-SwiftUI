//
//  File.swift
//  
//
//  Created by Admin on 16/11/2024.
//

import Foundation

enum Feature: Identifiable, Hashable {
    case welcome
    
    var id: String {
        switch self {
        case .welcome:
            return "welcome"
        }
    }
}
