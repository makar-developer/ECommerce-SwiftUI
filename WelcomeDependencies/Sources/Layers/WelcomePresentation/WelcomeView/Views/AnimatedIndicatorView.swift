//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

import SwiftUI

// MARK: - AnimatedPageIndicatorView

public struct AnimatedPageIndicatorView: View {
    var numberOfDots: Int
    var dotRadius: CGFloat = 20.0
    var dotSpacing: CGFloat = 40.0
    var currentProgress: Double

    public var body: some View {
        GeometryReader { geometry in
            let totalWidth = CGFloat(numberOfDots - 1) * dotSpacing + dotRadius * 2
            let startX = (geometry.size.width - totalWidth) / 2

            ZStack {
                // Inactive dots (red) with adjusted opacity
                ForEach(0..<numberOfDots, id: \.self) { dotIndex in
                    let dotCenterX = startX + CGFloat(dotIndex) * dotSpacing + dotRadius
                    let activeDotCenterX = getActiveDotCenterX(startX: startX)
                    let distance = abs(dotCenterX - activeDotCenterX)
                    let opacity = min(1.0, distance / dotSpacing)

                    Circle()
                        .fill(Color.white)
                        .frame(width: dotRadius * 2, height: dotRadius * 2)
                        .position(x: dotCenterX, y: geometry.size.height / 2)
                        .opacity(opacity)
                }
                // Active dot (blue) and adjacent dot animation
                ActiveDotView(
                    numberOfDots: numberOfDots,
                    dotRadius: dotRadius,
                    dotSpacing: dotSpacing,
                    currentProgress: currentProgress,
                    startX: startX,
                    centerY: geometry.size.height / 2
                )
            }
        }
        .frame(height: dotRadius * 2)
        .frame(width: dotSpacing * CGFloat(numberOfDots))
    }

    func getActiveDotCenterX(startX: CGFloat) -> CGFloat {
        let progress = max(0.0, min(Double(numberOfDots - 1), currentProgress))
        let index = Int(progress)
        let fraction = progress - Double(index)

        let startCenterX = startX + CGFloat(index) * dotSpacing + dotRadius
        let endCenterX = startX + CGFloat(min(index + 1, numberOfDots - 1)) * dotSpacing + dotRadius
        let centerX = startCenterX + CGFloat(fraction) * (endCenterX - startCenterX)
        return centerX
    }
}

// MARK: - ActiveDotView

public struct ActiveDotView: View {
    var numberOfDots: Int
    var dotRadius: CGFloat
    var dotSpacing: CGFloat
    var currentProgress: Double
    var startX: CGFloat
    var centerY: CGFloat

    public var body: some View {
        let progress = max(0.0, min(Double(numberOfDots - 1), currentProgress))
        let index = Int(progress)
        let fraction = progress - Double(index)
        // Active dot (blue) position
        let startCenterX = startX + CGFloat(index) * dotSpacing + dotRadius
        let endCenterX = startX + CGFloat(min(index + 1, numberOfDots - 1)) * dotSpacing + dotRadius
        let activeCenterX = startCenterX + CGFloat(fraction) * (endCenterX - startCenterX)
        // Adjacent dot (red) position moving towards previous position
        var adjacentDotView: some View {
            if index < numberOfDots - 1 {
                let adjacentStartX = startX + CGFloat(index + 1) * dotSpacing + dotRadius
                let adjacentEndX = startX + CGFloat(index) * dotSpacing + dotRadius
                let adjacentCenterX = adjacentStartX - CGFloat(fraction) * (adjacentStartX - adjacentEndX)

                return AnyView(
                    Circle()
                        .fill(Color.white)
                        .frame(width: dotRadius * 2, height: dotRadius * 2)
                        .position(x: adjacentCenterX, y: centerY)
                )
            } else {
                return AnyView(EmptyView())
            }
        }

        return ZStack {
            // Active dot (blue) moving forward
            Circle()
                .fill(Color(hue: 0.08, saturation: 0.7, brightness: 0.9))
                .frame(width: dotRadius * 2, height: dotRadius * 2)
                .position(x: activeCenterX, y: centerY)

            // Adjacent inactive dot (red) moving towards previous position
            adjacentDotView
        }
    }
}
