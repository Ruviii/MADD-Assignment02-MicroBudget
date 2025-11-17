//
//  Onboarding3View.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct Onboarding3View: View {
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
                    // Target icon with circle background
                    ZStack {
                        // Dark circle background
                        Circle()
                            .fill(Color(red: 0.1, green: 0.12, blue: 0.18))
                            .frame(width: 140, height: 140)

                        // Target icon with gradient
                        TargetIcon()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.bottom, 16)

                    // Main heading
                    Text("Save & reach goals")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    // Description text
                    Text("Set envelope budgets, track progress, and\nachieve your financial goals faster than ever.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 32)
                }

                Spacer()

                // Bottom section with page indicator and get started button
                VStack(spacing: 32) {
                    // Page indicator
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

                    // Get Started button
                    Button(action: {
                        // Handle get started action
                    }) {
                        Text("Get Started")
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

// Custom Target Icon with gradient concentric circles
struct TargetIcon: View {
    var body: some View {
        ZStack {
            // Outer circle
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.accentGradientStart, Color.accentGradientEnd],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2.5
                )
                .frame(width: 50, height: 50)

            // Middle circle
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.accentGradientStart, Color.accentGradientEnd],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2.5
                )
                .frame(width: 32, height: 32)

            // Inner filled circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.accentGradientStart, Color.accentGradientEnd],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 12, height: 12)
        }
    }
}

#Preview {
    Onboarding3View()
}
