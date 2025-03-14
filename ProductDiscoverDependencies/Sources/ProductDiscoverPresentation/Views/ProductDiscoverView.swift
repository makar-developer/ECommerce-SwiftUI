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
        // Wrap your content in ScrollView again if you want to preserve the existing layout
        ScrollView {
            GeometryReader { scrollViewProxy in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: scrollViewProxy.frame(in: .global).minY)
            }
            .frame(height: 0)
            
            VStack(alignment: .leading, spacing: 5) {
                
                // Hot Sales Section
                Text(String(localized: "Hot Sales"))
                    .font(.title)
                    .foregroundColor(Color.accentSecondary)
                    .padding(.leading)
                LoadableScreen($viewModel.hotSalesState) { hotSalesProducts in
                    if !hotSalesProducts.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(hotSalesProducts) { product in
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
                }
                
                // Recommended Products Section
                Text(String(localized: "Recommended for You"))
                    .font(.title)
                    .foregroundColor(Color.accentSecondary)
                    .padding(.leading)
                
                LoadableScreen($viewModel.recommendedState) { recommendedProducts in
                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                        ForEach(recommendedProducts) { product in
                            ProductCardView(
                                product: product,
                                onNavigation: { product in
                                    viewModel.showProductDetails(product: product)
                                },
                                getImageUseCase: viewModel.getImageUseCase
                            )
                        }
                        // Trigger next page load when scrolled into view
                        Color.clear
                            .frame(height: 1)
                            .onAppear {
                                viewModel.loadRecommendedProducts()
                            }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.backgroundPrimary)
            // Track content height
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
    }
    
    private func checkIfNeedToLoadMore() {
        let threshold: CGFloat = 100
        let scrollViewBottomOffset = contentHeight + scrollOffset - scrollViewHeight
        if scrollViewBottomOffset < threshold {
            viewModel.loadRecommendedProducts()
        }
    }
}

