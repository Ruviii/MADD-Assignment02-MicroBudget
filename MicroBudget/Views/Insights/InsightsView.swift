//
//  InsightsView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct InsightsView: View {
    @State private var forecastAmount: Double = 210
    @State private var avgDaily: Double = 62.97
    @State private var totalSpent: Double = 1889.00
    @State private var savingsRate: Double = 22.0

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
                                HStack {
                                    Text("Forecast (7 days)")
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondaryText)

                                    Spacer()

                                    Text("$\(Int(forecastAmount))")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.orange)
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
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
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Prediction Models")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)

                        // CoreML Model
                        ModelCard(
                            modelName: "CoreML Model",
                            mae: 12.5,
                            prediction: 210,
                            accentColor: .green
                        )

                        // Fallback Model
                        ModelCard(
                            modelName: "Fallback Model",
                            mae: 18.3,
                            prediction: 225,
                            accentColor: .orange
                        )
                    }

                    Spacer()
                        .frame(height: 100) // Padding for bottom tab bar
                }
                .padding(.horizontal, 24)
            }
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

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.08, green: 0.10, blue: 0.13))

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(modelName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primaryText)

                    Text("MAE:  \(String(format: "%.1f", mae))")
                        .font(.system(size: 13))
                        .foregroundColor(.secondaryText)
                }

                Spacer()

                Text("$\(Int(prediction))")
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
