//
//  File.swift
//  
//
//  Created by Admin on 16/11/2024.
//

import Foundation
import WelcomeEntities
enum Feature: Identifiable, Hashable {
    case welcome
    case main(User)
    
    var id: String {
        switch self {
        case .welcome:
            return "welcome"
        case .main(let user):
            return user.id.uuidString
        }
    }
}
