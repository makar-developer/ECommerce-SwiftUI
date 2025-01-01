//
//  File.swift
//  
//
//  Created by Admin on 17/12/2024.
//

import SwiftUI
import CoreUseCases
public struct ProductHistoryView: View {
    @StateObject private var viewModel: ProductHistoryViewModel

    public init(viewModel: ProductHistoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentPrimary))
                    .scaleEffect(1.5)
            } else if viewModel.productHistories.isEmpty {
                ZStack {
                    Color.backgroundPrimary
                    Text(String(localized: "No product history available."))
                        .foregroundColor(.textSecondary)
                        .font(.headline)
                        .padding()
                }
            } else {
                List {
                    ForEach(viewModel.productHistories) { history in
                        ProductHistoryRowView(
                            history: history,
                            getImageUseCase: viewModel.getImageUseCase,
                            onSelect: {
                                viewModel.selectProduct(history.product)
                            },
                            onDelete: {
                                viewModel.removeProductHistory(history)
                            }
                        )
                        .listRowBackground(Color.backgroundSecondary)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.backToProfile()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.accentPrimary)
                        Text(String(localized: "Back"))
                            .foregroundColor(.accentPrimary)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.productHistories.isEmpty {
                    Button(String(localized: "Clear")) {
                        viewModel.clearHistory()
                    }
                    .foregroundColor(.errorColor)
                }
            }
        }
        .navigationTitle(String(localized: "Product History"))
        .background(Color.backgroundPrimary)
        .task {
            await viewModel.loadHistory()
        }
        .alert(item: $viewModel.errorMessage) { error in
            Alert(
                title: Text(String(localized: "Error")),
                message: Text(error.message),
                dismissButton: .default(Text(String(localized: "OK")))
            )
        }
    }
}
