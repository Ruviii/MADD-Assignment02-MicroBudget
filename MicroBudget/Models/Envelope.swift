//
//  Envelope.swift
//  MicroBudget
//
//  Created by Sujana Dinuwara on 2025-11-17.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class EnvelopeModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var allocated: Double
    var icon: String
    var colorHex: String
    var goal: Double?
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \TransactionModel.envelope)
    var transactions: [TransactionModel]?

    var user: User?

    init(id: UUID = UUID(), name: String, allocated: Double, icon: String, colorHex: String, goal: Double? = nil, user: User? = nil) {
        self.id = id
        self.name = name
        self.allocated = allocated
        self.icon = icon
        self.colorHex = colorHex
        self.goal = goal
        self.user = user
        self.createdAt = Date()
        self.transactions = []
    }

    var color: Color {
        Color(hex: colorHex) ?? .blue
    }
}

// Color extension to convert hex to Color
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else { return "000000" }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}
