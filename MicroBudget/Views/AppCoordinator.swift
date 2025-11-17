//
//  AppCoordinator.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

enum AppScreen {
    case onboarding
    case signIn
    case signUp
    case mainApp
}

struct AppCoordinator: View {
    @ObservedObject private var authManager = AuthManager.shared
    @State private var currentScreen: AppScreen = .onboarding

    var body: some View {
        Group {
            switch currentScreen {
            case .onboarding:
                OnboardingContainerView(
                    onComplete: {
                        currentScreen = .signIn
                    },
                    onSkip: {
                        currentScreen = .mainApp
                    }
                )

            case .signIn:
                SignInView(
                    onSignUpTapped: {
                        currentScreen = .signUp
                    },
                    onContinueAsGuest: {
                        currentScreen = .mainApp
                    },
                    onSignInSuccess: {
                        currentScreen = .mainApp
                    }
                )

            case .signUp:
                SignUpView(
                    onSignInTapped: {
                        currentScreen = .signIn
                    },
                    onCreateAccountSuccess: {
                        currentScreen = .mainApp
                    }
                )

            case .mainApp:
                MainTabView()
            }
        }
        .onAppear {
            // Check authentication state on launch
            if authManager.isAuthenticated {
                currentScreen = .mainApp
            } else {
                currentScreen = .onboarding
            }
        }
        .onChange(of: authManager.isAuthenticated) { oldValue, newValue in
            // Handle authentication state changes (e.g., sign out)
            if !newValue {
                currentScreen = .onboarding
            }
        }
    }
}

#Preview {
    AppCoordinator()
}
