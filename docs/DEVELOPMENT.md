# 🛠️ Development Guide

<div align="center">

![Development](https://img.shields.io/badge/Development-Guide-success?style=for-the-badge)
[![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue?style=for-the-badge&logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)

</div>

---

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Development Workflow](#-development-workflow)
- [Core ML Integration](#-core-ml-integration)
- [Testing](#-testing)
- [Common Tasks](#-common-tasks)
- [Troubleshooting](#-troubleshooting)
- [Contributing Guidelines](#-contributing-guidelines)

---

## 🔧 Prerequisites

### Required Software

| Tool | Version | Purpose |
|------|---------|---------|
| **macOS** | Sonoma 14.0+ | Development environment |
| **Xcode** | 15.0+ | IDE and build tools |
| **iOS Simulator** | 17.0+ | Testing target |
| **Git** | Latest | Version control |

### Recommended Tools

- **SF Symbols App** - Browse iOS system icons
- **Create ML** - Train custom ML models
- **Instruments** - Profile performance
- **SwiftLint** (optional) - Code style enforcement

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
# Clone the project
git clone <repository-url>
cd MicroBudget

# Verify project structure
ls -la
```

### 2. Open in Xcode

```bash
# Open the project file
open MicroBudget.xcodeproj
```

Or double-click `MicroBudget.xcodeproj` in Finder.

### 3. Configure Project Settings

1. **Select your development team**
   - Go to Project Navigator → MicroBudget target
   - Under "Signing & Capabilities"
   - Select your Apple Developer team or use "Personal Team"

2. **Choose a simulator**
   - Click device selector in toolbar
   - Select "iPhone 15 Pro" (recommended)
   - Or any iOS 17.0+ simulator

### 4. Build and Run

```bash
# Keyboard shortcut
⌘ + R

# Or click the Play button in toolbar
```

**First build** may take 2-3 minutes. Subsequent builds are faster.

---

## 📁 Project Structure

```
MicroBudget/
├── 📱 MicroBudget/
│   ├── 🏗️ MicroBudgetApp.swift        # App entry point
│   ├── 📄 ContentView.swift            # Root view (unused)
│   ├── 🎯 Item.swift                   # Sample model (unused)
│   │
│   ├── 📊 Models/                      # Data models
│   │   ├── User.swift                  # User authentication model
│   │   ├── Envelope.swift              # Budget envelope model
│   │   └── TransactionModel.swift     # Transaction entity
│   │
│   ├── 🎨 Views/                       # UI components
│   │   ├── AppCoordinator.swift       # Navigation coordinator
│   │   ├── MainTabView.swift          # Tab bar container
│   │   │
│   │   ├── 🚀 Onboarding/             # Welcome screens
│   │   │   ├── OnboardingContainerView.swift
│   │   │   ├── Onboarding1View.swift
│   │   │   ├── Onboarding2View.swift
│   │   │   └── Onboarding3View.swift
│   │   │
│   │   ├── 🔐 Auth/                   # Authentication
│   │   │   ├── SignInView.swift
│   │   │   └── SignUpView.swift
│   │   │
│   │   ├── 🏠 Home/                   # Dashboard
│   │   │   └── HomeView.swift
│   │   │
│   │   ├── ✉️ Envelopes/              # Budget categories
│   │   │   ├── EnvelopesView.swift
│   │   │   ├── AddEnvelopesView.swift
│   │   │   └── AddEnvelope1View.swift
│   │   │
│   │   ├── 💰 Transactions/           # Transaction management
│   │   │   ├── TransactionsView.swift
│   │   │   └── AddTransactionView.swift
│   │   │
│   │   ├── 📊 Insights/               # Analytics dashboard
│   │   │   └── InsightsView.swift
│   │   │
│   │   └── ⚙️ Settings/               # App settings
│   │       └── SettingsView.swift
│   │
│   ├── 🎛️ Services/                   # Business logic
│   │   ├── AuthManager.swift          # Authentication service
│   │   ├── DataManager.swift          # Data operations
│   │   └── SpendingPredictionService.swift  # ML predictions
│   │
│   ├── 🎨 Extensions/                 # Utility extensions
│   │   └── Color+Extensions.swift     # Color helpers
│   │
│   └── 🤖 ML Models/
│       └── SpendingPredictor.mlmodel  # Core ML model
│
├── 🧪 MicroBudgetTests/               # Unit tests
│   └── MicroBudgetTests.swift
│
├── 🎭 MicroBudgetUITests/             # UI tests
│   ├── MicroBudgetUITests.swift
│   └── MicroBudgetUITestsLaunchTests.swift
│
├── 📚 docs/                           # Documentation
│   ├── MOTIVATION.md
│   ├── DEVELOPMENT.md (this file)
│   ├── TECHNOLOGIES.md
│   ├── ARCHITECTURE.md
│   └── FEATURES.md
│
└── 📄 README.md                       # Project overview
```

---

## 💻 Development Workflow

### Architecture Pattern: MVVM

```
┌─────────────┐
│    View     │ ← SwiftUI Views (HomeView, etc.)
└──────┬──────┘
       │ observes
┌──────▼──────┐
│  ViewModel  │ ← Managers (AuthManager, DataManager)
└──────┬──────┘
       │ uses
┌──────▼──────┐
│    Model    │ ← SwiftData Models (User, Envelope, etc.)
└─────────────┘
```

### Key Components

#### 1. **AppCoordinator** (`Views/AppCoordinator.swift`)
Navigation state machine that determines which screen to show.

```swift
enum AppState {
    case onboarding    // First launch
    case authentication // Login/signup
    case authenticated  // Main app
}
```

#### 2. **AuthManager** (`Services/AuthManager.swift`)
Singleton service managing user authentication.

```swift
class AuthManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isGuestMode: Bool = false

    func signIn(email: String, password: String)
    func signUp(fullName: String, email: String, password: String)
    func signOut()
}
```

#### 3. **DataManager** (`Services/DataManager.swift`)
Centralized data operations for transactions and envelopes.

```swift
class DataManager: ObservableObject {
    @Published var transactions: [TransactionModel] = []
    @Published var envelopes: [EnvelopeModel] = []

    func addTransaction(...)
    func deleteTransaction(...)
    func getTotalBalance() -> Double
}
```

#### 4. **SpendingPredictionService** (`Services/SpendingPredictionService.swift`)
Machine learning predictions for spending forecasts.

```swift
class SpendingPredictionService {
    func predict7DaySpending(transactions: [TransactionModel]) -> Double
    func predictWithCoreML(transactions: [TransactionModel]) -> (prediction: Double, mae: Double)?
    func calculateMAE(transactions: [TransactionModel]) -> Double
}
```

---

## 🤖 Core ML Integration

### Current Implementation

The app includes a **fallback linear regression** model that works out of the box.

### Adding a Custom ML Model

#### Step 1: Train Your Model

**Using Create ML (macOS):**

1. Open Create ML app
2. Create a new **Tabular Regressor** project
3. Import your training data (CSV format):

```csv
last_7_days_spending,last_14_days_spending,last_30_days_spending,avg_daily_last_7,avg_daily_last_14,avg_daily_last_30,day_of_week,day_of_month,transaction_count_7_days,target
150.0,280.0,650.0,21.43,20.0,21.67,3,15,12,165.0
200.0,350.0,700.0,28.57,25.0,23.33,1,8,15,210.0
```

4. Set target column: `target` (7-day spending)
5. Train the model
6. Export as `.mlmodel` file

**Using Python (scikit-learn + coremltools):**

```python
import coremltools as ct
from sklearn.ensemble import RandomForestRegressor

# Train your model
model = RandomForestRegressor()
model.fit(X_train, y_train)

# Convert to Core ML
coreml_model = ct.converters.sklearn.convert(
    model,
    input_features=['last_7_days_spending', 'last_14_days_spending', ...],
    output_feature_names=['predicted_spending']
)

# Save
coreml_model.save('SpendingPredictor.mlmodel')
```

#### Step 2: Add Model to Xcode

1. Drag `SpendingPredictor.mlmodel` into Xcode project navigator
2. Check **"Copy items if needed"**
3. Ensure target membership includes "MicroBudget"

#### Step 3: Verify Model Integration

Open the `.mlmodel` file in Xcode to see:
- **Model Type** (e.g., Regressor, Classifier)
- **Input Features** (names and types)
- **Output Features** (prediction field name)

#### Step 4: Update Code

The code in `SpendingPredictionService.swift:153-203` already handles Core ML predictions. It automatically:
- ✅ Tries Core ML model first
- ✅ Falls back to linear regression if unavailable
- ✅ Extracts features automatically
- ✅ Handles different output names

**No code changes needed!** Just add your `.mlmodel` file.

---

## 🧪 Testing

### Unit Tests

```bash
# Run all tests
⌘ + U

# Or use xcodebuild
xcodebuild test \
  -project MicroBudget.xcodeproj \
  -scheme MicroBudget \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

### UI Tests

Located in `MicroBudgetUITests/`:
- Launch tests verify app starts correctly
- UI tests validate critical user flows

### Manual Testing Checklist

- [ ] Onboarding flow (3 screens)
- [ ] Sign up with new account
- [ ] Sign in with existing account
- [ ] Guest mode functionality
- [ ] Create envelope
- [ ] Add income transaction
- [ ] Add expense transaction
- [ ] View predictions (requires 3+ expenses)
- [ ] Check insights dashboard
- [ ] Sign out and verify data isolation

---

## 🔨 Common Tasks

### Adding a New View

1. Create SwiftUI file in appropriate `Views/` subfolder
2. Follow naming convention: `FeatureNameView.swift`
3. Import required frameworks:

```swift
import SwiftUI

struct MyNewView: View {
    var body: some View {
        Text("Hello World")
    }
}

#Preview {
    MyNewView()
}
```

### Adding a New Model

1. Create file in `Models/` directory
2. Use `@Model` macro for SwiftData persistence:

```swift
import Foundation
import SwiftData

@Model
final class MyModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}
```

3. Add to schema in `MicroBudgetApp.swift`:

```swift
let schema = Schema([
    User.self,
    EnvelopeModel.self,
    TransactionModel.self,
    MyModel.self  // Add here
])
```

### Customizing Colors

Edit `Extensions/Color+Extensions.swift`:

```swift
extension Color {
    static let appBackground = Color(red: 0.06, green: 0.08, blue: 0.11)
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.6, green: 0.6, blue: 0.65)

    // Add your custom colors
    static let myCustomColor = Color(red: 0.5, green: 0.8, blue: 0.3)
}
```

### Adding SF Symbols Icons

Browse available icons at [SF Symbols](https://developer.apple.com/sf-symbols/):

```swift
Image(systemName: "chart.line.uptrend.xyaxis")
    .font(.system(size: 24))
    .foregroundColor(.blue)
```

---

## 🐛 Troubleshooting

### Build Errors

#### "Could not create ModelContainer"

**Cause:** SwiftData schema mismatch or corrupt database.

**Solution:**
```bash
# Delete app from simulator
Simulator → Long press app → Delete

# Clean build folder
⌘ + Shift + K

# Rebuild
⌘ + R
```

#### "No such module 'CoreML'"

**Cause:** Missing framework import.

**Solution:**
1. Select MicroBudget target
2. Go to "Frameworks, Libraries, and Embedded Content"
3. Ensure CoreML.framework is present

### Runtime Issues

#### Predictions Not Showing

**Requirements:**
- Minimum 3 expense transactions in last 7 days
- Transactions with valid dates

**Debug:**
```swift
// In HomeView.swift, check console output
print("Recent expenses: \(recentExpenses.count)")
print("Has sufficient data: \(hasSufficientData)")
```

#### Login Fails After Rebuild

**Cause:** Database file location changed.

**Solution:** Delete app from simulator and reinstall.

#### Dark Mode Issues

**Check:**
- Simulator → Features → Toggle Appearance
- Ensure colors use `.primaryText` and `.secondaryText` from extensions

---

## 🤝 Contributing Guidelines

### Code Style

- **Use SwiftLint** (optional but recommended)
- Follow Apple's [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Add documentation comments for public APIs:

```swift
/// Calculates the total balance across all envelopes
/// - Returns: The sum of all allocated amounts minus spent amounts
func getTotalBalance() -> Double {
    // Implementation
}
```

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
feat: add category filtering to transactions view
fix: resolve Core ML prediction crash on empty data
docs: update development guide with ML training steps
refactor: extract transaction list into reusable component
```

### Pull Request Process

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'feat: add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## 📚 Additional Resources

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SwiftData by Example](https://www.hackingwithswift.com/quick-start/swiftdata)
- [Core ML Documentation](https://developer.apple.com/documentation/coreml)
- [Create ML Documentation](https://developer.apple.com/documentation/createml)

---

## 🔗 Related Documentation

- [← Back to Motivation](./MOTIVATION.md)
- [Technologies Stack →](./TECHNOLOGIES.md)
- [Architecture Overview →](./ARCHITECTURE.md)
- [Features Deep Dive →](./FEATURES.md)

---

<div align="center">

**Happy Coding! 🚀**

*Built with SwiftUI & Core ML*

</div>
