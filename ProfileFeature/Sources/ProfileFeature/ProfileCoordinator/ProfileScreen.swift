//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//

import CoreEntities

enum ProfileScreen: Identifiable, Hashable {
    case profile
    case changePassword(User)
    
    var id: String {
        switch self {
        case .profile:
            return "profile"
        case .changePassword(let user):
            return "changePassword_\(user.id)"
        }
    }
}
