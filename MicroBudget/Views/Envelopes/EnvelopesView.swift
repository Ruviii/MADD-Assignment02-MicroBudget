//
//  EnvelopesView.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import SwiftUI

struct EnvelopesView: View {
    @State private var showAddEnvelopesModal = false
    @State private var showAddEnvelope1Form = false
    @State private var envelopes: [Envelope] = [
        Envelope(name: "Grocerie", icon: "cart", color: .green, allocated: 300, spent: 160),
        Envelope(name: "Transpo", icon: "car", color: .purple, allocated: 100, spent: 40),
        Envelope(name: "Savings", icon: "bag", color: .orange, allocated: 500, spent: 180),
        Envelope(name: "Entertain", icon: "ticket", color: .pink, allocated: 120, spent: 80)
    ]

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Envelopes")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primaryText)

                        Text("Track your budget categories")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.secondaryText)
                    }

                    Spacer()

//                    Button(action: {
//                        showAddEnvelopesModal = true
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
                .padding(.bottom, 20)

                // Add Envelope Button
                Button(action: {
                    showAddEnvelopesModal = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Add Envelope")
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

                // Envelopes List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(envelopes) { envelope in
                            EnvelopeCard(envelope: envelope)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()
            }

            // Add Envelope 1 Form Overlay
            if showAddEnvelope1Form {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showAddEnvelope1Form = false
                    }

                VStack {
                    AddEnvelope1View(
                        isPresented: $showAddEnvelope1Form,
                        onSave: { name, amount in
                            // Handle save
                            showAddEnvelope1Form = false
                        }
                    )
                    .padding(.top, 80)
                    .padding(.horizontal, 24)

                    Spacer()
                }
                .transition(.move(edge: .top))
            }
        }
        .sheet(isPresented: $showAddEnvelopesModal) {
            AddEnvelopesView(isPresented: $showAddEnvelopesModal)
        }
    }
}

struct EnvelopeCard: View {
    let envelope: Envelope

    var body: some View {
        HStack(spacing: 16) {
            // Drag handle
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.tertiaryText)
                .font(.system(size: 16))

            // Progress circle
            ZStack {
                Circle()
                    .stroke(Color(red: 0.15, green: 0.17, blue: 0.20), lineWidth: 6)
                    .frame(width: 60, height: 60)

                Circle()
                    .trim(from: 0, to: envelope.percentage / 100)
                    .stroke(envelope.color, lineWidth: 6)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))

                Text("\(Int(envelope.percentage)) %")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primaryText)
            }

            // Envelope details
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: envelope.icon)
                        .foregroundColor(envelope.color)
                        .font(.system(size: 16))

                    Text(envelope.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primaryText)
                }

                Text("Allocated")
                    .font(.system(size: 12))
                    .foregroundColor(.secondaryText)

                Text("$\(String(format: "%.2f", envelope.allocated))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondaryText)

                Text("Spent")
                    .font(.system(size: 12))
                    .foregroundColor(.secondaryText)

                Text("$\(String(format: "%.2f", envelope.spent))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondaryText)

                Text("$\(String(format: "%.2f", envelope.remaining))")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.green)

                Text("remaining")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
            }

            Spacer()

            // Action buttons
            VStack(spacing: 16) {
                Button(action: {
                    // Add transaction
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                        .font(.system(size: 20, weight: .semibold))
                }

                Button(action: {
                    // Show menu
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondaryText)
                        .font(.system(size: 20))
                }
            }
        }
        .padding(16)
        .background(Color(red: 0.08, green: 0.10, blue: 0.13))
        .cornerRadius(12)
    }
}

// Envelope model
struct Envelope: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let allocated: Double
    let spent: Double

    var remaining: Double {
        allocated - spent
    }

    var percentage: Double {
        allocated > 0 ? (spent / allocated) * 100 : 0
    }
}

#Preview {
    EnvelopesView()
}
