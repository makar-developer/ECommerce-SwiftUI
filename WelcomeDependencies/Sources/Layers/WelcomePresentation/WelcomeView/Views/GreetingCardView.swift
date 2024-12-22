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

                Text("Good afternoon, \(user.name.rawValue)!")
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
                    Text(isEditingModeEnabled ? "Log Out this Account" : "Go Shopping")
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
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                .alert(isPresented: $showLogoutAlert) {
                    Alert(
                        title: Text("Log Out"),
                        message: Text("Are you sure you want to log out of this account?"),
                        primaryButton: .destructive(Text("Log Out"), action: { logoutAction(user) }),
                        secondaryButton: .cancel(Text("Cancel"))
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
