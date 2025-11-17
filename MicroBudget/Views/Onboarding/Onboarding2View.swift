//
//  Onboarding2View.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct Onboarding2View: View {
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
                    // Chart icon with circle background
                    ZStack {
                        // Dark circle background
                        Circle()
                            .fill(Color(red: 0.1, green: 0.12, blue: 0.18))
                            .frame(width: 140, height: 140)

                        // Chart icon with gradient
                        ChartIcon()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.bottom, 16)

                    // Main heading
                    Text("Smart forecasts")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    // Description text
                    Text("AI-powered predictions help you\nunderstand how your spending will affect you\nto help ahead with confidence")
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
                            .fill(Color.tertiaryText.opacity(0.3))
                            .frame(width: 8, height: 8)

                        Circle()
                            .fill(Color.primaryAccent)
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

// Custom Chart Icon with gradient
struct ChartIcon: View {
    var body: some View {
        // Trending up arrow/chart
        ZStack {
            Path { path in
                // Line chart path
                path.move(to: CGPoint(x: 8, y: 45))
                path.addLine(to: CGPoint(x: 22, y: 32))
                path.addLine(to: CGPoint(x: 38, y: 25))
                path.addLine(to: CGPoint(x: 52, y: 15))
            }
            .stroke(
                LinearGradient(
                    colors: [Color.accentGradientStart, Color.accentGradientEnd],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )

            // Arrow head
            Path { path in
                path.move(to: CGPoint(x: 52, y: 15))
                path.addLine(to: CGPoint(x: 46, y: 18))
                path.move(to: CGPoint(x: 52, y: 15))
                path.addLine(to: CGPoint(x: 49, y: 21))
            }
            .stroke(
                LinearGradient(
                    colors: [Color.accentGradientStart, Color.accentGradientEnd],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )
        }
    }
}

#Preview {
    Onboarding2View()
}
