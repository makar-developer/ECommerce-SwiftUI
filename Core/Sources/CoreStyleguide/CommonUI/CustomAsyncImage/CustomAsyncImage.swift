//
//  File.swift
//  
//
//  Created by Admin on 09/12/2024.
//

import SwiftUI
import CoreUseCases

public struct CustomAsyncImage<Placeholder: View>: View {
    @StateObject private var viewModel: CustomAsyncImageViewModel
    private let placeholder: Placeholder
    private let image: (Image) -> Image

    public init(
        url: URL,
        getImageUseCase: GetImageUseCaseProtocol,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> Image = { $0 }
    ) {
        _viewModel = StateObject(wrappedValue: CustomAsyncImageViewModel(url: url, getImageUseCase: getImageUseCase))
        self.placeholder = placeholder()
        self.image = image
    }

    public var body: some View {
        content.onAppear(perform: viewModel.load)
    }

    @ViewBuilder
    private var content: some View {
        if let uiImage = viewModel.uiImage {
            image(Image(uiImage: uiImage).resizable())
        } else if viewModel.isLoading {
            placeholder
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
        }
    }
}
