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
