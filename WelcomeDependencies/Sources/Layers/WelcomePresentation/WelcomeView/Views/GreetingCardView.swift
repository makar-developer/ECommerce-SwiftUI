//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

import SwiftUI
import CoreEntities
// MARK: - GreetingCardView

public struct GreetingCardView: View {
    let user: User
    let imageName: String
    @Binding var isEditingModeEnabled: Bool
    @State private var showLogoutAlert = false
    let logoutAction: (User) -> Void
    let signInAction: (User) -> Void

    @Environment(\.screenHeight) var screenHeight
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            Image(imageName)
                .resizable()
                .scaledToFill()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.7)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(30)

            // Content Overlay
            VStack(alignment: .leading, spacing: 16) {
                Spacer()

                Text(String(localized: "Good afternoon, \(user.name.rawValue)!"))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .shadow(radius: 15)
                    .shadow(radius: 15)
                    .shadow(radius: 15)
                    .shadow(radius: 15)
                HStack(spacing: 10) {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .foregroundColor(.textPrimary)
                    Text(user.id.uuidString.prefix(7))
                        .font(.title2)
                        .foregroundColor(.textPrimary)
                }
                .font(.subheadline)

                Button(action: {
                    if isEditingModeEnabled {
                        showLogoutAlert = true
                    } else {
                        signInAction(user)
                    }
                }) {
                    Text(isEditingModeEnabled ? String(localized: "Log Out this Account") : String(localized: "Go Shopping!"))
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(
                            isEditingModeEnabled ? Color.errorColor : Color.accentPrimary
                        )
                        .cornerRadius(20)
                }
                .shadow(color: Color.borderColor.opacity(0.3), radius: 5, x: 0, y: 2)
                .padding(.bottom, 40)
                .alert(isPresented: $showLogoutAlert) {
                    Alert(
                        title: Text(String(localized: "Log Out")),
                        message: Text(String(localized: "Are you sure you want to log out of this account?")),
                        primaryButton: .destructive(Text(String(localized: "Log Out")), action: { logoutAction(user) }),
                        secondaryButton: .cancel(Text(String(localized: "Cancel")))
                    )
                }
            }
            .padding()
        }
        .frame(height: screenHeight * 1.25)
        .cornerRadius(30)
        .shadow(color: Color.borderColor.opacity(0.5), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.borderColor, lineWidth: 3)
        )
    }
}

struct GreetingCardView_Previews: PreviewProvider {

    static let user: User = User(name: UserName("DefaultUser1")!, login: Login("user1")!, password: Password("Password1@")!, profilePicture: nil)
    
    static var previews: some View {
        GreetingCardView(
            user: user,
            imageName: "image1",
            isEditingModeEnabled: .constant(false),
            logoutAction: { _ in },
            signInAction: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
