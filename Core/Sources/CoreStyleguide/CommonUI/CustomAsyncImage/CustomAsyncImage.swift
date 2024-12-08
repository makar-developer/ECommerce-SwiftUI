//
//  File.swift
//  
//
//  Created by Admin on 09/12/2024.
//

import SwiftUI
import CoreUseCases

struct CustomAsyncImage<Placeholder: View>: View {
    @StateObject private var loader: CustomAsyncImageViewModel
    private let placeholder: Placeholder
    private let image: (Image) -> Image

    init(
        url: URL,
        getImageUseCase: GetImageUseCaseProtocol,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> Image = { $0 }
    ) {
        _loader = StateObject(wrappedValue: CustomAsyncImageViewModel(url: url, getImageUseCase: getImageUseCase))
        self.placeholder = placeholder()
        self.image = image
    }

    var body: some View {
        content.onAppear(perform: loader.load)
    }

    @ViewBuilder
    private var content: some View {
        if let uiImage = loader.uiImage {
            image(Image(uiImage: uiImage).resizable())
        } else if loader.isLoading {
            placeholder
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
        }
    }
}
