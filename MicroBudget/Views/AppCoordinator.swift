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
    @State private var currentScreen: AppScreen = .onboarding
    @State private var showOnboarding = true

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
    }
}

#Preview {
    AppCoordinator()
}
