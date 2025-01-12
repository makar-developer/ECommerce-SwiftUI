//
//  File.swift
//  
//
//  Created by Admin on 26/11/2024.
//

import SwiftUI

//  view to display when there are no users
// MARK: - EmptyListView

struct EmptyListView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.accentPrimary)
                .shadow(color: Color.borderColor.opacity(0.5), radius: 10, x: 0, y: 5)

            Text(String(localized: "No Accounts Added"))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .shadow(color: Color.borderColor.opacity(0.3), radius: 5, x: 0, y: 2)

            Text(String(localized: "Tap the button below to add a new account."))
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.backgroundSecondary)
                .shadow(color: Color.borderColor.opacity(0.5), radius: 10, x: 0, y: 5)
        )
        .padding()
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .background(Color.gray)
    }
}
