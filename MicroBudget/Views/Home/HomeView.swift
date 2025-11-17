//
//  HomeView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @ObservedObject private var dataManager = DataManager.shared
    @State private var predictedSpend: Double = 0
    @State private var mae: Double = 0
    @State private var hasSufficientData: Bool = false

    var totalBalance: Double {
        dataManager.getTotalBalance()
    }

    var recentTransactions: [TransactionModel] {
        dataManager.getRecentTransactions(limit: 3)
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greetingText)
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
                        if hasSufficientData {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Predicted spend (7 days)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.9))

                                    Text("$\(String(format: "%.2f", predictedSpend))")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("MAE")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.9))

                                    Text("$\(String(format: "%.2f", mae))")
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
                        } else {
                            // Insufficient data message
                            VStack(spacing: 8) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.7))

                                Text("Insufficient Data for Prediction")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)

                                Text("Add more transactions to see ML-powered spending forecasts")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
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

                        if recentTransactions.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "tray")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondaryText)

                                Text("No transactions yet")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondaryText)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(recentTransactions) { transaction in
                                    TransactionRow(
                                        icon: transaction.icon,
                                        iconColor: transaction.color,
                                        title: transaction.merchant,
                                        date: formatDate(transaction.date),
                                        amount: transaction.amount,
                                        isIncome: transaction.isIncome,
                                        hasAddButton: false
                                    )
                                }
                            }
                        }
                    }
                    .padding(.bottom, 100) // Extra padding for bottom tab bar
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            updatePredictions()
        }
        .onChange(of: dataManager.transactions) { oldValue, newValue in
            updatePredictions()
        }
    }

    // MARK: - ML Prediction

    private func updatePredictions() {
        let predictionService = SpendingPredictionService.shared

        // Check if we have sufficient data (at least 7 days of transactions with expenses)
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentExpenses = dataManager.transactions.filter { transaction in
            !transaction.isIncome && transaction.date >= sevenDaysAgo
        }

        // Require at least 3 expense transactions in the last 7 days
        if recentExpenses.count >= 3 {
            hasSufficientData = true
            let prediction = predictionService.getPrediction(transactions: dataManager.transactions)
            predictedSpend = prediction.prediction
            mae = prediction.mae
        } else {
            hasSufficientData = false
            predictedSpend = 0
            mae = 0
        }
    }

    // MARK: - Computed Properties

    private var greetingText: String {
        let timeOfDay = getTimeOfDay()
        let userName = getUserName()
        return "\(timeOfDay), \(userName)"
    }

    private func getTimeOfDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }

    private func getUserName() -> String {
        if let user = authManager.currentUser {
            // Extract first name from full name
            let firstName = user.fullName.components(separatedBy: " ").first ?? user.fullName
            return firstName
        } else if authManager.isGuestMode {
            return "Guest"
        } else {
            return "there"
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
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
