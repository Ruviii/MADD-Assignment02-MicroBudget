# ✨ Features Deep Dive

<div align="center">

![Features](https://img.shields.io/badge/Features-Comprehensive-brightgreen?style=for-the-badge)
[![iOS](https://img.shields.io/badge/Platform-iOS_17+-black?style=for-the-badge&logo=apple)](https://www.apple.com/ios)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Onboarding Experience](#-onboarding-experience)
- [Authentication System](#-authentication-system)
- [Envelope Budgeting](#-envelope-budgeting)
- [Transaction Management](#-transaction-management)
- [ML-Powered Predictions](#-ml-powered-predictions)
- [Insights Dashboard](#-insights-dashboard)
- [Settings & Account](#-settings--account)

---

## 🎯 Overview

MicroBudget offers a complete personal finance management solution with:

| Feature | Status | Description |
|---------|--------|-------------|
| 🚀 **Onboarding** | ✅ Complete | 3-screen tutorial introducing the app |
| 🔐 **Authentication** | ✅ Complete | Secure login with guest mode option |
| ✉️ **Envelopes** | ✅ Complete | Category-based budget allocation |
| 💰 **Transactions** | ✅ Complete | Income & expense tracking |
| 🤖 **ML Predictions** | ✅ Complete | 7-day spending forecasts |
| 📊 **Insights** | ✅ Complete | Analytics and spending trends |
| ⚙️ **Settings** | ✅ Complete | Account management |

---

## 🚀 Onboarding Experience

### Overview

First-time users are greeted with a beautiful 3-screen onboarding flow that introduces MicroBudget's core concepts.

### Screens

#### Screen 1: Welcome
```
┌─────────────────────────────┐
│                             │
│     💰 [Large Icon]         │
│                             │
│   Welcome to MicroBudget    │
│                             │
│  Smart budget tracking with │
│   ML-powered predictions    │
│                             │
│         [Next →]            │
│                             │
└─────────────────────────────┘
```

**Location:** `Views/Onboarding/Onboarding1View.swift`

#### Screen 2: Envelope Budgeting
```
┌─────────────────────────────┐
│                             │
│     ✉️ [Envelope Icon]      │
│                             │
│   Envelope Budgeting        │
│                             │
│  Organize your money into   │
│   visual categories         │
│                             │
│    [← Back]  [Next →]       │
│                             │
└─────────────────────────────┘
```

**Location:** `Views/Onboarding/Onboarding2View.swift`

#### Screen 3: ML Predictions
```
┌─────────────────────────────┐
│                             │
│     🤖 [Chart Icon]         │
│                             │
│   Smart Predictions         │
│                             │
│  AI forecasts your spending │
│   for the next 7 days       │
│                             │
│    [← Back]  [Get Started]  │
│                             │
└─────────────────────────────┘
```

**Location:** `Views/Onboarding/Onboarding3View.swift`

### Features

✅ **Smooth Animations** - Page transitions with SwiftUI animations
✅ **Progress Indicators** - Visual dots showing current page
✅ **Skip Option** - Users can skip to authentication
✅ **One-Time Display** - Only shown on first launch (via `@AppStorage`)

### User Flow

```
App Launch
    │
    ▼
Has seen onboarding?
    │
    ├─ No  → Show 3-screen onboarding
    │         └─ Mark as completed
    │
    └─ Yes → Skip to authentication
```

---

## 🔐 Authentication System

### Overview

Secure, privacy-first authentication with **SHA-256 password hashing** and multi-user support.

### Sign Up Flow

```
┌────────────────────────────────────────┐
│         Create Account                 │
│                                        │
│  Full Name:  [________________]        │
│                                        │
│  Email:      [________________]        │
│                                        │
│  Password:   [________________] 👁️     │
│                                        │
│  [            Sign Up            ]     │
│                                        │
│  Already have an account? Sign In      │
│                                        │
└────────────────────────────────────────┘
```

**Location:** `Views/Auth/SignUpView.swift`

**Validation:**
- ✅ Full name (non-empty)
- ✅ Valid email format
- ✅ Password strength (6+ characters)
- ✅ Email uniqueness check

**Process:**
1. User enters credentials
2. Validate input
3. Hash password with SHA-256
4. Create User model in SwiftData
5. Auto-login after signup

### Sign In Flow

```
┌────────────────────────────────────────┐
│         Welcome Back                   │
│                                        │
│  Email:      [________________]        │
│                                        │
│  Password:   [________________] 👁️     │
│                                        │
│  [            Sign In            ]     │
│                                        │
│  [      Continue as Guest        ]     │
│                                        │
│  Don't have an account? Sign Up        │
│                                        │
└────────────────────────────────────────┘
```

**Location:** `Views/Auth/SignInView.swift`

**Process:**
1. User enters credentials
2. Hash input password
3. Query database for user with email
4. Compare password hashes
5. Set `currentUser` in AuthManager

### Guest Mode

**Benefits:**
- ✅ Try app without creating account
- ✅ Full feature access
- ✅ Data persists during session
- ⚠️ Data lost on sign out

**Implementation:**
```swift
func continueAsGuest() {
    // Create temporary user
    let guestUser = User(
        fullName: "Guest User",
        email: "guest@microbudget.local",
        passwordHash: ""
    )
    modelContext?.insert(guestUser)
    currentUser = guestUser
    isGuestMode = true
}
```

### Password Security

**SHA-256 Hashing:**
```swift
import CryptoKit

func hashPassword(_ password: String) -> String {
    let data = Data(password.utf8)
    let hashed = SHA256.hash(data: data)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

// Example:
// Input:  "myPassword123"
// Output: "ef92b778bffe771bc835e68fcf35a1db7c11d68bcc71a2ac3d87d3a5edaae5e7"
```

**Security Features:**
- ✅ One-way hashing (can't reverse)
- ✅ Salted with CryptoKit
- ✅ Never stored in plain text
- ✅ Secure comparison

---

## ✉️ Envelope Budgeting

### Overview

The **envelope budgeting system** is the core of MicroBudget. Users allocate money into virtual "envelopes" for different spending categories.

### Envelope Structure

```swift
@Model
final class EnvelopeModel {
    var id: UUID
    var name: String          // e.g., "Groceries"
    var allocated: Double     // Budget amount
    var icon: String          // SF Symbol name
    var colorHex: String      // Visual identification
    var goal: Double?         // Optional savings goal
    var transactions: [TransactionModel]?
}
```

### Envelopes View

```
┌────────────────────────────────────────┐
│  Envelopes              [+ Add]        │
├────────────────────────────────────────┤
│                                        │
│  🍔  Groceries         $150 / $200     │
│      ████████░░  75% used              │
│                                        │
│  🚗  Transport         $80 / $100      │
│      ████████░  80% used               │
│                                        │
│  🎬  Entertainment     $30 / $50       │
│      ██████░░░░  60% used              │
│                                        │
│  💰  Savings           $500 / $500     │
│      ██████████  100% saved            │
│                                        │
└────────────────────────────────────────┘
```

**Location:** `Views/Envelopes/EnvelopesView.swift`

**Features:**
- ✅ Visual progress bars
- ✅ Color-coded categories
- ✅ SF Symbols icons
- ✅ Swipe to delete
- ✅ Real-time spending updates

### Add Envelope Flow

```
┌────────────────────────────────────────┐
│         Create Envelope                │
│                                        │
│  Envelope Name                         │
│  [________________]                    │
│                                        │
│  Allocated Amount                      │
│  $[_______________]                    │
│                                        │
│  Select Icon                           │
│  🍔 🚗 🏠 🎬 💰 ✈️ 🏥 📚               │
│                                        │
│  Select Color                          │
│  🔴 🔵 🟢 🟡 🟣 🟠                      │
│                                        │
│  [          Create Envelope      ]     │
│                                        │
└────────────────────────────────────────┘
```

**Location:** `Views/Envelopes/AddEnvelopesView.swift`

**Validation:**
- Name (non-empty)
- Amount (> $0)
- Icon (required)
- Color (required)

### Budget Calculation

```swift
// Spent amount
let spent = envelope.transactions?
    .filter { !$0.isIncome }
    .reduce(0) { $0 + $1.amount } ?? 0

// Remaining budget
let remaining = envelope.allocated - spent

// Progress percentage
let progress = min(spent / envelope.allocated, 1.0)
```

### Use Cases

| Envelope | Purpose | Example Budget |
|----------|---------|----------------|
| 🍔 Groceries | Food shopping | $300/month |
| 🚗 Transport | Gas, parking | $150/month |
| 🏠 Rent | Housing costs | $1200/month |
| 🎬 Entertainment | Movies, dining out | $100/month |
| 💰 Savings | Emergency fund | $500/month |
| ✈️ Travel | Vacation savings | $200/month |

---

## 💰 Transaction Management

### Overview

Track all income and expenses with detailed categorization and visual feedback.

### Transaction Structure

```swift
@Model
final class TransactionModel {
    var id: UUID
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

### Transactions View

```
┌────────────────────────────────────────┐
│  Transactions           [+ Add]        │
├────────────────────────────────────────┤
│                                        │
│  🍔  Starbucks         Nov 15  -$5.50  │
│                                        │
│  💰  Salary            Nov 14  +$2000  │
│                                        │
│  🚗  Gas Station       Nov 13  -$40.00 │
│                                        │
│  🎬  Cinema            Nov 12  -$15.00 │
│                                        │
│  🍔  Grocery Store     Nov 11  -$85.00 │
│                                        │
└────────────────────────────────────────┘
```

**Location:** `Views/Transactions/TransactionsView.swift`

**Features:**
- ✅ Chronological sorting (newest first)
- ✅ Color-coded amounts (green = income, red = expense)
- ✅ Swipe to delete
- ✅ Filter by date range
- ✅ Search by merchant

### Add Transaction Flow

```
┌────────────────────────────────────────┐
│         New Transaction                │
│                                        │
│  Type:  ( ) Income  (•) Expense        │
│                                        │
│  Amount                                │
│  $[_______________]                    │
│                                        │
│  Merchant/Source                       │
│  [________________]                    │
│                                        │
│  Date                                  │
│  [  Nov 17, 2025  ] 📅                 │
│                                        │
│  Envelope (Optional)                   │
│  [  Groceries ▼   ]                    │
│                                        │
│  Icon                                  │
│  🍔 🚗 💰 🎬 ✈️                         │
│                                        │
│  [          Add Transaction      ]     │
│                                        │
└────────────────────────────────────────┘
```

**Location:** `Views/Transactions/AddTransactionView.swift`

**Process:**
1. User selects income/expense
2. Enters amount and merchant
3. Chooses date (default: today)
4. Optionally assigns to envelope
5. Selects icon and color
6. DataManager creates transaction
7. Updates envelope spending if assigned

### Transaction Analytics

```swift
// Total income
let totalIncome = transactions
    .filter { $0.isIncome }
    .reduce(0) { $0 + $1.amount }

// Total expenses
let totalExpenses = transactions
    .filter { !$0.isIncome }
    .reduce(0) { $0 + $1.amount }

// Net balance
let balance = totalIncome - totalExpenses
```

---

## 🤖 ML-Powered Predictions

### Overview

**Core ML** predicts 7-day spending based on historical transaction patterns with transparent accuracy metrics.

### Prediction Display (Home View)

```
┌────────────────────────────────────────┐
│  Total Balance                         │
│  $1,245.50                             │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │ Predicted spend (7 days)         │ │
│  │ $165.00                          │ │
│  │                                  │ │
│  │ MAE: $12.50                      │ │
│  └──────────────────────────────────┘ │
│                                        │
└────────────────────────────────────────┘
```

**Location:** `Views/Home/HomeView.swift:49-86`

### Requirements for Predictions

✅ **Minimum Data:**
- At least 3 expense transactions
- Transactions within last 7 days
- Valid transaction dates

⚠️ **Insufficient Data Message:**
```
┌──────────────────────────────────────┐
│   📊                                 │
│   Insufficient Data for Prediction   │
│                                      │
│   Add more transactions to see       │
│   ML-powered spending forecasts      │
└──────────────────────────────────────┘
```

### Feature Engineering

**Input Features (9 dimensions):**

```swift
let features = [
    "last_7_days_spending": 150.0,    // Last week's spending
    "last_14_days_spending": 280.0,   // Last 2 weeks
    "last_30_days_spending": 650.0,   // Last month
    "avg_daily_last_7": 21.43,        // Daily average (7d)
    "avg_daily_last_14": 20.0,        // Daily average (14d)
    "avg_daily_last_30": 21.67,       // Daily average (30d)
    "day_of_week": 3.0,               // 0=Sun, 6=Sat
    "day_of_month": 15.0,             // 1-31
    "transaction_count_7_days": 12.0  // Recent activity
]
```

**Location:** `Services/SpendingPredictionService.swift:95-148`

### Prediction Methods

#### 1. Core ML Model (Primary)

```swift
func predictWithCoreML(transactions: [TransactionModel]) -> (prediction: Double, mae: Double)? {
    do {
        let config = MLModelConfiguration()
        let model = try SpendingPredictor(configuration: config)

        let features = extractFeatures(transactions: transactions)
        let provider = try MLDictionaryFeatureProvider(dictionary: features)
        let output = try model.model.prediction(from: provider)

        let prediction = output.featureValue(for: "predicted_spending")?.doubleValue ?? 0

        return (prediction: prediction, mae: calculateMAE(transactions: transactions))
    } catch {
        print("❌ Core ML prediction failed: \(error)")
        return nil
    }
}
```

#### 2. Linear Regression (Fallback)

```swift
func predict7DaySpending(transactions: [TransactionModel]) -> Double {
    // Get last 30 days of expenses
    let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())
    let recentExpenses = transactions.filter {
        !$0.isIncome && $0.date >= thirtyDaysAgo
    }

    // Calculate daily average
    let totalSpent = recentExpenses.reduce(0.0) { $0 + $1.amount }
    let dailyAverage = totalSpent / 30.0

    // Apply trend factor
    let trendFactor = calculateTrendFactor(transactions: recentExpenses)

    // Predict 7-day spending
    return dailyAverage * 7 * trendFactor
}
```

**Trend Factor:**
- Compares recent (last 7 days) vs. older (7-14 days ago) spending
- > 1.0 = spending increasing
- < 1.0 = spending decreasing
- Clamped to [0.5, 1.5] range

### Model Evaluation: MAE

**Mean Absolute Error (MAE)** measures prediction accuracy:

```swift
func calculateMAE(transactions: [TransactionModel]) -> Double {
    // Actual spending (last 7 days)
    let actualSpending = transactions
        .filter { !$0.isIncome && $0.date >= sevenDaysAgo }
        .reduce(0.0) { $0 + $1.amount }

    // What we predicted 7 days ago
    let predictedSpending = predict7DaySpending(
        transactions: priorTransactions
    )

    // Absolute error
    return abs(actualSpending - predictedSpending)
}
```

**Interpretation:**
- MAE of $10 = Predictions off by $10 on average
- Lower MAE = Better model
- Displayed to users for transparency

### Prediction Strategy

```
┌─────────────────┐
│ Get Prediction  │
└────────┬────────┘
         │
         ▼
   Try Core ML Model
         │
    ┌────┴────┐
    │         │
 Success   Failure
    │         │
    │         ▼
    │  Use Fallback
    │  (Linear Reg)
    │         │
    └────┬────┘
         │
         ▼
  Return Prediction
      + MAE
```

---

## 📊 Insights Dashboard

### Overview

Comprehensive analytics showing spending patterns, savings rate, and model performance.

### Dashboard Layout

```
┌────────────────────────────────────────┐
│  Insights                              │
├────────────────────────────────────────┤
│                                        │
│  📊 Spending Overview                  │
│  ┌──────────────────────────────────┐ │
│  │  Last 7 Days:     $150.00        │ │
│  │  Last 30 Days:    $650.00        │ │
│  │  This Month:      $1,200.00      │ │
│  └──────────────────────────────────┘ │
│                                        │
│  💰 Savings Rate                       │
│  ┌──────────────────────────────────┐ │
│  │  Income:          $2,000.00      │ │
│  │  Expenses:        $1,200.00      │ │
│  │  Saved:           $800.00 (40%)  │ │
│  │  ████████░░░░░░░░░░               │ │
│  └──────────────────────────────────┘ │
│                                        │
│  🤖 ML Model Performance               │
│  ┌──────────────────────────────────┐ │
│  │  Prediction:      $165.00        │ │
│  │  Accuracy (MAE):  $12.50         │ │
│  │  Confidence:      93%            │ │
│  └──────────────────────────────────┘ │
│                                        │
│  📈 Spending by Category               │
│  🍔 Groceries        $300  ████████   │
│  🚗 Transport        $150  ████        │
│  🎬 Entertainment    $80   ██          │
│  🏥 Healthcare       $120  ███         │
│                                        │
└────────────────────────────────────────┘
```

**Location:** `Views/Insights/InsightsView.swift`

### Key Metrics

#### 1. Spending Trends

```swift
// Last 7 days
let last7Days = Calendar.current.date(byAdding: .day, value: -7, to: Date())
let spending7Days = transactions
    .filter { !$0.isIncome && $0.date >= last7Days }
    .reduce(0) { $0 + $1.amount }

// Last 30 days
let last30Days = Calendar.current.date(byAdding: .day, value: -30, to: Date())
let spending30Days = transactions
    .filter { !$0.isIncome && $0.date >= last30Days }
    .reduce(0) { $0 + $1.amount }
```

#### 2. Savings Rate

```swift
func getSavingsRate() -> Double {
    let totalIncome = transactions
        .filter { $0.isIncome }
        .reduce(0) { $0 + $1.amount }

    let totalExpenses = transactions
        .filter { !$0.isIncome }
        .reduce(0) { $0 + $1.amount }

    guard totalIncome > 0 else { return 0 }

    return ((totalIncome - totalExpenses) / totalIncome) * 100
}
```

#### 3. Category Breakdown

```swift
func getSpendingByCategory() -> [String: Double] {
    var spending: [String: Double] = [:]

    for transaction in transactions where !transaction.isIncome {
        let category = transaction.envelope?.name ?? "Uncategorized"
        spending[category, default: 0] += transaction.amount
    }

    return spending
}
```

### Charts & Visualizations

**Spending Area Chart:**
- Last 7 days daily spending
- Smooth gradient visualization
- Interactive data points

**Category Pie Chart:**
- Visual breakdown by envelope
- Color-coded segments
- Percentage labels

---

## ⚙️ Settings & Account

### Overview

User account management, app preferences, and data control.

### Settings Menu

```
┌────────────────────────────────────────┐
│  Settings                              │
├────────────────────────────────────────┤
│                                        │
│  👤 Account                            │
│      John Doe                          │
│      john@example.com                  │
│                                        │
│  📊 Data & Privacy                     │
│      > Export Data                     │
│      > Delete All Data                 │
│                                        │
│  ℹ️ About                              │
│      Version 1.0.0                     │
│      > Privacy Policy                  │
│      > Terms of Service                │
│                                        │
│  [           Sign Out           ]      │
│                                        │
│  🗑️ Delete Account                     │
│                                        │
└────────────────────────────────────────┘
```

**Location:** `Views/Settings/SettingsView.swift`

### Features

#### 1. Account Information
- Display user name and email
- Change password (future enhancement)
- Update profile (future enhancement)

#### 2. Sign Out

```swift
func signOut() {
    // Clear current user
    currentUser = nil
    isGuestMode = false

    // Clear data manager
    DataManager.shared.clearData()

    // Return to sign-in screen
}
```

#### 3. Delete Account

**Confirmation Flow:**
```
Tap "Delete Account"
    │
    ▼
Show Alert
"Are you sure? This cannot be undone."
    │
    ├─ Cancel → Return
    │
    └─ Delete →
        ├─ Delete all user's envelopes
        ├─ Delete all user's transactions
        ├─ Delete user account
        └─ Sign out
```

```swift
func deleteAccount() {
    guard let user = currentUser else { return }

    // Cascade delete handles relationships
    modelContext?.delete(user)
    try? modelContext?.save()

    signOut()
}
```

---

## 🎨 UI/UX Features

### Color System

```swift
extension Color {
    static let appBackground = Color(red: 0.06, green: 0.08, blue: 0.11)
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.6, green: 0.6, blue: 0.65)
    static let cardBackground = Color(red: 0.08, green: 0.10, blue: 0.13)
}
```

### Typography

| Style | Font | Size | Weight | Usage |
|-------|------|------|--------|-------|
| **Title** | System | 28pt | Bold | Page headers |
| **Headline** | System | 18pt | Semibold | Section titles |
| **Body** | System | 16pt | Medium | Main content |
| **Caption** | System | 13pt | Regular | Secondary text |
| **Large Display** | System | 40pt | Bold | Balance amounts |

### Animations

✅ **Page Transitions** - Smooth navigation between screens
✅ **Button Feedback** - Scale animation on tap
✅ **List Animations** - Fade-in for new items
✅ **Progress Bars** - Animated filling
✅ **Sheet Presentations** - Modal slide-up animations

### Accessibility

✅ **Dynamic Type** - Supports system font sizes
✅ **VoiceOver** - Accessible labels and hints
✅ **High Contrast** - Readable color combinations
✅ **Semantic Colors** - Adapts to light/dark mode

---

## 🔗 Related Documentation

- [← Architecture Overview](./ARCHITECTURE.md)
- [← Technologies Stack](./TECHNOLOGIES.md)
- [Development Guide →](./DEVELOPMENT.md)
- [← Back to Motivation](./MOTIVATION.md)

---

<div align="center">

**Powerful Features, Simple Experience ✨**

*Built for iOS with SwiftUI*

</div>
