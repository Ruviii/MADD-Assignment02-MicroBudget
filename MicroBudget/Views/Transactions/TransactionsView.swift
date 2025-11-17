//
//  TransactionsView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct TransactionsView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showAddTransaction = false
    @State private var searchText = ""

    var filteredTransactionsByDate: [(String, [TransactionModel])] {
        let filtered = searchText.isEmpty ? dataManager.transactions : dataManager.transactions.filter {
            $0.merchant.lowercased().contains(searchText.lowercased())
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"

        let grouped = Dictionary(grouping: filtered.sorted { $0.date > $1.date }) { transaction in
            dateFormatter.string(from: transaction.date)
        }

        return grouped.sorted { $0.key > $1.key }
    }

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
                if dataManager.transactions.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()

                        Image(systemName: "list.bullet.rectangle")
                            .font(.system(size: 60))
                            .foregroundColor(.secondaryText)

                        Text("No Transactions Yet")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primaryText)

                        Text("Add your first transaction to start tracking your expenses")
                            .font(.system(size: 14))
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        Spacer()
                    }
                } else if filteredTransactionsByDate.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()

                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.secondaryText)

                        Text("No Results Found")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primaryText)

                        Text("Try searching with different keywords")
                            .font(.system(size: 14))
                            .foregroundColor(.secondaryText)

                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(filteredTransactionsByDate, id: \.0) { dateGroup in
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
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView(isPresented: $showAddTransaction)
        }
    }
}

struct TransactionListRow: View {
    let transaction: TransactionModel

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(red: 0.12, green: 0.14, blue: 0.18))
                    .frame(width: 44, height: 44)

                Image(systemName: transaction.icon)
                    .foregroundColor(transaction.color)
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

#Preview {
    TransactionsView()
}
