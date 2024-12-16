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
                    signInAction(user)
                }
            }) {
                Text(isEditingModeEnabled ? "Log out this account?" : "Go shopping!")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(
                        isEditingModeEnabled ? Color.red : Color(hue: 0.1, saturation: 0.3, brightness: 0.7)
                    )
                    .cornerRadius(20)
            }
            .padding(.top, 10)
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Log Out"),
                    message: Text("Are you sure you want to log out this account?"),
                    primaryButton: .destructive(Text("Log Out"), action: { logoutAction(user) }),
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
        .padding(16)
        .background(
            Image(imageName)
                .resizable()
                .scaledToFill()
        )
        .cornerRadius(30)
        .shadow(radius: 5)
    }
}
