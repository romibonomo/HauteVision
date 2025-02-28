//
//  SwiftUIView.swift
//  HauteVision
//
//  Created by romi bonomo on 2025-02-09.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showCreateAccountAlert = false
    @State private var showResetPasswordAlert = false
    @State private var showResetConfirmation = false
    @State private var navigateToMain = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    init(email: String = "") {
        _email = State(initialValue: email)
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                Image("HauteVision_AppIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                VStack(spacing: 24){
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        .disabled(viewModel.isLoading)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        .disabled(viewModel.isLoading)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 8)
                }
                
                Button {
                    showResetPasswordAlert = true
                } label: {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button{
                    Task {
                        do {
                            try await viewModel.signIn(withEmail: email, password: password)
                            errorMessage = nil
                            navigateToMain = true
                        } catch {
                            switch error {
                            case AuthErrorCode.wrongPassword:
                                errorMessage = "Incorrect password. Please try again."
                            case AuthErrorCode.invalidEmail:
                                errorMessage = "Invalid email format."
                            case AuthErrorCode.userNotFound:
                                showCreateAccountAlert = true
                            case AuthErrorCode.weakPassword:
                                errorMessage = "Password should be at least 6 characters long."
                            default:
                                if let error = error as NSError?, error.domain == "AuthError" {
                                    if error.code == 17026 {  // Firebase's internal code for password issues
                                        errorMessage = "Incorrect password. Please try again."
                                    } else {
                                        errorMessage = error.localizedDescription
                                    }
                                } else {
                                    errorMessage = "Incorrect email or password. Please try again."
                                }
                            }
                        }
                    }
                } label: {
                    HStack{
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("SIGN IN")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid || viewModel.isLoading)
                .opacity((formIsValid && !viewModel.isLoading) ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3){
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
            .navigationDestination(isPresented: $navigateToMain) {
                MainTabView()
                    .navigationBarBackButtonHidden()
            }
            .alert("Account Not Found", isPresented: $showCreateAccountAlert) {
                Button("Cancel", role: .cancel) { }
                NavigationLink("Create Account") {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                }
            } message: {
                Text("Would you like to create a new account with \(email)?")
            }
            .alert("Reset Password", isPresented: $showResetPasswordAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset") {
                    Task {
                        do {
                            try await viewModel.resetPassword(email: email)
                            showResetConfirmation = true
                        } catch {
                            errorMessage = "Failed to send reset email. Please verify your email address."
                        }
                    }
                }
            } message: {
                Text("Send password reset email to \(email)?")
            }
            .alert("Password Reset Email Sent", isPresented: $showResetConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Check your email for instructions to reset your password.")
            }
        }
        .onChange(of: viewModel.networkAvailable) { 
            if !viewModel.networkAvailable {
                errorMessage = "No internet connection"
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View{
        LoginView()
    }
}
