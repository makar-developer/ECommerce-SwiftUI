//
//  File.swift
//  
//
//  Created by Admin on 09/12/2024.
//

import UIKit
import CoreUseCases
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
