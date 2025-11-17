//
//  AddEnvelopesView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct AddEnvelopesView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Binding var isPresented: Bool
    @State private var envelopeName = ""
    @State private var allocatedAmount = "0.00"
    @State private var seedWithTransaction = false
    @State private var selectedColorIndex = 0
    @State private var selectedIconIndex = 0
    @State private var goalAmount = ""
    @State private var showError = false
    @State private var errorMessage = ""

    let colors: [Color] = [
        Color(red: 0.4, green: 0.4, blue: 1.0),   // Purple
        Color(red: 0.5, green: 0.3, blue: 1.0),   // Deep Purple
        Color(red: 0.0, green: 0.8, blue: 1.0),   // Cyan
        Color(red: 0.0, green: 0.9, blue: 0.5),   // Green
        Color(red: 1.0, green: 0.7, blue: 0.0),   // Orange
        Color(red: 1.0, green: 0.4, blue: 0.4),   // Coral
        Color(red: 1.0, green: 0.2, blue: 0.6),   // Pink
        Color(red: 0.5, green: 0.5, blue: 1.0),   // Light Purple
        Color(red: 0.3, green: 0.8, blue: 0.7),   // Teal
        Color(red: 1.0, green: 0.5, blue: 0.2)    // Orange Red
    ]

    let icons = [
        "cart", "car", "megaphone", "house", "fork.knife",
        "airplane", "heart", "graduationcap", "tshirt", "creditcard",
        "cup.and.saucer", "film"
    ]

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Add Envelope")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primaryText)

                    Spacer()

                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primaryText)
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 24)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Envelope name
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Envelope name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            TextField("e.g., Groceries", text: $envelopeName)
                                .font(.system(size: 16))
                                .foregroundColor(.primaryText)
                                .padding()
                                .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                                .cornerRadius(12)
                        }

                        // Allocated Amount
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Allocated Amount")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            TextField("0.00", text: $allocatedAmount)
                                .font(.system(size: 16))
                                .foregroundColor(.primaryText)
                                .padding()
                                .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                                .cornerRadius(12)
                                .keyboardType(.decimalPad)
                        }

                        // Seed with initial transaction toggle
                        HStack {
                            Text("Seed with initial transaction")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.primaryText)

                            Spacer()

                            Toggle("", isOn: $seedWithTransaction)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .primaryAccent))
                        }

                        // Color selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Color")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                                ForEach(0..<colors.count, id: \.self) { index in
                                    Circle()
                                        .fill(colors[index])
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: selectedColorIndex == index ? 3 : 0)
                                        )
                                        .onTapGesture {
                                            selectedColorIndex = index
                                        }
                                }
                            }
                        }

                        // Icon selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Icon")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                                ForEach(0..<icons.count, id: \.self) { index in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedIconIndex == index ? Color.primaryAccent : Color(red: 0.12, green: 0.14, blue: 0.18))
                                            .frame(width: 50, height: 50)

                                        Image(systemName: icons[index])
                                            .foregroundColor(.primaryText)
                                            .font(.system(size: 20))
                                    }
                                    .onTapGesture {
                                        selectedIconIndex = index
                                    }
                                }
                            }
                        }

                        // Goal (optional)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Goal (optional)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryText)

                            TextField("Target amount", text: $goalAmount)
                                .font(.system(size: 16))
                                .foregroundColor(.primaryText)
                                .padding()
                                .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                                .cornerRadius(12)
                                .keyboardType(.decimalPad)
                        }

                        // Buttons
                        HStack(spacing: 16) {
                            Button(action: {
                                handleCreateEnvelope()
                            }) {
                                Text("Create Envelope")
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
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Create Envelope Handler

    private func handleCreateEnvelope() {
        // Validate inputs
        guard !envelopeName.isEmpty else {
            errorMessage = "Please enter an envelope name"
            showError = true
            return
        }

        guard let amount = Double(allocatedAmount), amount > 0 else {
            errorMessage = "Please enter a valid allocated amount"
            showError = true
            return
        }

        let goal = Double(goalAmount)

        // Create envelope
        let envelope = EnvelopeModel(
            name: envelopeName,
            allocated: amount,
            icon: icons[selectedIconIndex],
            colorHex: colors[selectedColorIndex].toHex(),
            goal: goal
        )

        // Save envelope
        dataManager.addEnvelope(envelope)

        // Create initial transaction if requested
        if seedWithTransaction {
            let transaction = TransactionModel(
                merchant: "Initial Balance - \(envelopeName)",
                amount: amount,
                isIncome: true,
                envelope: envelope,
                icon: icons[selectedIconIndex],
                colorHex: colors[selectedColorIndex].toHex()
            )
            dataManager.addTransaction(transaction)
        }

        // Close modal
        isPresented = false
    }
}

#Preview {
    AddEnvelopesView(isPresented: .constant(true))
}
