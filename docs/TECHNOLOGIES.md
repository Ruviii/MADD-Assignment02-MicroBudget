# 🔧 Technologies & Stack

<div align="center">

![Technologies](https://img.shields.io/badge/Tech-Stack-purple?style=for-the-badge)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/)

</div>

---

## 📋 Table of Contents

- [Core Technologies](#-core-technologies)
- [Frameworks & Libraries](#-frameworks--libraries)
- [Development Tools](#-development-tools)
- [Architecture Patterns](#-architecture-patterns)
- [Data & Persistence](#-data--persistence)
- [Machine Learning](#-machine-learning)
- [Security & Privacy](#-security--privacy)

---

## 🎯 Core Technologies

### Swift 5.9+

**Why Swift?**
- Type-safe language reduces runtime crashes
- Modern syntax with powerful features (generics, protocols, property wrappers)
- Excellent Xcode integration
- Native iOS performance

**Key Features Used:**
- `@Observable` macro for reactive state
- `async/await` for asynchronous operations
- Generics for reusable components
- Protocol-oriented programming

```swift
// Example: Observable pattern with @Observable
@Observable
class AuthManager {
    var currentUser: User?
    var isAuthenticated: Bool { currentUser != nil }
}
```

---

## 🏗️ Frameworks & Libraries

### 1. SwiftUI

<div align="left">

![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS_17+-blue?logo=swift&logoColor=white)

</div>

**Purpose:** Declarative UI framework for building responsive interfaces.

**Why SwiftUI?**
- ✅ Declarative syntax reduces boilerplate
- ✅ Automatic state management with `@State`, `@Binding`
- ✅ Built-in animations and transitions
- ✅ Live preview during development
- ✅ Native iOS design language

**Usage in MicroBudget:**

```swift
// Declarative UI with automatic state updates
struct HomeView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var predictedSpend: Double = 0

    var body: some View {
        VStack {
            Text("Total Balance")
            Text("$\(totalBalance, format: .currency(code: "USD"))")
                .font(.largeTitle)
                .bold()
        }
    }
}
```

**Key Components:**
- `VStack`, `HStack`, `ZStack` for layouts
- `NavigationStack` for navigation
- `@State`, `@Binding`, `@ObservedObject` for state management
- `GeometryReader` for responsive designs

---

### 2. SwiftData

<div align="left">

![SwiftData](https://img.shields.io/badge/SwiftData-Latest-green?logo=swift&logoColor=white)

</div>

**Purpose:** Modern persistence framework replacing Core Data.

**Why SwiftData?**
- ✅ Native Swift syntax (no Objective-C legacy)
- ✅ Declarative model definitions with `@Model` macro
- ✅ Automatic relationship management
- ✅ Type-safe queries with Swift syntax
- ✅ Seamless SwiftUI integration

**Usage in MicroBudget:**

```swift
@Model
final class User {
    @Attribute(.unique) var id: UUID
    var fullName: String
    var email: String
    var passwordHash: String

    @Relationship(deleteRule: .cascade)
    var envelopes: [EnvelopeModel]?

    @Relationship(deleteRule: .cascade)
    var transactions: [TransactionModel]?
}
```

**Features Used:**
- `@Model` macro for persistence
- `@Attribute(.unique)` for unique constraints
- `@Relationship` for one-to-many relationships
- Cascade delete rules
- Predicate-based queries

**Data Models:**

| Model | Purpose | Relationships |
|-------|---------|---------------|
| `User` | Authentication & user data | → Envelopes, Transactions |
| `EnvelopeModel` | Budget categories | ← User, → Transactions |
| `TransactionModel` | Income/expense records | ← Envelope, ← User |

---

### 3. Core ML

<div align="left">

![CoreML](https://img.shields.io/badge/Core_ML-On--Device-red?logo=apple&logoColor=white)

</div>

**Purpose:** On-device machine learning for spending predictions.

**Why Core ML?**
- ✅ 100% on-device processing (no server required)
- ✅ Optimized for Apple Silicon and Neural Engine
- ✅ Privacy-preserving predictions
- ✅ Offline functionality
- ✅ Automatic model optimization

**Model Architecture:**

```
Input Features (9):
├── last_7_days_spending   (Double)
├── last_14_days_spending  (Double)
├── last_30_days_spending  (Double)
├── avg_daily_last_7       (Double)
├── avg_daily_last_14      (Double)
├── avg_daily_last_30      (Double)
├── day_of_week            (Double)
├── day_of_month           (Double)
└── transaction_count_7_days (Double)

Output:
└── predicted_spending (Double) → 7-day forecast
```

**Prediction Pipeline:**

```swift
// 1. Extract features from transaction history
let features = extractFeatures(transactions: transactions)

// 2. Create ML input provider
let provider = try MLDictionaryFeatureProvider(dictionary: features)

// 3. Get prediction from model
let output = try model.model.prediction(from: provider)

// 4. Extract prediction value
let prediction = output.featureValue(for: "predicted_spending")?.doubleValue
```

**Fallback Strategy:**

If Core ML model is unavailable, the app uses **linear regression**:

```swift
func predict7DaySpending(transactions: [TransactionModel]) -> Double {
    // Calculate daily average
    let dailyAverage = totalSpent / daysCovered

    // Apply trend factor (recent vs. older spending)
    let trendFactor = calculateTrendFactor(transactions: transactions)

    return dailyAverage * 7 * trendFactor
}
```

---

### 4. Combine

<div align="left">

![Combine](https://img.shields.io/badge/Combine-Reactive-yellow?logo=swift&logoColor=white)

</div>

**Purpose:** Reactive programming for state management.

**Why Combine?**
- ✅ Built-in to Swift (no third-party dependencies)
- ✅ Type-safe event streams
- ✅ Automatic memory management
- ✅ Perfect for handling async updates

**Usage in MicroBudget:**

```swift
class DataManager: ObservableObject {
    @Published var transactions: [TransactionModel] = []
    @Published var envelopes: [EnvelopeModel] = []

    // Views automatically update when these properties change
}
```

**Publishers Used:**
- `@Published` - Automatic change notifications
- `ObservableObject` - Observable classes for SwiftUI

---

### 5. CryptoKit

<div align="left">

![Security](https://img.shields.io/badge/CryptoKit-Security-darkred?logo=apple&logoColor=white)

</div>

**Purpose:** Secure password hashing and cryptographic operations.

**Why CryptoKit?**
- ✅ Industry-standard algorithms (SHA256)
- ✅ Hardware-accelerated encryption
- ✅ Native Apple framework (no dependencies)
- ✅ Built-in security best practices

**Password Security:**

```swift
import CryptoKit

func hashPassword(_ password: String) -> String {
    let data = Data(password.utf8)
    let hashed = SHA256.hash(data: data)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

// Example:
// Input:  "myPassword123"
// Output: "a3c4e5f6..." (64-character hex string)
```

**Security Features:**
- One-way hashing (passwords can't be reversed)
- Deterministic output (same input → same hash)
- Collision-resistant (virtually impossible to find duplicates)

---

## 🛠️ Development Tools

### Xcode 15+

**Features Used:**
- **Live Previews** - Instant UI feedback during development
- **Instruments** - Performance profiling and memory debugging
- **Create ML** - Visual ML model training
- **SwiftUI Canvas** - Interactive UI editor
- **Source Control** - Built-in Git integration

### SF Symbols

**Purpose:** Apple's icon library with 5000+ symbols.

**Icons Used:**

| Symbol | Usage |
|--------|-------|
| `house.fill` | Home tab |
| `envelope.fill` | Envelopes tab |
| `arrow.left.arrow.right` | Transactions tab |
| `chart.bar.fill` | Insights tab |
| `gearshape.fill` | Settings tab |
| `chart.line.uptrend.xyaxis` | Predictions |

```swift
Image(systemName: "chart.line.uptrend.xyaxis")
    .font(.system(size: 40))
    .foregroundColor(.blue)
```

---

## 🏛️ Architecture Patterns

### MVVM (Model-View-ViewModel)

```
┌──────────────────────────────────────────┐
│              View Layer                  │
│  (SwiftUI Views - HomeView, etc.)       │
└────────────┬─────────────────────────────┘
             │ observes changes
┌────────────▼─────────────────────────────┐
│         ViewModel Layer                  │
│  (AuthManager, DataManager)              │
│  - Published properties                  │
│  - Business logic                        │
└────────────┬─────────────────────────────┘
             │ reads/writes
┌────────────▼─────────────────────────────┐
│          Model Layer                     │
│  (User, Envelope, Transaction)           │
│  - SwiftData models                      │
│  - Pure data structures                  │
└──────────────────────────────────────────┘
```

**Benefits:**
- Clear separation of concerns
- Testable business logic
- Reusable view models
- Automatic UI updates with `@Published`

### Singleton Pattern

```swift
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    private init() {} // Prevent external initialization
}

class DataManager: ObservableObject {
    static let shared = DataManager()
    private init() {}
}
```

**Why Singletons?**
- Single source of truth for app state
- Shared access across views
- Centralized data management

### Coordinator Pattern

```swift
struct AppCoordinator: View {
    @ObservedObject private var authManager = AuthManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingContainerView()
        } else if authManager.isAuthenticated || authManager.isGuestMode {
            MainTabView()
        } else {
            SignInView()
        }
    }
}
```

**Benefits:**
- Centralized navigation logic
- Clean view separation
- Easy to modify app flow

---

## 💾 Data & Persistence

### Storage Strategy

**Local-Only Storage:**
- ✅ All data stored on device
- ✅ No cloud sync (privacy-first)
- ✅ SwiftData manages SQLite database
- ✅ Automatic encryption via iOS

**Data Location:**
```
/Users/<user>/Library/Developer/CoreSimulator/.../
    Documents/
        default.store  (SwiftData database)
```

**Data Isolation:**
- Each user has isolated data (filtered by user ID)
- Guest mode uses temporary user ID
- No cross-user data leakage

### Query Performance

**Optimized Queries:**

```swift
// ❌ Bad: Load all, filter in memory
let allTransactions = try context.fetch(FetchDescriptor<TransactionModel>())
let filtered = allTransactions.filter { $0.user?.id == currentUserId }

// ✅ Good: Filter at database level
var descriptor = FetchDescriptor<TransactionModel>(
    predicate: #Predicate { $0.user?.id == currentUserId }
)
descriptor.sortBy = [SortDescriptor(\.date, order: .reverse)]
let transactions = try context.fetch(descriptor)
```

---

## 🧠 Machine Learning

### Feature Engineering

**Input Features:**

| Feature | Description | Range |
|---------|-------------|-------|
| `last_7_days_spending` | Total spending in last 7 days | $0 - $10,000+ |
| `last_14_days_spending` | Total spending in last 14 days | $0 - $20,000+ |
| `last_30_days_spending` | Total spending in last 30 days | $0 - $50,000+ |
| `avg_daily_last_7` | Average daily spending (7 days) | $0 - $1,000+ |
| `avg_daily_last_14` | Average daily spending (14 days) | $0 - $1,000+ |
| `avg_daily_last_30` | Average daily spending (30 days) | $0 - $1,000+ |
| `day_of_week` | Current day (0=Sun, 6=Sat) | 0 - 6 |
| `day_of_month` | Current day of month | 1 - 31 |
| `transaction_count_7_days` | Number of transactions (7 days) | 0 - 100+ |

**Model Evaluation:**

```swift
// Mean Absolute Error (MAE)
func calculateMAE(transactions: [TransactionModel]) -> Double {
    let actualSpending = getActualLast7Days()
    let predictedSpending = predict7DaySpending()
    return abs(actualSpending - predictedSpending)
}

// Lower MAE = Better predictions
// Example: MAE of $12.50 means predictions are off by $12.50 on average
```

---

## 🔐 Security & Privacy

### Password Security

**Hashing Algorithm:** SHA-256
- 256-bit hash output (64 hex characters)
- One-way function (can't reverse to original)
- Fast to compute, slow to brute-force

```swift
// Never stored in plain text!
let hashedPassword = hashPassword("userPassword123")
// Stored: "ef92b778bffe771bc835e68fcf35a1db7c11d68bcc71a2ac3d87d3a5edaae5e7"
```

### Data Privacy

**Privacy Features:**
- ✅ No network requests (offline-first)
- ✅ No analytics or tracking
- ✅ No third-party SDKs
- ✅ All ML processing on-device
- ✅ No data sharing between users

**iOS Security:**
- App Sandbox (isolated file system)
- Encrypted storage (iOS handles automatically)
- Keychain integration (future enhancement)

---

## 📊 Technology Comparison

### Why These Choices?

| Technology | Alternative | Why We Chose This |
|------------|-------------|-------------------|
| **SwiftData** | Core Data | Modern Swift syntax, simpler API |
| **Core ML** | Cloud APIs | Privacy, offline support, cost |
| **SwiftUI** | UIKit | Faster development, modern syntax |
| **Combine** | RxSwift | Native Apple framework |
| **CryptoKit** | CommonCrypto | Modern API, hardware acceleration |

---

## 🚀 Performance Characteristics

### App Size
- **Binary:** ~5 MB (without ML model)
- **With ML Model:** ~6-8 MB (depends on model complexity)

### Memory Usage
- **Idle:** ~30 MB
- **Active:** ~50-70 MB
- **Peak:** ~100 MB (during ML predictions)

### Battery Impact
- **Minimal** - No background processing
- **Efficient** - SwiftUI automatic optimizations
- **On-Device ML** - Neural Engine acceleration

---

## 🔗 Related Documentation

- [← Development Guide](./DEVELOPMENT.md)
- [Architecture Overview →](./ARCHITECTURE.md)
- [Features Deep Dive →](./FEATURES.md)
- [← Back to Motivation](./MOTIVATION.md)

---

## 📚 Further Reading

### Official Documentation
- [SwiftUI by Apple](https://developer.apple.com/xcode/swiftui/)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [Core ML Documentation](https://developer.apple.com/documentation/coreml)
- [CryptoKit Guide](https://developer.apple.com/documentation/cryptokit)

### Tutorials & Guides
- [Hacking with Swift - SwiftData](https://www.hackingwithswift.com/quick-start/swiftdata)
- [Create ML Tutorial](https://www.hackingwithswift.com/create-ml)
- [SwiftUI Essentials](https://developer.apple.com/tutorials/swiftui)

---

<div align="center">

**Built with Modern iOS Technologies 🚀**

*SwiftUI • SwiftData • Core ML • Combine*

</div>
