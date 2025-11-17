//
//  SignUpView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var savePasswordLocally = false
    @State private var showError = false
    @State private var errorMessage = ""

    var onSignInTapped: () -> Void
    var onCreateAccountSuccess: () -> Void

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

                    // Create account text
                    Text("Create account")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primaryText)
                        .padding(.bottom, 8)

                    Text("Save your data to this device")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .padding(.bottom, 40)

                    // Full Name field
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Full Name")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primaryText)

                        TextField("Alex Johnson", text: $fullName)
                            .font(.system(size: 16))
                            .foregroundColor(.primaryText)
                            .padding()
                            .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)

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
                        HStack(spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            Text("(optional)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.secondaryText)
                        }

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
                    .padding(.bottom, 20)

                    // Save password locally toggle
                    HStack(spacing: 12) {
                        Button(action: {
                            savePasswordLocally.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(savePasswordLocally ? Color.primaryAccent : Color.tertiaryText.opacity(0.3), lineWidth: 2)
                                    .frame(width: 24, height: 24)

                                if savePasswordLocally {
                                    Circle()
                                        .fill(Color.primaryAccent)
                                        .frame(width: 14, height: 14)
                                }
                            }
                        }

                        Text("Save password locally")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.primaryText)

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)

                    // Create Account button
                    Button(action: {
                        handleSignUp()
                    }) {
                        Text("Create Account")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primaryAccent)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)

                    // Sign in link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.secondaryText)

                        Button(action: onSignInTapped) {
                            Text("Sign in")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primaryAccent)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .alert("Sign Up Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Sign Up Handler

    private func handleSignUp() {
        let result = authManager.signUp(fullName: fullName, email: email, password: password)

        switch result {
        case .success:
            onCreateAccountSuccess()
        case .failure(let error):
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

#Preview {
    SignUpView(
        onSignInTapped: {},
        onCreateAccountSuccess: {}
    )
}
