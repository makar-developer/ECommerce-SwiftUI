//
//  File.swift
//  
//
//  Created by Admin on 16/11/2024.
//

import Foundation
import CoreEntities
enum Feature: Identifiable, Hashable {
    case welcome(id: UUID)
    case main(User)
    
    var id: String {
        switch self {
        case .welcome(let id):
            return id.uuidString
        case .main(let user):
            return user.id.uuidString
        }
    }
}
