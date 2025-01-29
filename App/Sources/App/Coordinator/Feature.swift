//
//  File.swift
//  
//
//  Created by Admin on 16/11/2024.
//

import Foundation
import CoreEntities
enum Feature: Identifiable, Hashable {
    // Give each case a UUID to force re-init on reuse (e.g. log in -> log out -> log in again, but with another User)
    case welcome(UUID = UUID())
    case main(User, UUID = UUID())
    
    
    var id: UUID {
        switch self {
        case .welcome(let id):
            return id
        case .main(_, let id):
            return id
        }
    }
}
