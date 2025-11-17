//
//  AddTransactionView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct AddTransactionView: View {
    @Binding var isPresented: Bool
    @State private var amount = ""
    @State private var selectedEnvelope = "Groceries"
    @State private var selectedDate = Date()
    @State private var merchant = ""
    @State private var note = ""
    @State private var isIncome = false

    let envelopes = ["Groceries", "Transport", "Savings", "Entertainment"]

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

                    Button(action: {
                        isPresented = false
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Add")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.primaryText)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Amount input
                        HStack(spacing: 8) {
                            Button(action: {
                                isIncome.toggle()
                            }) {
                                Image(systemName: isIncome ? "arrow.down" : "arrow.up")
                                    .foregroundColor(.secondaryText)
                                    .font(.system(size: 20))
                            }

                            TextField("0.00", text: $amount)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.primaryText)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)

                            Button(action: {
                                // Toggle currency or clear
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondaryText)
                                    .font(.system(size: 20))
                            }
                        }
                        .padding()
                        .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                        .cornerRadius(12)

                        // Envelope selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Envelope")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(envelopes, id: \.self) { envelope in
                                        Button(action: {
                                            selectedEnvelope = envelope
                                        }) {
                                            Text(envelope)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.primaryText)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .background(
                                                    selectedEnvelope == envelope
                                                        ? Color.primaryAccent
                                                        : Color(red: 0.12, green: 0.14, blue: 0.18)
                                                )
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                        }

                        // Date selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Date")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            HStack {
                                DatePicker(
                                    "",
                                    selection: $selectedDate,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .colorScheme(.dark)
                                .accentColor(.primaryAccent)
                                .frame(maxWidth: .infinity, alignment: .leading)

                                Image(systemName: "calendar")
                                    .foregroundColor(.secondaryText)
                            }
                            .padding()
                            .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                            .cornerRadius(12)
                        }

                        // Merchant field
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Merchant")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            TextField("e.g., Whole Foods", text: $merchant)
                                .font(.system(size: 16))
                                .foregroundColor(.primaryText)
                                .padding()
                                .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                                .cornerRadius(12)
                        }

                        // Note field
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Note (optional)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            TextField("Add a note...", text: $note)
                                .font(.system(size: 16))
                                .foregroundColor(.primaryText)
                                .padding()
                                .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                                .cornerRadius(12)
                        }

                        // Attach receipt
                        Button(action: {
                            // Handle attach receipt
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "paperclip")
                                    .font(.system(size: 16))
                                Text("Attach receipt")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundColor(.primaryAccent)
                        }
                        .padding(.top, 8)

                        // Buttons
                        HStack(spacing: 16) {
                            Button(action: {
                                // Save transaction
                                isPresented = false
                            }) {
                                Text("Save Transaction")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.primaryAccent)
                                    .cornerRadius(12)
                            }

                            Button(action: {
                                isPresented = false
                            }) {
                                Text("Cancel")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primaryAccent)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

#Preview {
    AddTransactionView(isPresented: .constant(true))
}
