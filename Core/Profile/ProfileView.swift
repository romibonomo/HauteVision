//
//  ProfileView.swift
//  HauteVision
//
//  Created by romi bonomo on 2025-02-10.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showDeleteConfirmation = false
    @State private var navigateToLogin = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isDeleting = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    if let user = viewModel.currentUser {
                        VStack(spacing: 12) {
                            // Profile Picture with Initials
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                            
                            // User Info
                            VStack(spacing: 4) {
                                Text(user.fullname)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Account Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ACCOUNT")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 1) {
                            // Sign Out Button
                            Button {
                                viewModel.signOut()
                                navigateToLogin = true
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.left.circle.fill")
                                        .foregroundColor(.red)
                                    Text("Sign Out")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                            }
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // Delete Account Button
                            Button {
                                showDeleteConfirmation = true
                            } label: {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                    Text("Delete Account")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                            }
                        }
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6))
            .alert("Delete Account", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    isDeleting = true
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            navigateToLogin = true
                        } catch {
                            showError = true
                            errorMessage = error.localizedDescription
                        }
                        isDeleting = false
                    }
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
