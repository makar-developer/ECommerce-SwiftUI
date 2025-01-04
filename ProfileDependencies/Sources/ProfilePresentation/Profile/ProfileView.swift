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
        ScrollView {
            VStack {
                profileImageView
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    TextField(String(localized: "User Name"), text: $viewModel.userName)
                        .textFieldStyle(CustomTextFieldStyle())
                        .foregroundColor(.textBackground)

                    if !viewModel.isUserNameValid && !viewModel.userName.isEmpty {
                        Text(String(localized: "Invalid User Name"))
                            .foregroundColor(.errorColor)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    TextField(String(localized: "Login"), text: $viewModel.login)
                        .textFieldStyle(CustomTextFieldStyle())
                        .foregroundColor(.textBackground)

                    if !viewModel.isLoginValid && !viewModel.login.isEmpty {
                        Text(String(localized: "Invalid Login (Min 4 alphanumeric characters)"))
                            .foregroundColor(.errorColor)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(Color.backgroundSecondary)
                .cornerRadius(12)
                .shadow(color: Color.borderColor.opacity(0.2), radius: 4, x: 0, y: 2)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.errorColor)
                        .padding()
                        .background(Color.backgroundSecondary)
                        .cornerRadius(8)
                }
                
                Button(action: {viewModel.saveChanges()}) {
                    Text(String(localized: "Save Changes"))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.canSaveChanges ? Color.accentPrimary : Color.accentSecondary.opacity(0.6))
                        .foregroundColor(.textBackground)
                        .cornerRadius(30)
                }
                .disabled(!viewModel.canSaveChanges || viewModel.isLoading)
                .padding([.horizontal, .top])
                
                Button(action: {viewModel.changePassword()}) {
                    Text(String(localized: "Change Password"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.backgroundSecondary)
                        .foregroundColor(.accentPrimary)
                        .cornerRadius(30)
                }
                .padding(.horizontal)
                
                Button(action: {viewModel.showProductHistory()}) {
                    Text(String(localized: "View Product History"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.backgroundSecondary)
                        .foregroundColor(.accentPrimary)
                        .cornerRadius(30)
                }
                .padding([.horizontal, .top])
                
                Spacer()
                
                Button(action: {viewModel.logout()}) {
                    Text(String(localized: "Logout"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.errorColor.opacity(0.1))
                        .foregroundColor(.errorColor)
                        .cornerRadius(30)
                }
                .padding([.horizontal, .bottom])
            }
            .padding()
        }
        .background(Color.backgroundPrimary)
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
                    .overlay(Circle().stroke(Color.accentPrimary, lineWidth: 2))
                    .shadow(color: Color.accentPrimary.opacity(0.5), radius: 5, x: 0, y: 2)
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            } else {
                Circle()
                    .fill(Color.backgroundSecondary)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text(String(localized: "Tap to select"))
                            .foregroundColor(.textBackground)
                    )
                    .shadow(color: Color.borderColor.opacity(0.2), radius: 5, x: 0, y: 2)
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(Color.backgroundPrimary)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
    }
}

