//
//  EnvironmentKeys.swift
//
//
//  Created by Admin on 20/11/2024.
//

import SwiftUI

// Environment Key for Safe Area Insets
public struct ScreenWidthKey: EnvironmentKey {
    public static var defaultValue: CGFloat {
        if let keyWindow = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return keyWindow.screen.bounds.width
        } else {
            return CGFloat()
        }
    }
}

public struct ScreenHeigthKey: EnvironmentKey {
    public static var defaultValue: CGFloat {
        if let keyWindow = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return keyWindow.screen.bounds.height
        } else {
            return CGFloat()
        }
    }
}

public extension EnvironmentValues {
    var screenWidth: CGFloat {
        self[ScreenWidthKey.self]
    }

    var screenHeight: CGFloat {
        self[ScreenWidthKey.self]
    }
}
