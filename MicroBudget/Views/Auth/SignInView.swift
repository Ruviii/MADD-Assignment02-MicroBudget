//
//  SignInView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showError = false
    @State private var errorMessage = ""

    var onSignUpTapped: () -> Void
    var onContinueAsGuest: () -> Void
    var onSignInSuccess: () -> Void

    var body: some View {
        ZStack {
            // Background
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Logo with gradient
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.4, green: 0.5, blue: 1.0),
                                        Color(red: 0.3, green: 0.8, blue: 0.9)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)

                        StarIcon()
                            .frame(width: 50, height: 50)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 32)

                    // Welcome text
                    Text("Welcome back")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primaryText)
                        .padding(.bottom, 8)

                    Text("Sign in to view your budgets")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .padding(.bottom, 40)

                    // Email field
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Email")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primaryText)

                        TextField("you@domain.com", text: $email)
                            .font(.system(size: 16))
                            .foregroundColor(.primaryText)
                            .padding()
                            .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                            .cornerRadius(12)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)

                    // Password field
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Password")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primaryText)

                        HStack {
                            if showPassword {
                                TextField("", text: $password)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primaryText)
                            } else {
                                SecureField("", text: $password)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primaryText)
                            }

                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.secondaryText)
                            }
                        }
                        .padding()
                        .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)

                    // Forgot password
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle forgot password
                        }) {
                            Text("Forgot password?")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryAccent)
                        }
                        .padding(.trailing, 24)
                    }
                    .padding(.bottom, 32)

                    // Sign In button
                    Button(action: {
                        handleSignIn()
                    }) {
                        Text("Sign In")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primaryAccent)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                    // Or divider
                    HStack {
                        Rectangle()
                            .fill(Color.tertiaryText.opacity(0.3))
                            .frame(height: 1)

                        Text("or")
                            .font(.system(size: 14))
                            .foregroundColor(.secondaryText)
                            .padding(.horizontal, 16)

                        Rectangle()
                            .fill(Color.tertiaryText.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                    // Continue as guest
                    Button(action: {
                        authManager.continueAsGuest()
                        onContinueAsGuest()
                    }) {
                        Text("Continue as guest")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondaryText)
                    }
                    .padding(.bottom, 32)

                    // Sign up link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.secondaryText)

                        Button(action: onSignUpTapped) {
                            Text("Sign up")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primaryAccent)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .alert("Sign In Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Sign In Handler

    private func handleSignIn() {
        let result = authManager.signIn(email: email, password: password)

        switch result {
        case .success:
            onSignInSuccess()
        case .failure(let error):
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

#Preview {
    SignInView(
        onSignUpTapped: {},
        onContinueAsGuest: {},
        onSignInSuccess: {}
    )
}
