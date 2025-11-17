//
//  InsightsView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct InsightsView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var forecastAmount: Double = 0
    @State private var avgDaily: Double = 0
    @State private var totalSpent: Double = 0
    @State private var savingsRate: Double = 0
    @State private var mlPrediction: Double = 0
    @State private var mlMAE: Double = 0
    @State private var fallbackPrediction: Double = 0
    @State private var fallbackMAE: Double = 0
    @State private var hasSufficientData: Bool = false

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Insights")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primaryText)

                        Text("Your spending trends and forecasts")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.secondaryText)
                    }
                    .padding(.top, 16)

                    // 30-Day History & Forecast Chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("30-Day History & Forecast")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)

                        ZStack {
                            // Chart background
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.08, green: 0.10, blue: 0.13))

                            VStack {
                                // Line chart
                                GeometryReader { geometry in
                                    ZStack {
                                        // Grid lines
                                        VStack(spacing: 0) {
                                            ForEach(0..<5) { _ in
                                                Divider()
                                                    .background(Color.tertiaryText.opacity(0.1))
                                                Spacer()
                                            }
                                        }

                                        // Chart line
                                        Path { path in
                                            let width = geometry.size.width
                                            let height = geometry.size.height

                                            // Sample data points for 30 days
                                            let points: [CGFloat] = [
                                                0.6, 0.5, 0.7, 0.4, 0.6, 0.3, 0.5,
                                                0.7, 0.4, 0.6, 0.5, 0.7, 0.3, 0.5,
                                                0.6, 0.4, 0.7, 0.5, 0.6, 0.4, 0.5,
                                                0.7, 0.6, 0.5, 0.7, 0.6, 0.5, 0.6,
                                                0.7, 0.6
                                            ]

                                            for (index, point) in points.enumerated() {
                                                let x = CGFloat(index) / CGFloat(points.count - 1) * width
                                                let y = (1 - point) * height

                                                if index == 0 {
                                                    path.move(to: CGPoint(x: x, y: y))
                                                } else {
                                                    path.addLine(to: CGPoint(x: x, y: y))
                                                }
                                            }
                                        }
                                        .stroke(Color(red: 0.3, green: 0.4, blue: 0.6), lineWidth: 2)
                                    }
                                }
                                .frame(height: 180)
                                .padding()

                                // Forecast label
                                if hasSufficientData {
                                    HStack {
                                        Text("Forecast (7 days)")
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondaryText)

                                        Spacer()

                                        Text("$\(String(format: "%.2f", forecastAmount))")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.orange)
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                } else {
                                    HStack {
                                        Text("Insufficient data for forecast")
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondaryText)

                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                }
                            }
                        }
                        .frame(height: 260)
                    }

                    // Statistics Grid
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            // Avg Daily
                            StatCard(
                                icon: "chart.line.uptrend.xyaxis",
                                iconColor: .purple,
                                label: "Avg Daily",
                                value: "$\(String(format: "%.2f", avgDaily))"
                            )

                            // Total Spent
                            StatCard(
                                icon: "dollarsign.circle",
                                iconColor: .red,
                                label: "Total Spent",
                                value: "$\(String(format: "%.2f", totalSpent))"
                            )
                        }

                        // Savings Rate
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.08, green: 0.10, blue: 0.13))

                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.12, green: 0.14, blue: 0.18))
                                            .frame(width: 44, height: 44)

                                        Image(systemName: "chart.pie")
                                            .foregroundColor(.green)
                                            .font(.system(size: 18))
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Savings Rate")
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondaryText)

                                        Text("\(String(format: "%.1f", savingsRate)) %")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.primaryText)
                                    }

                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    }

                    // ML Models Section
                    if hasSufficientData {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Prediction Models")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primaryText)

                            // CoreML Model (if available)
                            if mlPrediction > 0 {
                                ModelCard(
                                    modelName: "CoreML Model",
                                    mae: mlMAE,
                                    prediction: mlPrediction,
                                    accentColor: .green,
                                    status: "Active"
                                )
                            }

                            // Fallback Model
                            ModelCard(
                                modelName: "Linear Regression",
                                mae: fallbackMAE,
                                prediction: fallbackPrediction,
                                accentColor: mlPrediction > 0 ? .orange : .green,
                                status: mlPrediction > 0 ? "Backup" : "Active"
                            )
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Prediction Models")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primaryText)

                            // Insufficient data card
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.08, green: 0.10, blue: 0.13))

                                VStack(spacing: 12) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 32))
                                        .foregroundColor(.orange)

                                    Text("Insufficient Data")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primaryText)

                                    Text("Add at least 3 transactions in the last 7 days to enable ML predictions")
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondaryText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 16)
                                }
                                .padding(.vertical, 24)
                            }
                        }
                    }

                    Spacer()
                        .frame(height: 100) // Padding for bottom tab bar
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            updateInsights()
        }
        .onChange(of: dataManager.transactions) { oldValue, newValue in
            updateInsights()
        }
    }

    // MARK: - Update Insights

    private func updateInsights() {
        let predictionService = SpendingPredictionService.shared

        // Check if we have sufficient data
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()

        let recentExpenses = dataManager.transactions.filter { transaction in
            !transaction.isIncome && transaction.date >= sevenDaysAgo
        }

        let monthExpenses = dataManager.transactions.filter { transaction in
            !transaction.isIncome && transaction.date >= thirtyDaysAgo
        }

        // Require at least 3 transactions in last 7 days
        if recentExpenses.count >= 3 {
            hasSufficientData = true

            // Try Core ML prediction first
            if let mlResult = predictionService.predictWithCoreML(transactions: dataManager.transactions) {
                mlPrediction = mlResult.prediction
                mlMAE = mlResult.mae
            } else {
                mlPrediction = 0
                mlMAE = 0
            }

            // Always calculate fallback prediction
            let fallbackResult = predictionService.predict7DaySpending(transactions: dataManager.transactions)
            fallbackPrediction = fallbackResult
            fallbackMAE = predictionService.calculateMAE(transactions: dataManager.transactions)

            // Use the best available prediction for forecast
            forecastAmount = mlPrediction > 0 ? mlPrediction : fallbackPrediction

        } else {
            hasSufficientData = false
            mlPrediction = 0
            mlMAE = 0
            fallbackPrediction = 0
            fallbackMAE = 0
            forecastAmount = 0
        }

        // Calculate statistics
        if !monthExpenses.isEmpty {
            totalSpent = monthExpenses.reduce(0) { $0 + $1.amount }
            let daysCovered = max(1, Calendar.current.dateComponents([.day], from: thirtyDaysAgo, to: Date()).day ?? 1)
            avgDaily = totalSpent / Double(daysCovered)
        } else {
            totalSpent = 0
            avgDaily = 0
        }

        // Calculate savings rate
        let income = dataManager.transactions.filter { transaction in
            transaction.isIncome && transaction.date >= thirtyDaysAgo
        }.reduce(0) { $0 + $1.amount }

        if income > 0 {
            let saved = income - totalSpent
            savingsRate = (saved / income) * 100
        } else {
            savingsRate = 0
        }
    }
}

struct StatCard: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.08, green: 0.10, blue: 0.13))

            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.12, green: 0.14, blue: 0.18))
                        .frame(width: 44, height: 44)

                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 18))
                }

                VStack(spacing: 4) {
                    Text(label)
                        .font(.system(size: 13))
                        .foregroundColor(.secondaryText)

                    Text(value)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primaryText)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

struct ModelCard: View {
    let modelName: String
    let mae: Double
    let prediction: Double
    let accentColor: Color
    var status: String = "Active"

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.08, green: 0.10, blue: 0.13))

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(modelName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)

                        Text(status)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(status == "Active" ? .green : .orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill((status == "Active" ? Color.green : Color.orange).opacity(0.2))
                            )
                    }

                    Text("MAE: $\(String(format: "%.2f", mae))")
                        .font(.system(size: 13))
                        .foregroundColor(.secondaryText)
                }

                Spacer()

                Text("$\(String(format: "%.2f", prediction))")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(accentColor)
            }
            .padding()
        }
    }
}

#Preview {
    InsightsView()
}
