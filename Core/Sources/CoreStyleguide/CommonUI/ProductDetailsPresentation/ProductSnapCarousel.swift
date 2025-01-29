//
//  File.swift
//  
//
//  Created by Admin on 19/12/2024.
//

import SwiftUI

public struct ProductSnapCarousel: View {
    let images: [String]
    @Binding var currentIndex: Int

    // State variables
    @GestureState private var dragOffset: CGFloat = 0
    @State private var firstViewOffset: CGFloat = 0
    @State private var currentProgress: Double = 0.0

    // Constants
    private let spacing: CGFloat = 16
    @Environment(\.screenWidth) var screenWidth
    private var cardWidth: CGFloat {
        screenWidth * 0.8
    }

    private let swipeThreshold: CGFloat = 150  // Adjust based on testing

    public var body: some View {
        GeometryReader { geometry in
            let totalWidth = cardWidth + spacing
            let offsetX = (-CGFloat(currentIndex) * totalWidth) + dragOffset

            VStack(spacing: 20) {
                if images.isEmpty {
                    // Display a placeholder when there are no images
                    Color.gray
                        .frame(width: cardWidth, height: geometry.size.height * 0.8)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                } else {
                    // Carousel content
                    HStack(spacing: spacing) {
                        ForEach(images.indices, id: \.self) { index in
                            AsyncImage(url: URL(string: images[index])) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ZStack {
                                    ProgressView()
                                    Color.gray.opacity(0.3)
                                }
                            }
                            .frame(width: cardWidth, height: geometry.size.height * 0.8)
                            .clipped()
                            .cornerRadius(30)
                            .shadow(radius: 5)
                            .offset(y: index == 0 ? firstViewOffset : 0)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.8, alignment: .leading)
                    .offset(x: offsetX)
                    .modifier(OffsetObservingModifier(offset: offsetX) { newOffset in
                        // Update currentProgress based on the new offset
                        let progress = (-newOffset) / totalWidth
                        currentProgress = Double(progress)
                    })
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                let fraction = -state / screenWidth
                                let provisional = Double(currentIndex) + Double(fraction)
                                
                                // Keep it in [0, data.count - 1]
                                DispatchQueue.main.async {
                                    currentProgress = max(0,
                                                             min(Double(images.count - 1), provisional))
                                }
                                let translationWidth = value.translation.width
                                if (currentIndex == 0 && translationWidth > 0) ||
                                    (currentIndex == images.count - 1 && translationWidth < 0) {
                                    state = 0  // Prevent any movement
                                } else {
                                    state = translationWidth
                                }
                            }
                            .onEnded { value in
                                let dragDistance = value.translation.width
                                let predictedEndOffset = dragDistance + (value.predictedEndLocation.x - value.location.x)

                                if dragDistance < -swipeThreshold ||
                                    predictedEndOffset < -swipeThreshold {
                                    // Swipe Left - Move to next item
                                    if currentIndex < images.count - 1 {
                                        currentIndex += 1
                                    }
                                } else if dragDistance > swipeThreshold ||
                                            predictedEndOffset > swipeThreshold {
                                    // Swipe Right - Move to previous item
                                    if currentIndex > 0 {
                                        currentIndex -= 1
                                    }
                                }
                            }
                    )
                    .animation(.easeOut, value: currentIndex)
                    .onAppear {
                        // Initialize currentProgress
                        currentProgress = Double(currentIndex)
                    }
                    if images.count > 1 {
                        AnimatedPageIndicatorView(numberOfDots: images.count, dotRadius: 6, dotSpacing: 30, currentProgress: currentProgress)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .padding(.horizontal, (screenWidth - cardWidth) / 2)
    }
}
