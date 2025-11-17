import Foundation
import SwiftUI
import SwiftData

@Model
final class TransactionModel {
    @Attribute(.unique) var id: UUID
    var merchant: String
    var amount: Double
    var isIncome: Bool
    var date: Date
    var note: String?
    var icon: String
    var colorHex: String
    var createdAt: Date

    var envelope: EnvelopeModel?
    var user: User?

    init(
        id: UUID = UUID(),
        merchant: String,
        amount: Double,
        isIncome: Bool,
        envelope: EnvelopeModel? = nil,
        date: Date = Date(),
        note: String? = nil,
        icon: String = "cart",
        colorHex: String = "00FF00",
        user: User? = nil
    ) {
        self.id = id
        self.merchant = merchant
        self.amount = amount
        self.isIncome = isIncome
        self.envelope = envelope
        self.date = date
        self.note = note
        self.icon = icon
        self.colorHex = colorHex
        self.user = user
        self.createdAt = Date()
    }

    var color: Color {
        Color(hex: colorHex) ?? .green
    }
}
