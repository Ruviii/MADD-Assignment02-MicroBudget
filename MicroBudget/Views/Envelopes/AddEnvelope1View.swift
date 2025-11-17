//
//  AddEnvelope1View.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct AddEnvelope1View: View {
    @Binding var isPresented: Bool
    @State private var envelopeName = ""
    @State private var amount = ""

    var onSave: (String, String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Envelope name field
                TextField("Envelope name", text: $envelopeName)
                    .font(.system(size: 16))
                    .foregroundColor(.primaryText)
                    .padding()
                    .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                    .cornerRadius(12)

                // Amount field
                TextField("0.00", text: $amount)
                    .font(.system(size: 16))
                    .foregroundColor(.primaryText)
                    .padding()
                    .background(Color(red: 0.12, green: 0.14, blue: 0.18))
                    .cornerRadius(12)
                    .keyboardType(.decimalPad)
                    .frame(width: 100)
            }
            .padding(.bottom, 12)

            HStack(spacing: 12) {
                // Save button
                Button(action: {
                    onSave(envelopeName, amount)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Save")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.primaryAccent)
                    .cornerRadius(12)
                }

                // Cancel button
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondaryText)
                        .padding(.vertical, 14)
                }
            }
        }
        .padding(16)
        .background(Color(red: 0.08, green: 0.10, blue: 0.13))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primaryAccent, lineWidth: 2)
        )
    }
}

#Preview {
    ZStack {
        Color.appBackground
            .ignoresSafeArea()

        AddEnvelope1View(
            isPresented: .constant(true),
            onSave: { _, _ in }
        )
        .padding()
    }
}
