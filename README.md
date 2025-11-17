# 💰 MicroBudget

<div align="center">

![MicroBudget](https://img.shields.io/badge/MicroBudget-iOS_Budget_App-blue?style=for-the-badge)
[![iOS](https://img.shields.io/badge/iOS-17.0+-black?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/ios)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Latest-blue?style=for-the-badge)](https://developer.apple.com/xcode/swiftui/)

**A modern iOS budget tracking app with ML-powered spending predictions built using SwiftUI and SwiftData.**

[Features](#-features) • [Quick Start](#-quick-start) • [Documentation](#-documentation) • [Screenshots](#-screenshots)

</div>

---

## ✨ Features

- 🔐 **User Authentication**: Secure login and signup with SHA256 password hashing
- ✉️ **Envelope Budgeting**: Create and manage budget envelopes with spending limits
- 💰 **Transaction Tracking**: Record income and expenses with category icons
- 🤖 **ML Predictions**: 7-day spending forecasts using Core ML with linear regression fallback
- 📊 **Insights Dashboard**: Visualize spending trends, savings rate, and model performance
- 👥 **Multi-User Support**: Each user has isolated data with SwiftData persistence
- 🎭 **Guest Mode**: Try the app without creating an account
- 🔒 **Privacy-First**: 100% on-device processing, no cloud sync required

## 📚 Documentation

Comprehensive documentation is available in the `docs/` directory:

| Document | Description |
|----------|-------------|
| [💡 **Motivation**](./docs/MOTIVATION.md) | Why MicroBudget? Vision, design philosophy, and roadmap |
| [🛠️ **Development Guide**](./docs/DEVELOPMENT.md) | Setup, workflow, Core ML integration, and contributing |
| [🔧 **Technologies**](./docs/TECHNOLOGIES.md) | Tech stack, frameworks, and architecture patterns |
| [🏗️ **Architecture**](./docs/ARCHITECTURE.md) | MVVM pattern, data flow, and system design |
| [✨ **Features**](./docs/FEATURES.md) | In-depth feature documentation and usage guides |

---

## 🚀 Quick Start

### Requirements

- **Xcode**: 15.0 or later
- **iOS**: 17.0 or later
- **macOS**: Sonoma (14.0) or later

### Installation & Setup

1. **Clone or download the project**
   ```bash
   cd /Users/sujana/Desktop/Ruvini/MicroBudget
   ```

2. **Open the project in Xcode**
   - Double-click `MicroBudget.xcodeproj` or
   - Open Xcode and select "Open a project or file", then navigate to the project folder

3. **Select a simulator or device**
   - Click on the device selector in the toolbar (next to the play button)
   - Choose an iPhone simulator (e.g., iPhone 15 Pro)

4. **Build and run the project**
   - Press `⌘ + R` or click the Play button in the toolbar
   - Wait for the build to complete
   - The app will launch in the simulator

---

## 📱 Using the App

### First Launch
1. 🚀 Complete the 3-screen onboarding experience
2. 🔐 Create an account or continue as guest
3. ✉️ Add budget envelopes (e.g., Groceries, Transport)
4. 💰 Start tracking transactions

### ML Predictions
- Requires at least **3 expense transactions** in the last 7 days
- View 7-day spending forecasts on Home and Insights screens
- See prediction accuracy with MAE (Mean Absolute Error) metrics

---

## 📸 Screenshots

> *Coming soon - Add screenshots of the app here*

---

## 🤖 Core ML Integration

The app includes a **fallback linear regression model** that works out of the box. To integrate a custom trained Core ML model:

### Quick Steps

1. **Train your model** using Create ML or Python
2. **Drag `.mlmodel` file** into Xcode project
3. **Build and run** - No code changes needed!

The app automatically tries Core ML first, then falls back to linear regression if unavailable.

### Model Requirements

**Input features (9 dimensions):**
- `last_7_days_spending`, `last_14_days_spending`, `last_30_days_spending`
- `avg_daily_last_7`, `avg_daily_last_14`, `avg_daily_last_30`
- `day_of_week`, `day_of_month`, `transaction_count_7_days`

**Output:** `predicted_spending` (Double)

For detailed ML integration guide, see [Development Documentation](./docs/DEVELOPMENT.md#-core-ml-integration).

---

## 📂 Project Structure

```
MicroBudget/
├── 📊 Models/              # SwiftData models (User, EnvelopeModel, TransactionModel)
├── 🎨 Views/               # SwiftUI views organized by feature
│   ├── Onboarding/
│   ├── Auth/
│   ├── Home/
│   ├── Envelopes/
│   ├── Transactions/
│   ├── Insights/
│   └── Settings/
├── 🎛️ Services/            # Business logic (AuthManager, DataManager, ML)
├── 🎨 Extensions/          # Color helpers and utilities
├── 🤖 SpendingPredictor.mlmodel  # Core ML model
└── 📚 docs/                # Comprehensive documentation
```

For detailed architecture, see [Architecture Documentation](./docs/ARCHITECTURE.md).

---

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| **Can't log in after rebuild** | Delete app from simulator, then rebuild |
| **Predictions not showing** | Add 3+ expense transactions in last 7 days |
| **Build errors** | Clean build folder (`⌘ + Shift + K`), restart Xcode |
| **Database errors** | Delete app from simulator to reset database |

For more troubleshooting tips, see [Development Guide](./docs/DEVELOPMENT.md#-troubleshooting).

---

## 🔧 Technologies Used

| Technology | Purpose |
|------------|---------|
| **SwiftUI** | Modern declarative UI framework |
| **SwiftData** | Apple's persistence framework |
| **Core ML** | On-device machine learning |
| **CryptoKit** | Secure password hashing (SHA-256) |
| **Combine** | Reactive programming for state management |

For detailed technology documentation, see [Technologies Guide](./docs/TECHNOLOGIES.md).

---

## 🤝 Contributing

Contributions are welcome! Please see the [Development Guide](./docs/DEVELOPMENT.md#-contributing-guidelines) for:

- Code style guidelines
- Commit message conventions
- Pull request process
- Testing requirements

---

## 📄 License

This project is for educational purposes.

---

## 🙏 Acknowledgments

Built with:
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) by Apple
- [Core ML](https://developer.apple.com/documentation/coreml) by Apple
- [SF Symbols](https://developer.apple.com/sf-symbols/) for icons

---

<div align="center">

**Made with ❤️ for iOS developers and budget-conscious individuals**

[Documentation](./docs/MOTIVATION.md) • [Report Bug](https://github.com/yourusername/microbudget/issues) • [Request Feature](https://github.com/yourusername/microbudget/issues)

</div>
