//
//  CustomAsyncImage.swift
//
//
//  Created by Admin on 09/12/2024.
//

import CoreUseCases
import SwiftUI

public struct CustomAsyncImage<Placeholder: View>: View {
    @StateObject private var viewModel: CustomAsyncImageViewModel
    @Environment(\.screenWidth) var screenWidth
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
            Color(.gray)
                .opacity(0.1)
                .scaledToFit()
                .frame(height: screenWidth * 0.33)
            ProgressView()
        }
    }
}
