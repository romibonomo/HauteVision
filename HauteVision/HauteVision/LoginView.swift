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
    @State private var isLoggingIn = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    init(email: String = "") {
        _email = State(initialValue: email)
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                // Logo
                Image("HauteVision_AppIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                // Input Fields
                VStack(spacing: 24){
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        .disabled(isLoggingIn || viewModel.isLoading)
                        .onChange(of: email) { oldValue, newValue in
                            // Clear error when user starts typing
                            if errorMessage != nil {
                                errorMessage = nil
                            }
                        }
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        .disabled(isLoggingIn || viewModel.isLoading)
                        .onChange(of: password) { oldValue, newValue in
                            // Clear error when user starts typing
                            if errorMessage != nil {
                                errorMessage = nil
                            }
                        }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 8)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                // Forgot Password Button
                Button {
                    if email.isEmpty || !email.contains("@") {
                        errorMessage = "Please enter a valid email address to reset your password"
                    } else {
                        showResetPasswordAlert = true
                    }
                } label: {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .disabled(isLoggingIn || viewModel.isLoading)
                
                // Sign In Button
                Button{
                    handleSignIn()
                } label: {
                    HStack{
                        if isLoggingIn || viewModel.isLoading {
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
                .disabled(!formIsValid || isLoggingIn || viewModel.isLoading)
                .opacity((formIsValid && !isLoggingIn && !viewModel.isLoading) ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                // Sign Up Link
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
                .disabled(isLoggingIn || viewModel.isLoading)
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
                    handlePasswordReset()
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
                errorMessage = "No internet connection. Please check your network settings and try again."
            } else {
                // If network becomes available again, clear the error message
                if errorMessage == "No internet connection. Please check your network settings and try again." {
                    errorMessage = nil
                }
            }
        }
        // Add a tap gesture to dismiss keyboard when tapping anywhere on the view
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private func handleSignIn() {
        guard !isLoggingIn else { return }
        
        if !viewModel.networkAvailable {
            errorMessage = "No internet connection. Please check your network settings and try again."
            return
        }
        
        isLoggingIn = true
        errorMessage = nil
        
        Task {
            do {
                try await viewModel.signIn(withEmail: email, password: password)
                navigateToMain = true
            } catch {
                handleSignInError(error)
            }
            isLoggingIn = false
        }
    }
    
    private func handleSignInError(_ error: Error) {
        let nsError = error as NSError
        
        // Handle Firebase Auth errors
        if nsError.domain == AuthErrorDomain {
            switch nsError.code {
            case AuthErrorCode.wrongPassword.rawValue:
                errorMessage = "Incorrect password. Please check and try again."
            case AuthErrorCode.userNotFound.rawValue:
                showCreateAccountAlert = true
                return
            case AuthErrorCode.userDisabled.rawValue:
                errorMessage = "This account has been disabled. Please contact support."
            case AuthErrorCode.invalidEmail.rawValue:
                errorMessage = "Invalid email format. Please enter a valid email address."
            case AuthErrorCode.tooManyRequests.rawValue:
                errorMessage = "Too many failed login attempts. Please try again later."
            default:
                errorMessage = "Sign in failed. Please check your email and password."
            }
        }
        // Handle network error
        else if nsError.domain == "AuthError" && nsError.code == -1 {
            errorMessage = "Network error. Please check your connection and try again."
        }
        // Handle other errors
        else {
            errorMessage = "Unable to sign in. Please try again later."
        }
        
        print("DEBUG: Sign in error: \(error.localizedDescription)")
    }
    
    private func handlePasswordReset() {
        Task {
            do {
                try await viewModel.resetPassword(email: email)
                showResetConfirmation = true
            } catch {
                let nsError = error as NSError
                
                if nsError.domain == AuthErrorDomain && nsError.code == AuthErrorCode.userNotFound.rawValue {
                    errorMessage = "No account found with this email address."
                } else if nsError.domain == "AuthError" && nsError.code == -1 {
                    errorMessage = "Network error. Please check your connection and try again."
                } else {
                    errorMessage = "Failed to send reset email. Please verify your email address."
                }
                
                print("DEBUG: Password reset error: \(error.localizedDescription)")
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
            .environmentObject(AuthViewModel())
    }
}
