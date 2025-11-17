import Foundation
import CoreML

@MainActor
class SpendingPredictionService {
    static let shared = SpendingPredictionService()

    private init() {}

    // MARK: - Simple Linear Regression Prediction (Fallback)

    /// Predicts 7-day spending using historical data
    func predict7DaySpending(transactions: [TransactionModel]) -> Double {
        // Filter only expense transactions from last 30 days
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentExpenses = transactions.filter { transaction in
            !transaction.isIncome && transaction.date >= thirtyDaysAgo
        }

        guard !recentExpenses.isEmpty else {
            return 0.0
        }

        // Calculate daily average spending
        let totalSpent = recentExpenses.reduce(0.0) { $0 + $1.amount }
        let daysCovered = max(1, Calendar.current.dateComponents([.day], from: thirtyDaysAgo, to: Date()).day ?? 1)
        let dailyAverage = totalSpent / Double(daysCovered)

        // Predict 7-day spending
        let predicted7DaySpend = dailyAverage * 7

        // Apply trend factor (are we spending more or less recently?)
        let trendFactor = calculateTrendFactor(transactions: recentExpenses)

        return predicted7DaySpend * trendFactor
    }

    /// Calculate Mean Absolute Error for the prediction
    func calculateMAE(transactions: [TransactionModel]) -> Double {
        let fourteenDaysAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        // Get actual spending from last 7 days
        let last7DaysExpenses = transactions.filter { transaction in
            !transaction.isIncome && transaction.date >= sevenDaysAgo && transaction.date < Date()
        }
        let actualSpending = last7DaysExpenses.reduce(0.0) { $0 + $1.amount }

        // Get transactions from 14-7 days ago to make prediction
        let priorTransactions = transactions.filter { transaction in
            transaction.date >= fourteenDaysAgo && transaction.date < sevenDaysAgo
        }

        guard !priorTransactions.isEmpty else {
            return 12.5 // Default MAE
        }

        // Calculate what we would have predicted 7 days ago
        let predictedSpending = predict7DaySpending(transactions: priorTransactions)

        // Calculate absolute error
        let mae = abs(actualSpending - predictedSpending)

        return mae
    }

    // MARK: - Helper Functions

    private func calculateTrendFactor(transactions: [TransactionModel]) -> Double {
        guard transactions.count >= 7 else { return 1.0 }

        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        // Recent spending (last 7 days)
        let recentExpenses = transactions.filter { $0.date >= sevenDaysAgo }
        let recentTotal = recentExpenses.reduce(0.0) { $0 + $1.amount }

        // Older spending (7-14 days ago)
        let fourteenDaysAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        let olderExpenses = transactions.filter { $0.date >= fourteenDaysAgo && $0.date < sevenDaysAgo }
        let olderTotal = olderExpenses.reduce(0.0) { $0 + $1.amount }

        guard olderTotal > 0 else { return 1.0 }

        // Calculate trend (1.0 = no change, >1.0 = increasing, <1.0 = decreasing)
        let trend = recentTotal / olderTotal

        // Limit trend factor to reasonable range (0.5x to 1.5x)
        return max(0.5, min(1.5, trend))
    }

    // MARK: - Feature Extraction for ML

    /// Extract features from transaction history for ML model
    func extractFeatures(transactions: [TransactionModel]) -> [String: Double] {
        let calendar = Calendar.current
        let now = Date()

        // Time-based filters
        let last7Days = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        let last14Days = calendar.date(byAdding: .day, value: -14, to: now) ?? now
        let last30Days = calendar.date(byAdding: .day, value: -30, to: now) ?? now

        // Filter expenses only
        let expenses = transactions.filter { !$0.isIncome }

        // Calculate features
        let last7DaysSpending = expenses.filter { $0.date >= last7Days }.reduce(0.0) { $0 + $1.amount }
        let last14DaysSpending = expenses.filter { $0.date >= last14Days }.reduce(0.0) { $0 + $1.amount }
        let last30DaysSpending = expenses.filter { $0.date >= last30Days }.reduce(0.0) { $0 + $1.amount }

        let avgDailyLast7 = last7DaysSpending / 7.0
        let avgDailyLast14 = last14DaysSpending / 14.0
        let avgDailyLast30 = last30DaysSpending / 30.0

        // Day of week (0 = Sunday, 6 = Saturday)
        let dayOfWeek = Double(calendar.component(.weekday, from: now) - 1)

        // Day of month (1-31)
        let dayOfMonth = Double(calendar.component(.day, from: now))

        // Transaction count
        let transactionCount7Days = Double(expenses.filter { $0.date >= last7Days }.count)

        return [
            "last_7_days_spending": last7DaysSpending,
            "last_14_days_spending": last14DaysSpending,
            "last_30_days_spending": last30DaysSpending,
            "avg_daily_last_7": avgDailyLast7,
            "avg_daily_last_14": avgDailyLast14,
            "avg_daily_last_30": avgDailyLast30,
            "day_of_week": dayOfWeek,
            "day_of_month": dayOfMonth,
            "transaction_count_7_days": transactionCount7Days
        ]
    }

    // MARK: - Core ML Integration

    /// Predict using Core ML model (when available)
    func predictWithCoreML(transactions: [TransactionModel]) -> (prediction: Double, mae: Double)? {
        // TODO: Add your trained Core ML model here
        // Steps to integrate:
        // 1. Train model using Create ML or Python (see instructions below)
        // 2. Drag .mlmodel file into Xcode
        // 3. Uncomment and update the code below

        /*
        Example integration when you have a .mlmodel file:

        do {
            // Initialize your Core ML model
            let model = try SpendingPredictorModel(configuration: MLModelConfiguration())

            // Extract features
            let features = extractFeatures(transactions: transactions)

            // Create input for the model
            let input = try SpendingPredictorModelInput(
                last_7_days_spending: features["last_7_days_spending"] ?? 0,
                last_14_days_spending: features["last_14_days_spending"] ?? 0,
                last_30_days_spending: features["last_30_days_spending"] ?? 0,
                avg_daily_last_7: features["avg_daily_last_7"] ?? 0,
                avg_daily_last_14: features["avg_daily_last_14"] ?? 0,
                avg_daily_last_30: features["avg_daily_last_30"] ?? 0,
                day_of_week: features["day_of_week"] ?? 0,
                day_of_month: features["day_of_month"] ?? 0,
                transaction_count_7_days: features["transaction_count_7_days"] ?? 0
            )

            // Get prediction
            let output = try model.prediction(input: input)

            // Return prediction and MAE
            // Note: Your model should output 'predicted_spending' and optionally 'mae'
            return (prediction: output.predicted_spending, mae: output.mae ?? calculateMAE(transactions: transactions))

        } catch {
            print("❌ Core ML prediction failed: \(error)")
            return nil
        }
        */

        // Return nil to use fallback prediction
        return nil
    }

    // MARK: - Public Prediction Method

    /// Main prediction method - tries Core ML first, falls back to simple regression
    func getPrediction(transactions: [TransactionModel]) -> (prediction: Double, mae: Double) {
        // Try Core ML model first
        if let mlPrediction = predictWithCoreML(transactions: transactions) {
            print("📊 Using Core ML prediction: $\(String(format: "%.2f", mlPrediction.prediction))")
            return mlPrediction
        }

        // Fallback to simple linear regression
        print("📊 Using fallback prediction (Core ML model not available)")
        let prediction = predict7DaySpending(transactions: transactions)
        let mae = calculateMAE(transactions: transactions)

        return (prediction: prediction, mae: mae)
    }
}
