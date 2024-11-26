//
//  File.swift
//  
//
//  Created by Admin on 17/11/2024.
//

import Foundation

enum WelcomeScreen: Identifiable, Hashable {
    case welcome
    
    var id: String {
        switch self {
        case .welcome:
            return "welcome"
        }
    }
}
