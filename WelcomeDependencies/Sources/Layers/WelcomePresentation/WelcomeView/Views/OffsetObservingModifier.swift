//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

import SwiftUI

// MARK: - OffsetObservingModifier

public struct OffsetObservingModifier: AnimatableModifier {
    // The offset to observe
    var offset: CGFloat
    var update: (CGFloat) -> Void
    // AnimatableData
    public var animatableData: CGFloat {
        get { offset }
        set {
            offset = newValue
            notify()
        }
    }

    private func notify() {
        DispatchQueue.main.async {
            self.update(self.offset)
        }
    }

    public func body(content: Content) -> some View {
        content
    }
}
