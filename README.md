# MicroBudget

A modern iOS budget tracking app with ML-powered spending predictions built using SwiftUI and SwiftData.

## Features

- **User Authentication**: Secure login and signup with SHA256 password hashing
- **Envelope Budgeting**: Create and manage budget envelopes with spending limits
- **Transaction Tracking**: Record income and expenses with category icons
- **ML Predictions**: 7-day spending forecasts using Core ML with linear regression fallback
- **Insights Dashboard**: Visualize spending trends, savings rate, and model performance
- **Multi-User Support**: Each user has isolated data with SwiftData persistence
- **Guest Mode**: Try the app without creating an account

## Requirements

- **Xcode**: 15.0 or later
- **iOS**: 17.0 or later
- **macOS**: Sonoma (14.0) or later

## Installation & Setup

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

## Running the App

### First Launch
1. Complete the onboarding screens
2. Create an account or continue as guest
3. Start adding envelopes and transactions

### Using Predictions
- The ML prediction feature requires at least **3 expense transactions** in the last 7 days
- Add transactions to see the 7-day spending forecast on the Home and Insights screens

## Core ML Integration (Optional)

The app includes a fallback linear regression model. To integrate a trained Core ML model:

1. **Train your model** using Create ML or Python with the following features:
   - `last_7_days_spending`
   - `last_14_days_spending`
   - `last_30_days_spending`
   - `avg_daily_last_7`
   - `avg_daily_last_14`
   - `avg_daily_last_30`
   - `day_of_week`
   - `day_of_month`
   - `transaction_count_7_days`

2. **Add the .mlmodel file** to Xcode:
   - Drag the `.mlmodel` file into the project navigator
   - Ensure "Copy items if needed" is checked

3. **Update SpendingPredictionService.swift**:
   - Uncomment the Core ML integration code in the `predictWithCoreML()` method (lines 148-182)
   - Update the model class name to match your `.mlmodel` file name

## Project Structure

```
MicroBudget/
├── Models/              # SwiftData models (User, EnvelopeModel, TransactionModel)
├── Views/               # SwiftUI views organized by feature
│   ├── Onboarding/
│   ├── Auth/
│   ├── Home/
│   ├── Envelopes/
│   ├── Transactions/
│   ├── Insights/
│   └── Settings/
├── Managers/            # State management (AuthManager, DataManager)
├── Services/            # ML prediction service
└── Utilities/           # Shared components and extensions
```

## Troubleshooting

### Can't log in after rebuilding the app?
Delete the app from the simulator and rebuild:
- Long press the app icon in simulator
- Click the "X" to delete
- Rebuild and run

### Predictions not showing?
Make sure you have:
- At least 3 expense transactions in the last 7 days
- Transactions with dates within the recent period

### Build errors?
- Clean the build folder: `⌘ + Shift + K`
- Restart Xcode
- Ensure you're using Xcode 15+ with iOS 17+ deployment target

## Technologies Used

- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Apple's persistence framework
- **Core ML**: On-device machine learning
- **CryptoKit**: Secure password hashing
- **Combine**: Reactive programming for state management

## License

This project is for educational purposes.
