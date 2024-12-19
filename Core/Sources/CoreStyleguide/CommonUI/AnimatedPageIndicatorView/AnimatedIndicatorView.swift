//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

import SwiftUI

// MARK: - AnimatedPageIndicatorView

public struct AnimatedPageIndicatorView: View {
    public init(numberOfDots: Int, dotRadius: Double, dotSpacing: Double, currentProgress: Double) {
        
        self.numberOfDots = numberOfDots
        self.dotRadius = dotRadius
        self.dotSpacing = dotSpacing
        self.currentProgress = currentProgress
    }
    // Identical input parameters to the UIKit version:
    let numberOfDots: Int
    let dotRadius: Double
    let dotSpacing: Double
    let currentProgress: Double
    
    
    public var body: some View {
            ZStack {
                GeometryReader { proxy in
                    // 1) Safely clamp progress to [0, numberOfDots - 1]
                    let clampedProgress: Double = max(0, min(Double(numberOfDots - 1), currentProgress))
                    
                    // 2) Decompose into integer index + fractional portion
                    let index: Int = Int(clampedProgress)
                    let fraction: Double = clampedProgress - Double(index)
                    
                    // 3) Total horizontal space: (N-1)*dotSpacing + diameter(=2*dotRadius)
                    let totalWidth: CGFloat = CGFloat(numberOfDots - 1) * CGFloat(dotSpacing)
                    + CGFloat(dotRadius) * 2
                    
                    // 4) The leftmost dot’s starting X so the row is centered
                    let startX: CGFloat = (proxy.size.width - totalWidth) / 2
                    
                    // 5) Convert arguments to CGFloats for geometry
                    let dotR: CGFloat = CGFloat(dotRadius)
                    let dotS: CGFloat = CGFloat(dotSpacing)
                    let containerHeight: CGFloat = proxy.size.height
                    
                    ZStack {
                        // A) Draw all “stationary” red dots, skipping:
                        //    • Dot 0 if the active dot is at or moving from index=0
                        //    • Dot i where i == index (occupied by blue)
                        //    • Dot i where i == index+1 (the neighbor, drawn separately)
                        ForEach(0..<numberOfDots, id: \.self) { i in
                            stationaryRedDotView(
                                i: i,
                                index: index,
                                fraction: fraction,
                                numberOfDots: numberOfDots,
                                dotRadius: dotR,
                                dotSpacing: dotS,
                                startX: startX,
                                containerHeight: containerHeight
                            )
                        }
                        
                        // B) The active (blue) dot
                        activeBlueDotView(
                            index: index,
                            fraction: fraction,
                            numberOfDots: numberOfDots,
                            dotRadius: dotR,
                            dotSpacing: dotS,
                            startX: startX,
                            containerHeight: containerHeight
                        ).zIndex(1)
                        
                        // C) The “neighbor” red dot from index+1 → index
                        neighborRedDotView(
                            index: index,
                            fraction: fraction,
                            numberOfDots: numberOfDots,
                            dotRadius: dotR,
                            dotSpacing: dotS,
                            startX: startX,
                            containerHeight: containerHeight
                        )
                    }
                }
                .frame(height: CGFloat(dotRadius) * 2 + 20) // Enough height to avoid clipping
            }
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: (dotSpacing * Double(numberOfDots)) + (dotRadius * 2 * Double(numberOfDots)))
            )
        }
    
    // MARK: - Subviews
    
    // 1) Renders a single stationary red dot “i” unless it’s hidden.
    private func stationaryRedDotView(
        i: Int,
        index: Int,
        fraction: Double,
        numberOfDots: Int,
        dotRadius: CGFloat,
        dotSpacing: CGFloat,
        startX: CGFloat,
        containerHeight: CGFloat
    ) -> some View {
        
        // Conditions to skip:
        // (a) i == index → that position is occupied by the blue dot
        // (b) i == index+1 (and index < last) → that’s the “neighbor” dot drawn separately
        // (c) i == 0 if the active dot is “still at or between” 0→1.
        //     i.e., index=0 or fraction>0 means blue dot hasn’t left 0 yet.
        
        // Implement (c): hide i=0 only if index=0 AND fraction<1
        let shouldHideDot0: Bool = (i == 0 && index == 0 && fraction < 1.0)
        
        // Combine skip conditions:
        let skipBluePosition  = (i == index)
        let skipNeighbor      = (i == index + 1 && index < numberOfDots - 1)
        
        if skipBluePosition || skipNeighbor || shouldHideDot0 {
            return AnyView(EmptyView())
        } else {
            // Position for stationary dot i
            let centerX: CGFloat = startX + CGFloat(i) * dotSpacing + dotRadius
            return AnyView(
                Circle()
                    .fill(Color.white)
                    .frame(width: dotRadius * 2, height: dotRadius * 2)
                    .position(x: centerX, y: containerHeight / 2)
            )
        }
    }
    
    // 2) Active (blue) dot interpolation from “index” → “index+1.”
    private func activeBlueDotView(
        index: Int,
        fraction: Double,
        numberOfDots: Int,
        dotRadius: CGFloat,
        dotSpacing: CGFloat,
        startX: CGFloat,
        containerHeight: CGFloat
    ) -> some View {
        
        // If index is the last dot, we don’t move anywhere
        let safeIndex: Int = min(index, numberOfDots - 1)
        let safeIndexPlusOne: Int = min(index + 1, numberOfDots - 1)
        
        let startCenterX: CGFloat = startX + CGFloat(safeIndex) * dotSpacing + dotRadius
        let endCenterX: CGFloat   = startX + CGFloat(safeIndexPlusOne) * dotSpacing + dotRadius
        
        let fractionAdjustment: CGFloat = (index == numberOfDots - 1) ? 0 : CGFloat(fraction)
        let blueCenterX: CGFloat = startCenterX + fractionAdjustment * (endCenterX - startCenterX)
        
        return Circle()
            .fill(Color(hue: 0.08, saturation: 0.7, brightness: 0.9))
            .frame(width: dotRadius * 2, height: dotRadius * 2)
            .position(x: blueCenterX, y: containerHeight / 2)
    }
    
    // 3) Red “neighbor” dot at index+1, which moves backward to index.
    private func neighborRedDotView(
        index: Int,
        fraction: Double,
        numberOfDots: Int,
        dotRadius: CGFloat,
        dotSpacing: CGFloat,
        startX: CGFloat,
        containerHeight: CGFloat
    ) -> some View {
        
        // If index < last dot, there’s a neighbor to the right:
        if index < numberOfDots - 1 {
            let neighborStartX: CGFloat = startX + CGFloat(index + 1) * dotSpacing + dotRadius
            let neighborEndX: CGFloat   = startX + CGFloat(index)     * dotSpacing + dotRadius
            let dx: CGFloat = neighborStartX - neighborEndX
            let neighborCenterX: CGFloat = neighborStartX - CGFloat(fraction) * dx
            
            return Circle()
                .fill(Color.white)
                .frame(width: dotRadius * 2, height: dotRadius * 2)
                .position(x: neighborCenterX, y: containerHeight / 2)
                .eraseToAnyView()
        } else {
            // If index==last, no neighbor
            return EmptyView().eraseToAnyView()
        }
    }
}

extension View {
    // Helper for bridging a View to AnyView
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
