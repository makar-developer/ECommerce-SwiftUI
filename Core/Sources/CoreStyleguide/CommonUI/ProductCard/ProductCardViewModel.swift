//
//  File.swift
//  
//
//  Created by Admin on 08/12/2024.
//

import UIKit
import CoreUseCases
import CoreEntities
public final class ProductCardViewModel: ObservableObject {
    @Published var image: UIImage?
    let product: Product

    private let getImageUseCase: GetImageUseCaseProtocol

    public init(product: Product, getImageUseCase: GetImageUseCaseProtocol) {
        self.product = product
        self.getImageUseCase = getImageUseCase
    }

    @MainActor
    func loadImage() async {
        guard image == nil, let url = URL(string: product.thumbnail) else { return }
        do {
            self.image = try await getImageUseCase.execute(url: url)
        } catch {
            // Handle error (e.g., set a default image or log the error)
            print("Failed to load image: \(error)")
        }
    }
}
