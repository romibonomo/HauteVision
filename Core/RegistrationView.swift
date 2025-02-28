//
//  RegistrationView.swift
//  HauteVision
//
//  Created by romi bonomo on 2025-02-10.
//

import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var navigateToLogin = false
    @State private var navigateToMain = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("HauteVision_AppIcon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                VStack(spacing: 24){
                    InputView(text: $fullname, title: "Full Name", placeholder: "Enter your full name")
                    
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        .autocapitalization(.none)
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true, showToggle: false)
                        
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 8)
                }
                
                Button{
                    Task {
                        do {
                            try await viewModel.createUser(fullname: fullname, withEmail: email, password: password)
                            navigateToMain = true
                        } catch {
                            showError = true
                            let nsError = error as NSError
                            errorMessage = nsError.localizedDescription
                            if nsError.domain == "AuthError" && nsError.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                                // Show error message for 2 seconds before navigating
                                try? await Task.sleep(nanoseconds: 2_000_000_000)
                                navigateToLogin = true
                            }
                        }
                    }
                } label:{
                    HStack{
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView(email: email)
                    .navigationBarBackButtonHidden()
            }
            .navigationDestination(isPresented: $navigateToMain) {
                MainTabView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}
    
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
