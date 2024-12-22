//
//  File.swift
//  
//
//  Created by Admin on 22/12/2024.
//

import SwiftUI
public extension Color {
    // Accent colors used for interactive elements like buttons, icons, and highlights
    // Golden Amber (#C17B56) - Dark
    // Caramel Gold (#D6A372) - Light
    static let accentPrimary       = Color("accentPrimary", bundle: .module)       // Primary accent color, e.g., main buttons or key interactive elements

    // Soft Copper (#A66A4A) - Dark
    // Burnt Sienna (#C17B56) - Light
    static let accentSecondary     = Color("accentSecondary", bundle: .module)     // Secondary accent color, e.g., less prominent buttons or hover states

    // Background colors for the app's overall layout
    // Deep Mocha (#2A1F1B) - Dark
    // Sunlit Beige (#F4D8C4) - Light
    static let backgroundPrimary   = Color("backgroundPrimary", bundle: .module)   // Main background color, e.g., app's primary screens or views

    // Dark Chocolate (#3B2E28) - Dark
    // Golden Sand (#EAC7A8) - Light
    static let backgroundSecondary = Color("backgroundSecondary", bundle: .module) // Secondary background color, e.g., cards, modals, or contrasting sections

    // Border and divider colors
    // Coffee Cream (#4A3B36) - Dark
    // Muted Almond (#E2D6CD) - Light
    static let borderColor         = Color("borderColor", bundle: .module)         // Color for borders, dividers, and separators between elements

    // Error colors for states or feedback
    // Brick Red (#B23A2F) - Light
    // Crimson Red (#8A2E25) - Dark
    static let errorColor          = Color("errorColor", bundle: .module)          // Bright error color, e.g., error messages, alerts, or invalid inputs

    // Success colors for positive states or feedback
    // Bright Green (#28A745) - Light
    // Forest Green (#1E7B34) - Dark
    static let successColor        = Color("successColor", bundle: .module)        // Bright success color, e.g., success messages, confirmation states

    // Text colors for content readability
    // Cream White (#FDF6EE) - Dark
    // Rich Espresso (#4B3A34) - Light
    static let textPrimary         = Color("textPrimary", bundle: .module)         // Primary text color, e.g., headers, main content

    // Caramel Mist (#D6A372) - Dark
    // Soft Taupe (#8D7B74) - Light
    static let textSecondary       = Color("textSecondary", bundle: .module)       // Secondary text color, e.g., subtitles, secondary information
    // Black - Light
    // White - Dark
    static let textBackground       = Color("textBackground", bundle: .module)       // Could be used to create e.g. capsule on text's background for contrast
}


