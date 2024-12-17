import SwiftUI
import Core
public struct ProductDetailsView: View {
    
    @StateObject var viewModel: ProductDetailsViewModel
    @Environment(\.screenHeight) var screenHeight
    public init(viewModel: ProductDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ProductSnapCarousel for product images
            ProductSnapCarousel(
                images: viewModel.product.images,
                currentIndex: $viewModel.currentImageIndex
            )
            .frame(height: screenHeight * 0.5)  // Adjust the height as needed

            // Title and brand
            Text(viewModel.product.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            if let brand = viewModel.product.brand {
                Text(brand)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // HStack with rating, discountPercentage, and stock
            HStack(spacing: 16) {
                // Rating
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", viewModel.product.rating))
                }

                // Discount Percentage
                HStack {
                    Image(systemName: "percent")
                    Text("\(viewModel.product.discountPercentage, specifier: "%.0f")% off")
                }

                // Stock
                HStack {
                    Image(systemName: "cube.box.fill")
                    Text("Stock: \(viewModel.product.stock)")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)

            // Description
            Text(viewModel.product.description)
                .font(.body)

            Spacer()

            // Price and Add to Cart button
            HStack {
                // Price at the bottom left
                Text("$\(viewModel.product.price, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                // Add to Cart button at the bottom right
                Button(action: {
                    viewModel.addToCart()
                }) {
                    Text("Add to Cart")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle("Product Details")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.onNavigation()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .task {
            await viewModel.addProductToHistory()
        }
    }
}

import SwiftUI

public struct ProductSnapCarousel: View {
    let images: [String]
    @Binding var currentIndex: Int  // Bind the current index

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

    private let swipeThreshold: CGFloat = 50  // Adjust based on testing

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

                    // ProductAnimatedPageIndicatorView
                    if images.count > 1 {
                        ProductAnimatedPageIndicatorView(
                            numberOfDots: images.count,
                            dotRadius: 5, // Adjusted to match your example
                            dotSpacing: 20, // Adjusted to match your example
                            currentProgress: currentProgress
                        )
                        .padding(16)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(30)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .padding(.horizontal, (screenWidth - cardWidth) / 2)
    }
}

import SwiftUI

private struct OffsetObservingModifier: AnimatableModifier {
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

import SwiftUI

public struct ProductAnimatedPageIndicatorView: View {
    var numberOfDots: Int
    var dotRadius: CGFloat
    var dotSpacing: CGFloat
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
                ProductActiveDotView(
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

import SwiftUI

public struct ProductActiveDotView: View {
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
