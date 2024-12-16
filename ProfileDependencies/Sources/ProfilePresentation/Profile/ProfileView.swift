//
//  File.swift
//  
//
//  Created by Admin on 16/12/2024.
//


import SwiftUI

public struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var isImagePickerPresented = false
    @State private var selectedImageData: Data?

    public init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack {
            profileImageView

            VStack(spacing: 16) {
                TextField("User Name", text: $viewModel.userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                    .onChange(of: viewModel.userName) { _ in
                        // Validation handled in ViewModel
                    }

                if !viewModel.isUserNameValid && !viewModel.userName.isEmpty {
                    Text("Invalid User Name")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                TextField("Login", text: $viewModel.login)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .onChange(of: viewModel.login) { _ in
                        // Validation handled in ViewModel
                    }

                if !viewModel.isLoginValid && !viewModel.login.isEmpty {
                    Text("Invalid Login (Min 4 alphanumeric characters)")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Save Changes") {
                viewModel.saveChanges()
            }
            .disabled(!viewModel.canSaveChanges || viewModel.isLoading)
            .padding()

            Button("Change Password") {
                viewModel.changePassword()
            }
            .padding()

            Spacer()

            Button("Logout") {
                viewModel.logout()
            }
            .foregroundColor(.red)
            .padding()
        }
        .padding()
        .sheet(isPresented: $isImagePickerPresented, onDismiss: {
            if let data = selectedImageData {
                viewModel.updateProfilePicture(with: data)
            }
        }) {
            ImagePicker(imageData: $selectedImageData)
        }
        .onAppear {
            viewModel.loadProfilePicture()
        }
    }

    private var profileImageView: some View {
        Group {
            if let data = viewModel.profilePictureData,
               let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text("Tap to select")
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            }
        }
    }
}
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage,
               let data = image.jpegData(compressionQuality: 0.8) {
                parent.imageData = data
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
