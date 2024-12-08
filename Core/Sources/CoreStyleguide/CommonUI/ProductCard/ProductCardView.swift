//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import SwiftUI
import Core
import CoreEntities
import CoreUseCases
import CoreRepositories
public struct ProductCardView: View {
    let product: Product
    let onNavigation: (Product) -> Void
    let getImageUseCase: GetImageUseCaseProtocol

    @Environment(\.screenWidth) private var screenWidth

    public init(product: Product, onNavigation: @escaping (Product) -> Void, getImageUseCase: GetImageUseCaseProtocol) {
        self.product = product
        self.onNavigation = onNavigation
        self.getImageUseCase = getImageUseCase
    }

    public var body: some View {
        VStack(alignment: .center) {
            // Image
            if let url = URL(string: product.thumbnail) {
                CustomAsyncImage(
                    url: url,
                    getImageUseCase: getImageUseCase,
                    placeholder: {
                        ProgressView()
                            .frame(height: screenWidth * 0.33)
                    },
                    image: { image in
                        image
                    }
                )
                .scaledToFit()
                .frame(height: screenWidth * 0.33)
                .clipped()
                .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenWidth * 0.33)
            }

            // Title
            Text(product.title)
                .font(.headline)
                .lineLimit(1)
            // Description
            Text(product.description)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundColor(.secondary)
            // Rating and Price
            HStack {
                Label("\(product.rating, specifier: "%.1f")", systemImage: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.subheadline)
                Spacer()
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .onTapGesture {
            onNavigation(product)
        }
    }
}

import SwiftUI

class CustomAsyncImageViewModel: ObservableObject {
    @Published var uiImage: UIImage?
    @Published var isLoading = false

    private let url: URL
    private let getImageUseCase: GetImageUseCaseProtocol
    private let maxRetries = 3

    init(url: URL, getImageUseCase: GetImageUseCaseProtocol) {
        self.url = url
        self.getImageUseCase = getImageUseCase
    }

    func load() {
        Task {
            await fetchImage(retries: maxRetries)
        }
    }

    @MainActor
    private func fetchImage(retries: Int) async {
        guard retries > 0 else { return }

        isLoading = true
        do {
            let image = try await getImageUseCase.execute(url: url)
            self.uiImage = image
        } catch {
            // Retry after a delay
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await fetchImage(retries: retries - 1)
        }
        isLoading = false
    }
}

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
//struct CustomAsyncImage<Placeholder: View>: View {
//    @StateObject private var loader: ImageLoader
//    private let placeholder: Placeholder
//    private let image: (Image) -> Image
//
//    init(
//        url: URL,
//        cache: DiskImageCacheeProtocol,
//        @ViewBuilder placeholder: () -> Placeholder,
//        @ViewBuilder image: @escaping (Image) -> Image = { $0 }
//    ) {
//        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: cache))
//        self.placeholder = placeholder()
//        self.image = image
//    }
//
//    var body: some View {
//        content.onAppear(perform: loader.load)
//    }
//
//    @ViewBuilder
//    private var content: some View {
//        if let uiImage = loader.uiImage {
//            image(Image(uiImage: uiImage).resizable())
//        } else if loader.isLoading {
//            placeholder
//        } else {
//            Image(systemName: "photo")
//                .resizable()
//                .scaledToFit()
//        }
//    }
//}
//
//class ImageLoader: ObservableObject {
//    @Published var uiImage: UIImage?
//    @Published var isLoading = false
//
//    private let url: URL
//    private let cache: DiskImageCacheeProtocol
//    private let session: URLSession
//    private let maxRetries = 3
//
//    init(url: URL, cache: DiskImageCacheeProtocol, session: URLSession = .shared) {
//        self.url = url
//        self.cache = cache
//        self.session = session
//    }
//
//    func load() {
//        if let cachedImage = cache.image(for: url) {
//            self.uiImage = cachedImage
//            return
//        }
//        fetchImage(retries: maxRetries)
//    }
//
//    private func fetchImage(retries: Int) {
//        guard retries > 0 else { return }
//
//        isLoading = true
//        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
//
//        session.dataTask(with: request) { data, response, error in
//            defer { DispatchQueue.main.async { self.isLoading = false } }
//
//            if let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self.uiImage = image
//                }
//                self.cache.save(image, for: self.url)
//            } else {
//                // Retry after a delay
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    self.fetchImage(retries: retries - 1)
//                }
//            }
//        }.resume()
//    }
//}
