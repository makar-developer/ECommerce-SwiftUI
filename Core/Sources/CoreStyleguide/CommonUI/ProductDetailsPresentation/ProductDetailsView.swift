import SwiftUI
import Core
public struct ProductDetailsView: View {
    
    @StateObject var viewModel: ProductDetailsViewModel
    @Environment(\.screenHeight) var screenHeight
    public init(viewModel: ProductDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ProductSnapCarousel for product images
            ProductSnapCarousel(
                images: viewModel.product.images,
                currentIndex: $viewModel.currentImageIndex
            )
            .frame(height: screenHeight * 0.5)  // Adjust the height as needed

            // Title and brand
            Text(viewModel.product.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            if let brand = viewModel.product.brand {
                Text(brand)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // HStack with rating, discountPercentage, and stock
            HStack(spacing: 16) {
                // Rating
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", viewModel.product.rating))
                }

                // Discount Percentage
                HStack {
                    Image(systemName: "percent")
                    Text("\(viewModel.product.discountPercentage, specifier: "%.0f")% off")
                }

                // Stock
                HStack {
                    Image(systemName: "cube.box.fill")
                    Text("Stock: \(viewModel.product.stock)")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)

            // Description
            Text(viewModel.product.description)
                .font(.body)

            Spacer()

            // Price and Add to Cart button
            HStack {
                // Price at the bottom left
                Text("$\(viewModel.product.price, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                // Add to Cart button at the bottom right
                Button(action: {
                    viewModel.addToCart()
                }) {
                    Text("Add to Cart")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle("Product Details")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.onNavigation()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .task {
            await viewModel.addProductToHistory()
        }
    }
}

