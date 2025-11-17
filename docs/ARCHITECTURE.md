# 🏗️ Architecture Overview

<div align="center">

![Architecture](https://img.shields.io/badge/Architecture-MVVM-blueviolet?style=for-the-badge)
[![SwiftUI](https://img.shields.io/badge/Pattern-Coordinator-green?style=for-the-badge)](https://developer.apple.com/documentation/swiftui)

</div>

---

## 📋 Table of Contents

- [High-Level Architecture](#-high-level-architecture)
- [MVVM Pattern](#-mvvm-pattern)
- [Data Flow](#-data-flow)
- [State Management](#-state-management)
- [Navigation Architecture](#-navigation-architecture)
- [Persistence Layer](#-persistence-layer)
- [Service Layer](#-service-layer)
- [Security Architecture](#-security-architecture)

---

## 🌐 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      MicroBudget App                        │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  View Layer  │     │Service Layer │     │ Model Layer  │
│   (SwiftUI)  │────▶│  (Managers)  │────▶│ (SwiftData)  │
└──────────────┘     └──────────────┘     └──────────────┘
        │                     │                     │
        │                     ▼                     │
        │            ┌──────────────┐              │
        └───────────▶│  ML Service  │◀─────────────┘
                     │  (Core ML)   │
                     └──────────────┘
```

### Layer Responsibilities

| Layer | Responsibility | Examples |
|-------|---------------|----------|
| **View** | UI rendering, user interaction | `HomeView`, `TransactionsView` |
| **Service** | Business logic, data operations | `AuthManager`, `DataManager` |
| **Model** | Data structures, persistence | `User`, `Envelope`, `Transaction` |
| **ML** | Predictions, feature engineering | `SpendingPredictionService` |

---

## 🎯 MVVM Pattern

### Structure

```
┌──────────────────────────────────────────────────────────┐
│                        View (V)                          │
│  ┌────────────────────────────────────────────────┐     │
│  │         SwiftUI View Components                │     │
│  │  • Declarative UI                              │     │
│  │  • State observation                           │     │
│  │  • User interaction handling                   │     │
│  └────────────────────────────────────────────────┘     │
└─────────────────┬────────────────────────────────────────┘
                  │ @ObservedObject / @Published
                  │
┌─────────────────▼────────────────────────────────────────┐
│                    ViewModel (VM)                        │
│  ┌────────────────────────────────────────────────┐     │
│  │          Manager Classes                       │     │
│  │  • AuthManager (authentication)                │     │
│  │  • DataManager (CRUD operations)               │     │
│  │  • Published properties                        │     │
│  │  • Business logic                              │     │
│  └────────────────────────────────────────────────┘     │
└─────────────────┬────────────────────────────────────────┘
                  │ Reads/Writes
                  │
┌─────────────────▼────────────────────────────────────────┐
│                      Model (M)                           │
│  ┌────────────────────────────────────────────────┐     │
│  │         SwiftData Models                       │     │
│  │  • User                                        │     │
│  │  • EnvelopeModel                               │     │
│  │  • TransactionModel                            │     │
│  └────────────────────────────────────────────────┘     │
└──────────────────────────────────────────────────────────┘
```

### Implementation Example

#### Model (M)
```swift
@Model
final class TransactionModel {
    @Attribute(.unique) var id: UUID
    var amount: Double
    var merchant: String
    var date: Date
    var isIncome: Bool
    var icon: String
    var colorHex: String

    var envelope: EnvelopeModel?
    var user: User?
}
```

#### ViewModel (VM)
```swift
@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var transactions: [TransactionModel] = []
    @Published var envelopes: [EnvelopeModel] = []

    private var modelContext: ModelContext?

    // Business logic
    func addTransaction(
        amount: Double,
        merchant: String,
        date: Date,
        isIncome: Bool,
        envelope: EnvelopeModel?
    ) {
        let transaction = TransactionModel(...)
        modelContext?.insert(transaction)
        refreshData()
    }

    func getTotalBalance() -> Double {
        transactions.reduce(0) { total, transaction in
            total + (transaction.isIncome ? transaction.amount : -transaction.amount)
        }
    }
}
```

#### View (V)
```swift
struct HomeView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showAddTransaction = false

    var body: some View {
        VStack {
            // UI automatically updates when dataManager.transactions changes
            Text("Balance: $\(dataManager.getTotalBalance(), format: .currency)")

            List(dataManager.transactions) { transaction in
                TransactionRow(transaction: transaction)
            }

            Button("Add Transaction") {
                showAddTransaction = true
            }
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView()
        }
    }
}
```

---

## 🔄 Data Flow

### Unidirectional Data Flow

```
User Action (Tap Button)
        │
        ▼
┌──────────────┐
│     View     │  "Add Transaction" button tapped
└──────┬───────┘
       │ calls method
       ▼
┌──────────────┐
│  ViewModel   │  dataManager.addTransaction(...)
│ (DataManager)│
└──────┬───────┘
       │ writes to
       ▼
┌──────────────┐
│    Model     │  TransactionModel created & saved
│ (SwiftData)  │
└──────┬───────┘
       │ triggers
       ▼
┌──────────────┐
│  @Published  │  transactions array updated
│   Property   │
└──────┬───────┘
       │ notifies
       ▼
┌──────────────┐
│     View     │  UI automatically re-renders
└──────────────┘
```

### Example Flow: Adding a Transaction

1. **User taps "Add Transaction" button**
   ```swift
   Button("Add") {
       dataManager.addTransaction(
           amount: 25.50,
           merchant: "Starbucks",
           ...
       )
   }
   ```

2. **DataManager processes the request**
   ```swift
   func addTransaction(...) {
       let transaction = TransactionModel(...)
       modelContext?.insert(transaction)
       try? modelContext?.save()
       refreshData() // Updates @Published property
   }
   ```

3. **Published property triggers update**
   ```swift
   @Published var transactions: [TransactionModel] = []
   // When this changes, all observing views re-render
   ```

4. **SwiftUI automatically re-renders views**
   ```swift
   // This view automatically updates
   List(dataManager.transactions) { transaction in
       TransactionRow(transaction: transaction)
   }
   ```

---

## 🗂️ State Management

### AppStorage (Persistent Settings)

```swift
@AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
@AppStorage("preferredCurrency") private var currency = "USD"

// Automatically persists to UserDefaults
// Survives app restarts
```

### Published Properties (Observable State)

```swift
class AuthManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isGuestMode: Bool = false

    var isAuthenticated: Bool {
        currentUser != nil || isGuestMode
    }
}
```

### State vs Binding

```swift
struct ParentView: View {
    @State private var amount: Double = 0  // Owned by this view

    var body: some View {
        ChildView(amount: $amount)  // Pass binding with $
    }
}

struct ChildView: View {
    @Binding var amount: Double  // Reference to parent's state

    var body: some View {
        TextField("Amount", value: $amount, format: .currency)
        // Changes update parent's @State automatically
    }
}
```

---

## 🧭 Navigation Architecture

### Coordinator Pattern

```swift
struct AppCoordinator: View {
    @ObservedObject private var authManager = AuthManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                // First launch
                OnboardingContainerView()
            } else if authManager.isAuthenticated || authManager.isGuestMode {
                // Logged in
                MainTabView()
            } else {
                // Not logged in
                SignInView()
            }
        }
    }
}
```

### State Machine Diagram

```
┌─────────────┐
│  App Start  │
└──────┬──────┘
       │
       ▼
   Onboarding?
   ╱         ╲
 No           Yes
 │             │
 │             ▼
 │      ┌────────────┐
 │      │ Onboarding │
 │      │   Screens  │
 │      └─────┬──────┘
 │            │ Complete
 │            ▼
 └──────▶ Authenticated?
         ╱           ╲
       No             Yes
        │              │
        ▼              ▼
   ┌────────┐    ┌──────────┐
   │Sign In │    │Main Tabs │
   │Sign Up │    │   Home   │
   │ Guest  │    │Envelopes │
   └───┬────┘    │  Trans   │
       │         │ Insights │
       │         │ Settings │
       │         └──────────┘
       │              │
       │              │ Sign Out
       └──────────────┘
```

### Tab Navigation

```swift
struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            EnvelopesView()
                .tabItem { Label("Envelopes", systemImage: "envelope.fill") }
                .tag(1)

            TransactionsView()
                .tabItem { Label("Transactions", systemImage: "arrow.left.arrow.right") }
                .tag(2)

            InsightsView()
                .tabItem { Label("Insights", systemImage: "chart.bar.fill") }
                .tag(3)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag(4)
        }
    }
}
```

---

## 💾 Persistence Layer

### SwiftData Architecture

```
┌──────────────────────────────────────────────────────────┐
│              ModelContainer (App-Wide)                   │
│  • Manages persistent storage                            │
│  • Creates ModelContext instances                        │
│  • Defines schema and configurations                     │
└────────────────┬─────────────────────────────────────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
    ▼            ▼            ▼
┌────────┐  ┌────────┐  ┌────────┐
│ User   │  │Envelope│  │Transaction│
│ Model  │  │ Model  │  │  Model    │
└────────┘  └────────┘  └────────┘
    │            │            │
    └────────────┼────────────┘
                 │
    ┌────────────▼────────────┐
    │                         │
┌───▼────┐            ┌──────▼─────┐
│SQLite  │            │In-Memory   │
│Database│            │Cache       │
└────────┘            └────────────┘
```

### Initialization

```swift
@main
struct MicroBudgetApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            EnvelopeModel.self,
            TransactionModel.self
        ])

        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false  // Persistent storage
        )

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppCoordinator()
                .onAppear {
                    // Inject ModelContext into managers
                    AuthManager.shared.setModelContext(sharedModelContainer.mainContext)
                    DataManager.shared.setModelContext(sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
```

### Data Isolation

```swift
// Each user's data is isolated via predicates
var descriptor = FetchDescriptor<TransactionModel>(
    predicate: #Predicate<TransactionModel> { transaction in
        transaction.user?.id == currentUser.id
    }
)
descriptor.sortBy = [SortDescriptor(\.date, order: .reverse)]

let userTransactions = try modelContext.fetch(descriptor)
```

---

## 🔧 Service Layer

### Singleton Services

```
┌─────────────────────────────────────────────────────┐
│                   Service Layer                     │
│                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ │
│  │AuthManager   │  │DataManager   │  │Prediction│ │
│  │              │  │              │  │ Service  │ │
│  │ • sign in    │  │ • CRUD ops   │  │ • ML     │ │
│  │ • sign up    │  │ • queries    │  │ • MAE    │ │
│  │ • sign out   │  │ • filters    │  │ • trends │ │
│  │ • guest mode │  │ • aggregates │  │          │ │
│  └──────────────┘  └──────────────┘  └──────────┘ │
└─────────────────────────────────────────────────────┘
```

### AuthManager Responsibilities

```swift
@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published var currentUser: User?
    @Published var isGuestMode: Bool = false

    private var modelContext: ModelContext?

    // Authentication
    func signIn(email: String, password: String) -> Bool
    func signUp(fullName: String, email: String, password: String) -> Bool
    func signOut()
    func continueAsGuest()

    // User management
    func getCurrentUser() -> User?
    func deleteUser(_ user: User)

    // Security
    private func hashPassword(_ password: String) -> String
}
```

### DataManager Responsibilities

```swift
@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var transactions: [TransactionModel] = []
    @Published var envelopes: [EnvelopeModel] = []

    // Transaction operations
    func addTransaction(...)
    func deleteTransaction(_ transaction: TransactionModel)
    func getRecentTransactions(limit: Int) -> [TransactionModel]

    // Envelope operations
    func addEnvelope(...)
    func deleteEnvelope(_ envelope: EnvelopeModel)

    // Analytics
    func getTotalBalance() -> Double
    func getSpendingByCategory() -> [String: Double]
    func getSavingsRate() -> Double
}
```

### SpendingPredictionService Responsibilities

```swift
@MainActor
class SpendingPredictionService {
    static let shared = SpendingPredictionService()

