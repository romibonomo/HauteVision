//
//  AuthViewModel.swift
//  HauteVision
//
//  Created by romi bonomo on 2025-02-10.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Network

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var networkAvailable = true
    private let monitor = NWPathMonitor()
    
    init() {
        self.userSession = Auth.auth().currentUser
        setupNetworkMonitoring()
        
        Task{
            await fetchUser()
        }
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            Task { @MainActor in
                self.networkAvailable = path.status == .satisfied
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        guard networkAvailable else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(fullname: String, withEmail email: String, password: String) async throws {
        guard networkAvailable else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
            let nsError = error as NSError
            if nsError.domain == AuthErrorDomain {
                switch nsError.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    throw NSError(
                        domain: "AuthError",
                        code: AuthErrorCode.emailAlreadyInUse.rawValue,
                        userInfo: [
                            NSLocalizedDescriptionKey: "This email is already registered. Redirecting you to sign in...",
                            "email": email
                        ]
                    )
                default:
                    throw error
                }
            } else {
                throw error
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out user with error: \(error.localizedDescription)")
        }
    }
    
    func resetPassword(email: String) async throws {
        guard networkAvailable else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("DEBUG: Failed to send password reset email with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteAccount() async throws {
        guard networkAvailable else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
        }
        
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }
        
        do {
            // Delete user data from Firestore
            try await Firestore.firestore().collection("users").document(user.uid).delete()
            
            // Delete the user account from Firebase Auth
            try await user.delete()
            
            // Sign out and clear local state
            await MainActor.run {
                self.signOut()
            }
        } catch {
            print("DEBUG: Failed to delete account with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchUser() async {
        guard networkAvailable else { return }
        guard let uid = Auth.auth().currentUser?.uid else {
            await MainActor.run {
                self.currentUser = nil
            }
            return
        }
        
        do {
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
            
            // Add retry logic for simulator issues
            var attempts = 0
            var lastError: Error?
            
            while attempts < 3 {
                do {
                    let snapshot = try await docRef.getDocument()
                    guard snapshot.exists else {
                        print("DEBUG: User document does not exist")
                        await MainActor.run {
                            self.currentUser = nil
                        }
                        return
                    }
                    
                    if let user = try? snapshot.data(as: User.self) {
                        await MainActor.run {
                            self.currentUser = user
                        }
                        return
                    } else {
                        print("DEBUG: Failed to decode user data")
                        throw NSError(domain: "FetchUserError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user data"])
                    }
                } catch {
                    lastError = error
                    attempts += 1
                    if attempts == 3 {
                        print("DEBUG: Final error fetching user: \(error.localizedDescription)")
                    } else {
                        try await Task.sleep(nanoseconds: 1_000_000_000) // Wait 1 second before retry
                        continue
                    }
                }
            }
            
            // If we get here, all attempts failed
            print("DEBUG: All attempts to fetch user failed")
            await MainActor.run {
                self.currentUser = nil
            }
            if let lastError = lastError {
                throw lastError
            }
        } catch {
            print("DEBUG: Error fetching user: \(error.localizedDescription)")
            await MainActor.run {
                self.currentUser = nil
            }
        }
    }
    
    deinit {
        monitor.cancel()
    }
}
