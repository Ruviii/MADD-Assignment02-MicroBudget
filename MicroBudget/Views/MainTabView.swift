//
//  MainTabView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0 // Start with Home tab

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Content
                TabView(selection: $selectedTab) {
                    // Home Tab
                    HomeView()
                        .tag(0)

                    // Envelopes Tab
                    EnvelopesView()
                        .tag(1)

                    // Transactions Tab
                    TransactionsView()
                        .tag(2)

                    // Insights Tab
                    InsightsView()
                        .tag(3)

                    // Settings Tab
                    SettingsView()
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Custom Tab Bar
                HStack(spacing: 0) {
                    TabBarButton(
                        icon: "house",
                        label: "Home",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 }
                    )

                    TabBarButton(
                        icon: "wallet.pass",
                        label: "Envelopes",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 }
                    )

                    TabBarButton(
                        icon: "list.bullet",
                        label: "Transactions",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 }
                    )

                    TabBarButton(
                        icon: "chart.line.uptrend.xyaxis",
                        label: "Insights",
                        isSelected: selectedTab == 3,
                        action: { selectedTab = 3 }
                    )

                    TabBarButton(
                        icon: "gearshape",
                        label: "Settings",
                        isSelected: selectedTab == 4,
                        action: { selectedTab = 4 }
                    )
                }
                .padding(.vertical, 12)
                .background(Color(red: 0.08, green: 0.10, blue: 0.13))
            }
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .primaryAccent : .secondaryText)

                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? .primaryAccent : .secondaryText)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct PlaceholderView: View {
    let title: String

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primaryText)

                Text("Coming soon...")
                    .font(.system(size: 16))
                    .foregroundColor(.secondaryText)
                    .padding(.top, 8)
            }
        }
    }
}

#Preview {
    MainTabView()
}
