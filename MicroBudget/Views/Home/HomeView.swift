//
//  HomeView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct HomeView: View {
    @State private var totalBalance: Double = 560.00
    @State private var predictedSpend: Double = 210
    @State private var mae: Double = 12.5

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Good evening , Alex")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primaryText)

                        Text("Here's your budget overview")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.secondaryText)
                    }
                    .padding(.top, 16)

                    // Total Balance Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Total Balance")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondaryText)

                        Text("$\(String(format: "%.2f", totalBalance))")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.primaryText)

                        // Predicted spend card
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Predicted spend (7 days)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))

                                Text("$\(Int(predictedSpend))")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                Text("MAE")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))

                                Text("\(String(format: "%.1f", mae))")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(16)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.4, green: 0.4, blue: 1.0),
                                    Color(red: 0.3, green: 0.8, blue: 0.9)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }

                    // Last 7 Days Chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Last 7 Days")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primaryText)

                        ZStack {
                            // Simple area chart representation
                            GeometryReader { geometry in
                                Path { path in
                                    let width = geometry.size.width
                                    let height = geometry.size.height
                                    let points: [(CGFloat, CGFloat)] = [
                                        (0, 0.7),
                                        (0.16, 0.5),
                                        (0.33, 0.6),
                                        (0.5, 0.4),
                                        (0.66, 0.45),
                                        (0.83, 0.35),
                                        (1.0, 0.4)
                                    ]

                                    path.move(to: CGPoint(x: 0, y: height))

                                    for (i, point) in points.enumerated() {
                                        let x = point.0 * width
                                        let y = point.1 * height
                                        if i == 0 {
                                            path.addLine(to: CGPoint(x: x, y: y))
                                        } else {
                                            path.addLine(to: CGPoint(x: x, y: y))
                                        }
                                    }

                                    path.addLine(to: CGPoint(x: width, y: height))
                                    path.closeSubpath()
                                }
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.3, green: 0.35, blue: 0.5).opacity(0.6),
                                            Color(red: 0.3, green: 0.35, blue: 0.5).opacity(0.1)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                            .frame(height: 120)

                            // Labels
                            VStack {
                                Spacer()
                                HStack {
                                    Text("6 days ago")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondaryText)

                                    Spacer()

                                    Text("Today")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondaryText)
                                }
                            }
                        }
                        .frame(height: 140)
                    }

                    // Recent Transactions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Transactions")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primaryText)

                        VStack(spacing: 12) {
                            TransactionRow(
                                icon: "arrow.left.arrow.right",
                                iconColor: .purple,
                                title: "Salary Deposit",
                                date: "Nov 16",
                                amount: 296.00,
                                isIncome: true
                            )

                            TransactionRow(
                                icon: "cart",
                                iconColor: .green,
                                title: "Whole Foods",
                                date: "Nov 15",
                                amount: 69.00,
                                isIncome: false,
                                hasAddButton: true
                            )

                            TransactionRow(
                                icon: "fuelpump",
                                iconColor: .orange,
                                title: "Fuel Station",
                                date: "Nov 14",
                                amount: 81.00,
                                isIncome: false
                            )
                        }
                    }
                    .padding(.bottom, 100) // Extra padding for bottom tab bar
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct TransactionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let date: String
    let amount: Double
    let isIncome: Bool
    var hasAddButton: Bool = false

    var body: some View {
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

            // Title and date
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primaryText)

                Text(date)
                    .font(.system(size: 13))
                    .foregroundColor(.secondaryText)
            }

            Spacer()

            // Amount
            Text("\(isIncome ? "+" : "-")$\(String(format: "%.2f", amount))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isIncome ? .green : .red)

            // Optional add button
            if hasAddButton {
                Button(action: {
                    // Add transaction
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.primaryText)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 28, height: 28)
                }
            }
        }
        .padding(12)
        .background(Color(red: 0.08, green: 0.10, blue: 0.13))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
}