    // Predictions
    func getPrediction(transactions: [TransactionModel]) -> (prediction: Double, mae: Double)
    func predict7DaySpending(transactions: [TransactionModel]) -> Double
    func predictWithCoreML(transactions: [TransactionModel]) -> (prediction: Double, mae: Double)?

    // Feature extraction
    func extractFeatures(transactions: [TransactionModel]) -> [String: Any]

    // Evaluation
    func calculateMAE(transactions: [TransactionModel]) -> Double
}
```

---

## 🔐 Security Architecture

### Password Security Flow

```
User enters password
        │
        ▼
┌──────────────────┐
│  "myPassword123" │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   SHA-256 Hash   │  CryptoKit
└────────┬─────────┘
         │
         ▼
┌────────────────────────────────────────────────┐
│ "ef92b778bffe771bc835e68fcf35a1db7c11d68..." │ (64 chars)
└────────┬───────────────────────────────────────┘
         │
         ▼
┌──────────────────┐
│  Store in User   │  Never store plain text!
│     Model        │
└──────────────────┘
```

### Authentication Flow

```
User attempts login
        │
        ▼
    Hash input password
        │
        ▼
    Query database for user with email
        │
        ▼
    Compare hashed passwords
        │
    ┌───┴───┐
    │       │
  Match   No Match
    │       │
    ▼       ▼
  Login   Error
 Success  Message
