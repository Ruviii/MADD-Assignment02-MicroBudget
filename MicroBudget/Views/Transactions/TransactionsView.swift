//
//  TransactionsView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct TransactionsView: View {
    @State private var showAddTransaction = false
    @State private var searchText = ""

    // Sample data grouped by date
    let transactionsByDate: [(String, [Transaction])] = [
        ("November 16, 2025", [
            Transaction(merchant: "Salary Deposit", amount: 2500, isIncome: true, icon: "arrow.left.arrow.right", iconColor: .purple),
            Transaction(merchant: "Whole Foods", amount: 69.00, isIncome: false, icon: "cart", iconColor: .green),
            Transaction(merchant: "Target Store", amount: 45.00, isIncome: false, icon: "cart", iconColor: .green)
        ]),
        ("November 15, 2025", [
            Transaction(merchant: "Fuel Station", amount: 81.00, isIncome: false, icon: "fuelpump", iconColor: .orange),
            Transaction(merchant: "Cafe Bistro", amount: 12.50, isIncome: false, icon: "cup.and.saucer", iconColor: .pink)
        ]),
        ("November 14, 2025", [
            Transaction(merchant: "Netflix", amount: 15.99, isIncome: false, icon: "tv", iconColor: .red),
            Transaction(merchant: "Uber", amount: 23.00, isIncome: false, icon: "car", iconColor: .purple)
        ]),
        ("November 13, 2025", [
            Transaction(merchant: "Freelance Work", amount: 450.00, isIncome: true, icon: "briefcase", iconColor: .blue),
            Transaction(merchant: "Restaurant", amount: 67.00, isIncome: false, icon: "fork.knife", iconColor: .orange)
        ]),
        ("November 12, 2025", [
            Transaction(merchant: "Grocery Store", amount: 89.00, isIncome: false, icon: "cart", iconColor: .green),
            Transaction(merchant: "Pharmacy", amount: 34.50, isIncome: false, icon: "cross.case", iconColor: .red)
        ])
    ]

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Transactions")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primaryText)

                        Text("View and manage all transactions")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.secondaryText)
                    }

                    Spacer()

//                    Button(action: {
//                        showAddTransaction = true
//                    }) {
//                        HStack(spacing: 6) {
//                            Image(systemName: "plus")
//                                .font(.system(size: 16, weight: .semibold))
//                            Text("Add")
//                                .font(.system(size: 16, weight: .semibold))
//                        }
//                        .foregroundColor(.primaryText)
//                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 16)

                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondaryText)

                    TextField("Search transactions...", text: $searchText)
                        .font(.system(size: 16))
                        .foregroundColor(.primaryText)
                }
                .padding()
                .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                // Add transaction Button
                Button(action: {
                    showAddTransaction = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Add Transaction")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primaryAccent)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)

                // Transactions list
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(transactionsByDate, id: \.0) { dateGroup in
                            VStack(alignment: .leading, spacing: 12) {
                                // Date header
                                Text(dateGroup.0)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondaryText)
                                    .padding(.horizontal, 24)

                                // Transactions for this date
                                VStack(spacing: 8) {
                                    ForEach(dateGroup.1) { transaction in
                                        TransactionListRow(transaction: transaction)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                    .padding(.bottom, 100) // Extra padding for tab bar
                }
            }
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView(isPresented: $showAddTransaction)
        }
    }
}

struct TransactionListRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(red: 0.12, green: 0.14, blue: 0.18))
                    .frame(width: 44, height: 44)

                Image(systemName: transaction.icon)
                    .foregroundColor(transaction.iconColor)
                    .font(.system(size: 18))
            }

            // Merchant name
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchant)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primaryText)

                if let note = transaction.note {
                    Text(note)
                        .font(.system(size: 13))
                        .foregroundColor(.secondaryText)
                }
            }

            Spacer()

            // Amount
            Text("\(transaction.isIncome ? "+" : "-")$\(String(format: "%.2f", transaction.amount))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(transaction.isIncome ? .green : .red)
        }
        .padding(12)
        .background(Color(red: 0.08, green: 0.10, blue: 0.13))
        .cornerRadius(12)
    }
}

// Transaction model
struct Transaction: Identifiable {
    let id = UUID()
    let merchant: String
    let amount: Double
    let isIncome: Bool
    let icon: String
    let iconColor: Color
    var note: String? = nil
    var envelope: String? = nil
}

#Preview {
    TransactionsView()
}
