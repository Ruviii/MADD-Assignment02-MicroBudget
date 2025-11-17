import Foundation
import SwiftUI
import SwiftData
internal import Combine

@MainActor
class DataManager: ObservableObject {
    var objectWillChange: ObservableObjectPublisher

    static let shared = DataManager()

    @Published var envelopes: [EnvelopeModel] = []
    @Published var transactions: [TransactionModel] = []

    private var modelContext: ModelContext?

    private init() {
        objectWillChange = ObservableObjectPublisher()
    }

    func setModelContext(_ context: ModelContext) {
        print("📱 DataManager: Setting ModelContext")
        self.modelContext = context
        loadData()
    }

    func reloadData() {
        print("🔄 DataManager: Reloading data for current user")
        loadData()
    }

    // MARK: - Envelope Operations

    func addEnvelope(_ envelope: EnvelopeModel) {
        guard let context = modelContext else {
            print("⚠️ DataManager: ModelContext not set when adding envelope")
            return
        }

        // Set the current user if not in guest mode
        if !AuthManager.shared.isGuestMode {
            envelope.user = AuthManager.shared.currentUser
        }

        context.insert(envelope)
        do {
            try context.save()
            print("✅ Envelope saved: \(envelope.name)")
            // Update published array
            objectWillChange.send()
            envelopes.append(envelope)
        } catch {
            print("❌ Error saving envelope: \(error)")
        }
    }

    func updateEnvelope(_ envelope: EnvelopeModel) {
        guard let context = modelContext else { return }

        try? context.save()

        // Update published array
        objectWillChange.send()
        if let index = envelopes.firstIndex(where: { $0.id == envelope.id }) {
            envelopes[index] = envelope
        }
    }

    func deleteEnvelope(_ envelope: EnvelopeModel) {
        guard let context = modelContext else { return }

        context.delete(envelope)
        try? context.save()

        // Update published array
        objectWillChange.send()
        envelopes.removeAll { $0.id == envelope.id }
    }

    func getEnvelope(byId id: UUID) -> EnvelopeModel? {
        return envelopes.first { $0.id == id }
    }

    func moveEnvelope(from source: IndexSet, to destination: Int) {
        objectWillChange.send()
        envelopes.move(fromOffsets: source, toOffset: destination)
    }

    // MARK: - Transaction Operations

    func addTransaction(_ transaction: TransactionModel) {
        guard let context = modelContext else {
            print("⚠️ DataManager: ModelContext not set when adding transaction")
            return
        }

        // Set the current user if not in guest mode
        if !AuthManager.shared.isGuestMode {
            transaction.user = AuthManager.shared.currentUser
        }

        context.insert(transaction)
        do {
            try context.save()
            print("✅ Transaction saved: \(transaction.merchant)")
            // Update published array
            objectWillChange.send()
            transactions.append(transaction)
        } catch {
            print("❌ Error saving transaction: \(error)")
        }
    }

    func updateTransaction(_ transaction: TransactionModel) {
        guard let context = modelContext else { return }

        try? context.save()

        // Update published array
        objectWillChange.send()
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
        }
    }

    func deleteTransaction(_ transaction: TransactionModel) {
        guard let context = modelContext else { return }

        context.delete(transaction)
        try? context.save()

        // Update published array
        objectWillChange.send()
        transactions.removeAll { $0.id == transaction.id }
    }

    func getTransactions(for envelope: EnvelopeModel) -> [TransactionModel] {
        return envelope.transactions ?? []
    }

    func getSpentAmount(for envelope: EnvelopeModel) -> Double {
        let envelopeTransactions = envelope.transactions ?? []
        return envelopeTransactions
            .filter { !$0.isIncome }
            .reduce(0) { $0 + $1.amount }
    }

    // MARK: - Analytics

    func getTotalBalance() -> Double {
        let income = transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
        let expenses = transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
        return income - expenses
    }

    func getRecentTransactions(limit: Int = 10) -> [TransactionModel] {
        return Array(transactions.sorted { $0.date > $1.date }.prefix(limit))
    }

    func getTransactionsByDate() -> [(String, [TransactionModel])] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"

        let grouped = Dictionary(grouping: transactions.sorted { $0.date > $1.date }) { transaction in
            dateFormatter.string(from: transaction.date)
        }

        return grouped.sorted { $0.key > $1.key }
    }

    // MARK: - Data Loading

    private func loadData() {
        guard let context = modelContext else {
            print("⚠️ DataManager: ModelContext not available in loadData")
            return
        }

        print("📂 DataManager: Loading data from SwiftData...")

        // Get current user
        let currentUser = AuthManager.shared.currentUser
        let isGuestMode = AuthManager.shared.isGuestMode

        // Load envelopes
        if let user = currentUser, !isGuestMode {
            // Filter by current user
            let userId = user.id
            let envelopeDescriptor = FetchDescriptor<EnvelopeModel>(
                predicate: #Predicate<EnvelopeModel> { envelope in
                    envelope.user?.id == userId
                },
                sortBy: [SortDescriptor(\.createdAt)]
            )
            if let fetchedEnvelopes = try? context.fetch(envelopeDescriptor) {
                print("📊 Loaded \(fetchedEnvelopes.count) envelopes for current user")
                objectWillChange.send()
                envelopes = fetchedEnvelopes
            }
        } else {
            // Guest mode or no user - show only envelopes without a user
            let envelopeDescriptor = FetchDescriptor<EnvelopeModel>(
                predicate: #Predicate<EnvelopeModel> { envelope in
                    envelope.user == nil
                },
                sortBy: [SortDescriptor(\.createdAt)]
            )
            if let fetchedEnvelopes = try? context.fetch(envelopeDescriptor) {
                print("📊 Loaded \(fetchedEnvelopes.count) envelopes for guest mode")
                objectWillChange.send()
                envelopes = fetchedEnvelopes
            }
        }

        // Load transactions
        if let user = currentUser, !isGuestMode {
            // Filter by current user
            let userId = user.id
            let transactionDescriptor = FetchDescriptor<TransactionModel>(
                predicate: #Predicate<TransactionModel> { transaction in
                    transaction.user?.id == userId
                },
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            if let fetchedTransactions = try? context.fetch(transactionDescriptor) {
                print("📊 Loaded \(fetchedTransactions.count) transactions for current user")
                objectWillChange.send()
                transactions = fetchedTransactions
            }
        } else {
            // Guest mode or no user - show only transactions without a user
            let transactionDescriptor = FetchDescriptor<TransactionModel>(
                predicate: #Predicate<TransactionModel> { transaction in
                    transaction.user == nil
                },
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            if let fetchedTransactions = try? context.fetch(transactionDescriptor) {
                print("📊 Loaded \(fetchedTransactions.count) transactions for guest mode")
                objectWillChange.send()
                transactions = fetchedTransactions
            }
        }
    }

    // MARK: - Clear Data

    func clearAllData() {
        guard let context = modelContext else { return }

        // Delete all envelopes (transactions will cascade delete)
        for envelope in envelopes {
            context.delete(envelope)
        }

        // Delete all transactions
        for transaction in transactions {
            context.delete(transaction)
        }

        try? context.save()

        // Clear published arrays
        objectWillChange.send()
        envelopes = []
        transactions = []
    }
}