```

### Data Access Control

```swift
// Example: Users can only access their own data
private func refreshData() {
    guard let context = modelContext,
          let currentUser = AuthManager.shared.getCurrentUser() else {
        return
    }

    // Fetch only transactions for current user
    var transactionDescriptor = FetchDescriptor<TransactionModel>(
        predicate: #Predicate { transaction in
            transaction.user?.id == currentUser.id
        }
    )

    // Fetch only envelopes for current user
    var envelopeDescriptor = FetchDescriptor<EnvelopeModel>(
        predicate: #Predicate { envelope in
            envelope.user?.id == currentUser.id
        }
    )

    self.transactions = (try? context.fetch(transactionDescriptor)) ?? []
    self.envelopes = (try? context.fetch(envelopeDescriptor)) ?? []
}
```

---

## 🎨 Design Patterns Summary

| Pattern | Usage | Location |
|---------|-------|----------|
| **MVVM** | UI architecture | All views + managers |
| **Singleton** | Shared services | `AuthManager`, `DataManager` |
| **Coordinator** | Navigation | `AppCoordinator.swift` |
| **Observer** | State updates | `@Published`, `@ObservedObject` |
| **Repository** | Data abstraction | `DataManager` |
| **Factory** | Model creation | Manager `add...()` methods |
| **Strategy** | ML predictions | Core ML vs. fallback |

---

## 📊 Architecture Decisions

### Why MVVM?

✅ **Clear separation of concerns**
- Views only handle UI
- ViewModels handle business logic
- Models are pure data

✅ **Testability**
- ViewModels can be unit tested without UI
- Mock ModelContext for testing

✅ **SwiftUI integration**
- Natural fit with `@ObservedObject` and `@Published`

### Why Singletons for Managers?

✅ **Single source of truth**
- All views access same data
- Consistent state across app

✅ **Easy dependency injection**
- Access via `.shared` property

⚠️ **Trade-offs:**
- Can make testing harder (solution: inject ModelContext)
- Global state can be problematic at scale

### Why Coordinator Pattern?

✅ **Centralized navigation logic**
- Easy to modify app flow
- Clear state transitions

✅ **Decoupled views**
- Views don't know about navigation

---

## 🔗 Related Documentation

- [← Technologies Stack](./TECHNOLOGIES.md)
- [Features Deep Dive →](./FEATURES.md)
- [Development Guide →](./DEVELOPMENT.md)
- [← Back to Motivation](./MOTIVATION.md)

---

<div align="center">

**Clean Architecture for Modern iOS Apps 🏗️**

*MVVM • Coordinator • SwiftData*

</div>
