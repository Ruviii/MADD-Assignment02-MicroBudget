import Foundation
import SwiftData
import CryptoKit

@Model
final class User {
    @Attribute(.unique) var id: UUID
    var fullName: String
    var email: String
    var passwordHash: String
    var createdAt: Date

    init(id: UUID = UUID(), fullName: String, email: String, password: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.passwordHash = password.sha256Hash()
        self.createdAt = Date()
    }
}

// SHA256 hashing extension
extension String {
    func sha256Hash() -> String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    func matches(hash: String) -> Bool {
        return self.sha256Hash() == hash
    }
}
