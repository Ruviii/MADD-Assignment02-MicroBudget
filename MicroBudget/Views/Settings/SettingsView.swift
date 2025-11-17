//
//  SettingsView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct SettingsView: View {
    @State private var showSignOutAlert = false

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Settings")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primaryText)

                        Text("Manage your account and preferences")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.secondaryText)
                    }
                    .padding(.top, 16)

                    // User Profile Card
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.08, green: 0.10, blue: 0.13))

                        HStack(spacing: 16) {
                            // User icon
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.12, green: 0.14, blue: 0.18))
                                    .frame(width: 56, height: 56)

                                Image(systemName: "person")
                                    .foregroundColor(.primaryAccent)
                                    .font(.system(size: 24))
                            }

                            // User info
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Alex")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primaryText)

                                Text("alex@example.com")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondaryText)
                            }

                            Spacer()

                            // Edit button
                            Button(action: {
                                // Handle edit profile
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondaryText)
                                    .font(.system(size: 14))
                            }
                        }
                        .padding()
                    }

                    // About Section
                    VStack(spacing: 12) {
                        // About
                        SettingsRow(
                            icon: "info.circle",
                            iconColor: .blue,
                            title: "About",
                            subtitle: "Version 1.0.0",
                            action: {
                                // Handle about
                            }
                        )

                        // Developer Tools
                        SettingsRow(
                            icon: "chevron.left.forwardslash.chevron.right",
                            iconColor: .blue,
                            title: "Developer Tools",
                            action: {
                                // Handle developer tools
                            }
                        )
                    }

                    // Sign Out Button
                    Button(action: {
                        showSignOutAlert = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.08, green: 0.10, blue: 0.13))

                            HStack(spacing: 16) {
                                // Sign out icon
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.12, green: 0.14, blue: 0.18))
                                        .frame(width: 44, height: 44)

                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundColor(.red)
                                        .font(.system(size: 18))
                                }

                                Text("Sign Out")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.red)

                                Spacer()
                            }
                            .padding()
                        }
                    }

                    Spacer()
                        .frame(height: 100) // Padding for bottom tab bar
                }
                .padding(.horizontal, 24)
            }
        }
        .alert("Sign Out", isPresented: $showSignOutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {
                // Handle sign out
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    var subtitle: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.08, green: 0.10, blue: 0.13))

                HStack(spacing: 16) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.12, green: 0.14, blue: 0.18))
                            .frame(width: 44, height: 44)

                        Image(systemName: icon)
                            .foregroundColor(iconColor)
                            .font(.system(size: 18))
                    }

                    // Title and subtitle
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primaryText)

                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.system(size: 13))
                                .foregroundColor(.secondaryText)
                        }
                    }

                    Spacer()

                    // Chevron
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondaryText)
                        .font(.system(size: 14))
                }
                .padding()
            }
        }
    }
}

#Preview {
    SettingsView()
}
