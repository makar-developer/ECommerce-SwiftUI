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
            }

            // HStack with rating, discountPercentage, and stock
            HStack(spacing: 16) {
                // Rating
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.accentPrimary)
                    Text(String(format: "%.1f", viewModel.product.rating))
                }

                // Discount Percentage
                HStack {
                    Image(systemName: "percent")
                        .foregroundColor(Color.accentPrimary)
                    Text("\(viewModel.product.discountPercentage, specifier: "%.0f")% off")
                }

                // Stock
                HStack {
                    Image(systemName: "cube.box.fill")
                        .foregroundColor(Color.accentPrimary)
                    Text("Stock: \(viewModel.product.stock)")
                }
            }
            .font(.subheadline)

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
                    .foregroundColor(Color.textSecondary)

                Spacer()

                // Add to Cart button at the bottom right
                Button(action: {
                    viewModel.addToCart()
                }) {
                    Text("Add to Cart")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.textPrimary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.accentPrimary)
                        .cornerRadius(10)
                }
            }
            .padding()
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
                            .foregroundColor(Color.accentPrimary)
                        Text("Back")
                            .foregroundColor(Color.accentPrimary)
                    }
                }
            }
        }
        .task {
            await viewModel.addProductToHistory()
        }
        .background(Color.backgroundPrimary)
    }
}
