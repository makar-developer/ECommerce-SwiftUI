//
//  WelcomeScreen.swift
//
//
//  Created by Admin on 17/11/2024.
//

import Foundation

enum WelcomeScreen: Identifiable, Hashable {
    case welcome
    case createAccount

    var id: String {
        switch self {
        case .welcome:
            return "welcome"
        case .createAccount:
            return "createAccount"
        }
    }
}
