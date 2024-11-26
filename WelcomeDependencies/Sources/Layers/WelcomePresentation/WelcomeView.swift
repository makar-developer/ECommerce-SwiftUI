import SwiftUI
import Core
import WelcomeEntities

// MARK: - WelcomeView

public struct WelcomeView: View {
    @StateObject private var viewModel: WelcomeViewModel
    @State private var currentIndex: Int = 0 // Track the current index

    public init(viewModel: WelcomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            SnapCarousel(data: viewModel.users, currentIndex: $currentIndex) { user in
                GreetingCardView(
                    user: user,
                    isEditingModeEnabled: $viewModel.isEditingModeEnabled,
                    showLogoutAlert: $viewModel.showLogoutAlert,
                    logoutAction: {
                        viewModel.logoutUser(user: user)
                        adjustCurrentIndexAfterDeletion()
                    }
                )
                .environmentObject(viewModel)
            }
            .toolbar {
                if !viewModel.users.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                viewModel.toggleEditingMode()
                            }
                        }) {
                            Image(systemName: viewModel.isEditingModeEnabled ? "arrow.backward" : "pencil")
                                .resizable()
                                .scaledToFit()
                                .imageScale(.large)
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.loadUsers()
        }
        .onChange(of: viewModel.users) { _ in
            adjustCurrentIndexAfterDeletion()
        }
    }

    /// Adjusts the currentIndex to ensure it's within the bounds of the users array.
    private func adjustCurrentIndexAfterDeletion() {
        DispatchQueue.main.async {
            if currentIndex >= viewModel.users.count {
                currentIndex = max(viewModel.users.count - 1, 0)
            }
        }
    }
}

// MARK: - GreetingCardView

public struct GreetingCardView: View {
    let user: User
    @Binding var isEditingModeEnabled: Bool
    @Binding var showLogoutAlert: Bool
    let logoutAction: () -> Void
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()

            Text("Good afternoon, \(user.name.rawValue)!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)

            HStack(spacing: 10) {
                Image(systemName: "person")
                    .foregroundColor(.white)
                Text(user.id.uuidString.prefix(7))
                    .foregroundColor(.white)
            }
            .font(.title3)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)

            Button(action: {
                if isEditingModeEnabled {
                    showLogoutAlert = true
                } else {
                    print("Go shopping!")
                }
            }) {
                Text(isEditingModeEnabled ? "Log out this account?" : "Go shopping!")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(isEditingModeEnabled ? Color.red : Color(hue: 0.1, saturation: 0.3, brightness: 0.7))
                    .cornerRadius(20)
            }
            .padding(.top, 10)
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Log Out"),
                    message: Text("Are you sure you want to log out this account?"),
                    primaryButton: .destructive(Text("Log Out"), action: logoutAction),
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
        .padding(16)
        .background(
            Image(user.image, bundle: Bundle.main)
                .resizable()
                .scaledToFill()
        )
        .cornerRadius(30)
        .shadow(radius: 5)
    }
}

// MARK: - SnapCarousel

public struct SnapCarousel<Content: View>: View {
    let data: [User]
    @Binding var currentIndex: Int // Bind the current index
    let content: (User) -> Content

    @Environment(\.screenWidth) var screenWidth
    @Environment(\.screenHeight) var screenHeight

    // State variables
    @GestureState private var dragOffset: CGFloat = 0
    @State private var firstViewOffset: CGFloat = 0
    @State private var currentProgress: Double = 0.0

    // Constants
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
                    print("Add account action here")
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
//  view to display when there are no users
// MARK: - EmptyListView

struct EmptyListView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white.opacity(1))
                .shadow(radius: 5)
            Text("No accounts added")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
                .shadow(radius: 5)

            Text("Tap the button below to add a new account")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(hue: 0.1, saturation: 0.3, brightness: 0.95)
                .ignoresSafeArea()
        )
    }
}
