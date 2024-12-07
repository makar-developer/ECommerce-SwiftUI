//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import SwiftUI
import Core
import CoreEntities
import CoreRepositories
public struct ProductCardView: View {
    let product: Product
    let onNavigation: (Product) -> Void
    let imageCache: DiskImageCache

    @Environment(\.screenWidth) private var screenWidth

    public init(product: Product, onNavigation: @escaping (Product) -> Void, imageCache: DiskImageCache) {
        self.product = product
        self.onNavigation = onNavigation
        self.imageCache = imageCache
    }

    public var body: some View {
        VStack(alignment: .center) {
            // Image
            if let url = URL(string: product.thumbnail) {
                CustomAsyncImage(
                    url: url,
                    cache: imageCache,
                    placeholder: {
                        ProgressView()
                            .frame(height: screenWidth * 0.33)
                    },
                    image: { image in
                        image
//
                            
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

struct CustomAsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (Image) -> Image

    init(
        url: URL,
        cache: DiskImageCache,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> Image = { $0 }
    ) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: cache))
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

class ImageLoader: ObservableObject {
    @Published var uiImage: UIImage?
    @Published var isLoading = false

    private let url: URL
    private let cache: DiskImageCache
    private let session: URLSession
    private let maxRetries = 3

    init(url: URL, cache: DiskImageCache, session: URLSession = .shared) {
        self.url = url
        self.cache = cache
        self.session = session
    }

    func load() {
        if let cachedImage = cache.image(for: url) {
            self.uiImage = cachedImage
            return
        }
        fetchImage(retries: maxRetries)
    }

    private func fetchImage(retries: Int) {
        guard retries > 0 else { return }

        isLoading = true
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)

        session.dataTask(with: request) { data, response, error in
            defer { DispatchQueue.main.async { self.isLoading = false } }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uiImage = image
                }
                self.cache.save(image, for: self.url)
            } else {
                // Retry after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.fetchImage(retries: retries - 1)
                }
            }
        }.resume()
    }
}
