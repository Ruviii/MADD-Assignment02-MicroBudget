

import SwiftUI

struct OnboardingContainerView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @State private var currentPage = 0
    var onComplete: () -> Void
    var onSkip: () -> Void

    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage1View(
                onContinue: {
                    withAnimation {
                        currentPage = 1
                    }
                },
                onSkip: {
                    authManager.continueAsGuest()
                    onSkip()
                }
            )
            .tag(0)

            OnboardingPage2View(
                onContinue: {
                    withAnimation {
                        currentPage = 2
                    }
                },
                onSkip: {
                    authManager.continueAsGuest()
                    onSkip()
                }
            )
            .tag(1)

            OnboardingPage3View(
                onGetStarted: onComplete,
                onSkip: {
                    authManager.continueAsGuest()
                    onSkip()
                }
            )
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}

// Refactored Onboarding Page 1 with callbacks
struct OnboardingPage1View: View {
    let onContinue: () -> Void
    let onSkip: () -> Void

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: onSkip) {
                        Text("Continue as guest")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.tertiaryText)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 16)
                }

                Spacer()

                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.1, green: 0.12, blue: 0.18))
                            .frame(width: 140, height: 140)

                        StarIcon()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.bottom, 16)

                    Text("Track your budget in\nseconds")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    Text("Simple, fast budgeting that fits your\nlifestyle. Add transactions in seconds and\nstay on top of your spending.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 32)
                }

                Spacer()

                VStack(spacing: 32) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.primaryAccent)
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(Color.tertiaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(Color.tertiaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }

                    Button(action: onContinue) {
                        Text("Continue")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primaryAccent)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 48)
            }
        }
    }
}

// Refactored Onboarding Page 2 with callbacks
struct OnboardingPage2View: View {
    let onContinue: () -> Void
    let onSkip: () -> Void

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: onSkip) {
                        Text("Continue as guest")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.tertiaryText)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 16)
                }

                Spacer()

                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.1, green: 0.12, blue: 0.18))
                            .frame(width: 140, height: 140)

                        ChartIcon()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.bottom, 16)

                    Text("Smart forecasts")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    Text("AI-powered predictions help you\nunderstand how your spending will affect you\nto help ahead with confidence")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 32)
                }

                Spacer()

                VStack(spacing: 32) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.tertiaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(Color.primaryAccent)
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(Color.tertiaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }

                    Button(action: onContinue) {
                        Text("Continue")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primaryAccent)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 48)
            }
        }
    }
}

// Refactored Onboarding Page 3 with callbacks
struct OnboardingPage3View: View {
    let onGetStarted: () -> Void
    let onSkip: () -> Void

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: onSkip) {
                        Text("Continue as guest")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.tertiaryText)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 16)
                }

                Spacer()

                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.1, green: 0.12, blue: 0.18))
                            .frame(width: 140, height: 140)

                        TargetIcon()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.bottom, 16)

                    Text("Save & reach goals")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    Text("Set envelope budgets, track progress, and\nachieve your financial goals faster than ever.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 32)
                }

                Spacer()

                VStack(spacing: 32) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.tertiaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(Color.tertiaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(Color.primaryAccent)
                            .frame(width: 8, height: 8)
                    }

                    Button(action: onGetStarted) {
                        Text("Get Started")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primaryAccent)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 48)
            }
        }
    }
}

#Preview {
    OnboardingContainerView(
        onComplete: {},
        onSkip: {}
    )
}
