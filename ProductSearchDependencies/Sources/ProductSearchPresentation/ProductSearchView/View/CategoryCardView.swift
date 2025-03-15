//
//  CategoryCardView.swift
//
//
//  Created by Admin on 19/12/2024.
//

import CoreStyleguide
import CoreUseCases
import ProductSearchEntities
import SwiftUI

struct CategoryCardView: View {
    let category: CategoryResponse
    let getImageUseCase: GetImageUseCaseProtocol
    let thumbnailUrl: String?

    @Environment(\.screenHeight) private var screenHeight

    var body: some View {
        VStack {
            if let thumbnailUrlString = thumbnailUrl,
               let url = URL(string: thumbnailUrlString)
            {
                CustomAsyncImage(
                    url: url,
                    getImageUseCase: getImageUseCase,
                    placeholder: {
                        ProgressView()
                    },
                    image: { image in
                        image
                    }
                )
                .scaledToFit()
                .clipped()
                .cornerRadius(8)
            } else {
                ZStack {
                    Color(.gray)
                        .opacity(0.1)
                        .scaledToFit()
                    ProgressView()
                }
            }

            Text(category.name)
                .font(.subheadline)
                .fontWeight(.bold)
                .lineLimit(1)
                .padding(.top, 5)
                .padding(.horizontal)
        }
        .frame(height: screenHeight * 0.6)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
