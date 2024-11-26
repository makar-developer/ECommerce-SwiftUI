//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

import SwiftUI
import WelcomeEntities
// MARK: - SnapCarousel

public struct SnapCarousel<Content: View>: View {
    let data: [User]
    @Binding var currentIndex: Int // Bind the current index
    let content: (User) -> Content
    
    let createAccount: () -> Void

    // State variables
    @GestureState private var dragOffset: CGFloat = 0
    @State private var firstViewOffset: CGFloat = 0
    @State private var currentProgress: Double = 0.0

    // Constants
    @Environment(\.screenWidth) var screenWidth
    @Environment(\.screenHeight) var screenHeight
    private let spacing: CGFloat = 16
    private var cardWidth: CGFloat {
        screenWidth * 0.8
    }

    private let swipeThreshold: CGFloat = 50 // Adjust based on testing

    public var body: some View {
        GeometryReader { geometry in
            let totalWidth = cardWidth + spacing
            let offsetX = (-CGFloat(currentIndex) * totalWidth) + dragOffset

            VStack(spacing: 20) {
                if data.isEmpty {
                    // Display the empty list view when there are no users
                    EmptyListView()
                        .frame(width: cardWidth, height: geometry.size.height * 0.8)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                } else {
                    // Carousel content
                    HStack(spacing: spacing) {
                        ForEach(data.indices, id: \.self) { index in
                            content(data[index])
                                .frame(width: cardWidth, height: geometry.size.height * 0.8)
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
                                let translationWidth = value.translation.width
                                if (currentIndex == 0 && translationWidth > 0) || (currentIndex == data.count - 1 && translationWidth < 0) {
                                    state = 0 // Prevent any movement
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
                                    if currentIndex < data.count - 1 {
                                        currentIndex += 1
                                    }
                                } else if dragDistance > swipeThreshold || predictedEndOffset > swipeThreshold {
                                    // Swipe Right - Move to previous item
                                    if currentIndex > 0 {
                                        currentIndex -= 1
                                    }
                                }
                            }
                    )
                    .animation(.easeOut, value: currentIndex)
                    .onAppear {
                        // Initial animation to bring in the first view
                        firstViewOffset = -geometry.size.height * 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeIn(duration: 0.5)) {
                                firstViewOffset = 0
                            }
                        }
                        
                        // Initialize currentProgress
                        currentProgress = Double(currentIndex)
                    }
                    
                    // Animated Page Indicator only shown when there are users
                    if !data.isEmpty {
                        AnimatedPageIndicatorView(
                            numberOfDots: data.count,
                            dotRadius: 6.0,
                            dotSpacing: 19.0,
                            currentProgress: currentProgress
                        )
                        .padding(16)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(30)
                    }
                }
                // Button to add an account
                Button(action: {
                    createAccount()
                }) {
                    Text("Add account")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(Color(hue: 0.1, saturation: 0.3, brightness: 0.7))
                        .cornerRadius(20)
                }
                .padding(.bottom, 20)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .padding(.horizontal, (screenWidth - cardWidth) / 2)
        .background(Color(hue: 0.1, saturation: 0.3, brightness: 0.95))
    }
}
