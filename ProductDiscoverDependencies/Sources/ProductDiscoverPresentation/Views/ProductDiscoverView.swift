//
//  File.swift
//  
//
//  Created by Admin on 02/12/2024.
//

import CoreEntities
import SwiftUI
import ProductDiscoverDomain
import Core
import CoreStyleguide

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0.0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
public struct ProductDiscoverView: View {
    @StateObject private var viewModel: ProductDiscoverViewModel
    @Environment(\.screenWidth) private var screenWidth
    @State private var scrollOffset: CGFloat = 0.0
    @State private var contentHeight: CGFloat = 0.0
    @State private var scrollViewHeight: CGFloat = 0.0

    public init(viewModel: ProductDiscoverViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            GeometryReader { scrollViewProxy in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: scrollViewProxy.frame(in: .global).minY)
            }
            .frame(height: 0)

            VStack(alignment: .leading, spacing: 5) {
                // Hot Sales Carousel
                if !viewModel.hotSalesProducts.isEmpty {
                    Text("Hot Sales")
                        .font(.title)
                        .foregroundColor(Color.accentSecondary)
                        .padding(.leading)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.hotSalesProducts) { product in
                                ProductCardView(
                                    product: product,
                                    onNavigation: { product in
                                        viewModel.showProductDetails(product: product)
                                    },
                                    getImageUseCase: viewModel.getImageUseCase
                                )
                                .frame(width: screenWidth * 0.5)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                    }
                }
                // Recommended Products
                Text("Recommended for You")
                    .font(.title)
                    .foregroundColor(Color.accentSecondary)
                    .padding(.leading)

                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                    ForEach(viewModel.recommendedProducts) { product in
                        ProductCardView(
                            product: product,
                            onNavigation: { product in
                                viewModel.showProductDetails(product: product)
                            },
                            getImageUseCase: viewModel.getImageUseCase
                        )
                    }

                    // Loading Next Page Indicator
                    if viewModel.isLoadingNextPage {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        // This view triggers loading more when it comes into view
                        Color.clear
                            .frame(height: 1)
                            .onAppear {
                                Task {
                                    await viewModel.loadRecommendedProducts()
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.backgroundPrimary)
            .background(
                GeometryReader { contentGeometryProxy in
                    Color.clear
                        .onAppear {
                            contentHeight = contentGeometryProxy.size.height
                        }
                        .onChange(of: contentGeometryProxy.size.height) { newValue in
                            contentHeight = newValue
                        }
                }
            )
        }
        .background(Color.backgroundPrimary)
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
            checkIfNeedToLoadMore()
        }
        .task {
            await viewModel.loadHotSalesProducts()
            await viewModel.loadRecommendedProducts()
        }
    }

    private func checkIfNeedToLoadMore() {
        // Calculate the threshold to trigger loading more content
        let threshold: CGFloat = 100
        let scrollViewBottomOffset = contentHeight + scrollOffset - scrollViewHeight

        if scrollViewBottomOffset < threshold {
            Task {
                await viewModel.loadRecommendedProducts()
            }
        }
    }
}

