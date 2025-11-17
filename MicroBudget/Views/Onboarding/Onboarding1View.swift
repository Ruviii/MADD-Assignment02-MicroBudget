

import SwiftUI

struct Onboarding1View: View {
    var body: some View {
        ZStack {
            // Background
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with "Continue as guest"
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle continue as guest action
                    }) {
                        Text("Continue as guest")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.tertiaryText)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 16)
                }

                Spacer()

                // Main content
                VStack(spacing: 24) {
                    // Star icon with circle background
                    ZStack {
                        // Dark circle background
                        Circle()
                            .fill(Color(red: 0.1, green: 0.12, blue: 0.18))
                            .frame(width: 140, height: 140)

                        // Star icon with gradient
                        StarIcon()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.bottom, 16)

                    // Main heading
                    Text("Track your budget in\nseconds")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    // Description text
                    Text("Simple, fast budgeting that fits your\nlifestyle. Add transactions in seconds and\nstay on top of your spending.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 32)
                }

                Spacer()

                // Bottom section with page indicator and continue button
                VStack(spacing: 32) {
                    // Page indicator
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

                    // Continue button
                    Button(action: {
                        // Handle continue action
                    }) {
                        Text("Continue")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 48)
            }
        }
    }
}

// Custom Star Icon with gradient
struct StarIcon: View {
    var body: some View {
        ZStack {
            // Main star shape
            Image(systemName: "sparkle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.accentGradientStart, Color.accentGradientEnd],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Small sparkles around the star
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color.accentGradientStart)
                        .offset(x: 8, y: -8)
                }
                Spacer()
            }

            VStack {
                Spacer()
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(Color.accentGradientEnd)
                        .offset(x: -10, y: 6)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    Onboarding1View()
}
