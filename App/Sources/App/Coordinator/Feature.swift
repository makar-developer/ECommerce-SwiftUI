//
//  Feature.swift
//
//
//  Created by Admin on 16/11/2024.
//

import CoreEntities
import Foundation

enum Feature: Identifiable, Hashable {
    case welcome
    case main(User)

    var id: String {
        switch self {
        case .welcome:
            return "welcome"
        case let .main(user):
            return user.id.uuidString
        }
    }
}
