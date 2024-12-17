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
            } else if viewModel.productHistories.isEmpty {
                Text("No product history available.")
                    .foregroundColor(.secondary)
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
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationTitle("Product History")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.productHistories.isEmpty {
                    Button("Clear") {
                        viewModel.clearHistory()
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadHistory()
        }
        .alert(item: $viewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


