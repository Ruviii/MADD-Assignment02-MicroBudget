//
//  AuthManager.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import Foundation
import SwiftUI
import SwiftData
internal import Combine

@MainActor
class AuthManager: ObservableObject {
    var objectWillChange: ObservableObjectPublisher

    static let shared = AuthManager()

    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isGuestMode = false

    private var modelContext: ModelContext?

    private init() {
        objectWillChange = ObservableObjectPublisher()
        loadAuthState()
    }

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - Sign Up

    func signUp(fullName: String, email: String, password: String) -> Result<User, AuthError> {
        guard let context = modelContext else {
            return .failure(.invalidFullName)
        }

        // Validate inputs
        guard !fullName.isEmpty else {
            return .failure(.invalidFullName)
        }

        guard isValidEmail(email) else {
            return .failure(.invalidEmail)
        }

        guard !password.isEmpty else {
            return .failure(.invalidPassword)
        }

        // Check if user already exists
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
        if let existingUsers = try? context.fetch(descriptor), !existingUsers.isEmpty {
            return .failure(.userAlreadyExists)
        }

        // Create new user
        let newUser = User(fullName: fullName, email: email, password: password)

        // Save user to SwiftData
        context.insert(newUser)
        try? context.save()

        // Set as current user
        objectWillChange.send()
        currentUser = newUser
        isAuthenticated = true
        isGuestMode = false

        // Persist auth state
        saveAuthState()

        // Reload DataManager to show user's data
        DataManager.shared.reloadData()

        return .success(newUser)
    }

    // MARK: - Sign In

    func signIn(email: String, password: String) -> Result<User, AuthError> {
        guard let context = modelContext else {
            return .failure(.userNotFound)
        }

        // Validate inputs
        guard isValidEmail(email) else {
            return .failure(.invalidEmail)
        }

        guard !password.isEmpty else {
            return .failure(.invalidPassword)
        }

        // Find user by email
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
        guard let users = try? context.fetch(descriptor),
              let user = users.first else {
            return .failure(.userNotFound)
        }

        // Verify password
        guard password.matches(hash: user.passwordHash) else {
            return .failure(.incorrectPassword)
        }

        // Set as current user
        objectWillChange.send()
        currentUser = user
        isAuthenticated = true
        isGuestMode = false

        // Persist auth state
        saveAuthState()

        // Reload DataManager to show user's data
        DataManager.shared.reloadData()

        return .success(user)
    }

    // MARK: - Sign Out

    func signOut() {
        objectWillChange.send()
        currentUser = nil
        isAuthenticated = false
        isGuestMode = false
        clearAuthState()

        // Clear DataManager data
        DataManager.shared.reloadData()
    }

    // MARK: - Guest Mode

    func continueAsGuest() {
        objectWillChange.send()
        currentUser = nil
        isAuthenticated = true
        isGuestMode = true
        saveAuthState()

        // Reload DataManager for guest mode
        DataManager.shared.reloadData()
    }

    // MARK: - Persistence (UserDefaults for auth state only)

    private func saveAuthState() {
        UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        UserDefaults.standard.set(isGuestMode, forKey: "isGuestMode")

        if let user = currentUser {
            UserDefaults.standard.set(user.id.uuidString, forKey: "currentUserId")
        }
    }

    private func loadAuthState() {
        isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        isGuestMode = UserDefaults.standard.bool(forKey: "isGuestMode")

        // Note: currentUser will be loaded when modelContext is set
        if let userIdString = UserDefaults.standard.string(forKey: "currentUserId"),
           let userId = UUID(uuidString: userIdString) {
            // Load user when context is available
            loadCurrentUser(id: userId)
        }
    }

    private func loadCurrentUser(id: UUID) {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == id })
        if let users = try? context.fetch(descriptor), let user = users.first {
            objectWillChange.send()
            currentUser = user

            // Reload DataManager to show user's data
            DataManager.shared.reloadData()
        }
    }

    private func clearAuthState() {
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        UserDefaults.standard.removeObject(forKey: "isAuthenticated")
        UserDefaults.standard.removeObject(forKey: "isGuestMode")
    }

    // MARK: - Validation

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Auth Errors

enum AuthError: Error, LocalizedError {
    case invalidFullName
    case invalidEmail
    case invalidPassword
    case userAlreadyExists
    case userNotFound
    case incorrectPassword

    var errorDescription: String? {
        switch self {
        case .invalidFullName:
            return "Please enter a valid full name"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Password cannot be empty"
        case .userAlreadyExists:
            return "An account with this email already exists"
        case .userNotFound:
            return "No account found with this email"
        case .incorrectPassword:
            return "Incorrect password"
        }
    }
}
