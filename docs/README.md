# 📚 MicroBudget Documentation

<div align="center">

![Documentation](https://img.shields.io/badge/Documentation-Complete-brightgreen?style=for-the-badge)
[![iOS](https://img.shields.io/badge/iOS-17.0+-black?style=for-the-badge&logo=apple)](https://www.apple.com/ios)

**Complete documentation for the MicroBudget iOS application**

</div>

---

## 📖 Documentation Index

### 🎯 Getting Started

Start here if you're new to MicroBudget:

1. **[💡 Motivation & Vision](./MOTIVATION.md)**
   - Why MicroBudget exists
   - Design philosophy
   - Privacy-first approach
   - Future roadmap
   - Educational value

### 🛠️ For Developers

Essential guides for building and extending MicroBudget:

2. **[🛠️ Development Guide](./DEVELOPMENT.md)**
   - Prerequisites and setup
   - Project structure walkthrough
   - Development workflow
   - Core ML integration tutorial
   - Testing strategies
   - Common tasks and recipes
   - Troubleshooting guide
   - Contributing guidelines

3. **[🔧 Technologies Stack](./TECHNOLOGIES.md)**
   - Core technologies (Swift, SwiftUI)
   - Frameworks deep dive (SwiftData, Core ML, Combine, CryptoKit)
   - Architecture patterns (MVVM, Singleton, Coordinator)
   - Data persistence strategy
   - Machine learning pipeline
   - Security implementation
   - Performance characteristics

4. **[🏗️ Architecture Overview](./ARCHITECTURE.md)**
   - High-level architecture diagram
   - MVVM pattern implementation
   - Unidirectional data flow
   - State management
   - Navigation architecture (Coordinator pattern)
   - Persistence layer (SwiftData)
   - Service layer design
   - Security architecture

### 📱 Features & Usage

Detailed feature documentation:

5. **[✨ Features Deep Dive](./FEATURES.md)**
   - Onboarding experience
   - Authentication system (sign up, sign in, guest mode)
   - Envelope budgeting system
   - Transaction management
   - ML-powered predictions
   - Insights dashboard
   - Settings & account management
   - UI/UX features

---

## 🗺️ Documentation Map

```
docs/
├── README.md (this file)          # Documentation index
│
├── MOTIVATION.md                  # Why & Vision
│   ├── The Problem
│   ├── Our Vision
│   ├── Why MicroBudget?
│   ├── Design Philosophy
│   └── Roadmap
│
├── DEVELOPMENT.md                 # Developer Guide
│   ├── Prerequisites
│   ├── Getting Started
│   ├── Project Structure
│   ├── Development Workflow
│   ├── Core ML Integration
│   ├── Testing
│   ├── Common Tasks
│   └── Troubleshooting
│
├── TECHNOLOGIES.md                # Tech Stack
│   ├── Swift 5.9+
│   ├── SwiftUI Framework
│   ├── SwiftData Persistence
│   ├── Core ML Integration
│   ├── Combine Framework
│   ├── CryptoKit Security
│   └── Architecture Patterns
│
├── ARCHITECTURE.md                # System Design
│   ├── High-Level Architecture
│   ├── MVVM Pattern
│   ├── Data Flow
│   ├── State Management
│   ├── Navigation
│   ├── Persistence Layer
│   ├── Service Layer
│   └── Security Architecture
│
└── FEATURES.md                    # Feature Details
    ├── Onboarding
    ├── Authentication
    ├── Envelope Budgeting
    ├── Transactions
    ├── ML Predictions
    ├── Insights Dashboard
    └── Settings
```

---

## 🚀 Quick Links

### For New Users
- Start with [Motivation](./MOTIVATION.md) to understand the app's purpose
- Then read [Features](./FEATURES.md) to learn what you can do

### For Developers
- Read [Development Guide](./DEVELOPMENT.md) for setup instructions
- Study [Architecture](./ARCHITECTURE.md) to understand the design
- Review [Technologies](./TECHNOLOGIES.md) to learn the tech stack

### For Contributors
- Follow [Development Guide → Contributing](./DEVELOPMENT.md#-contributing-guidelines)
- Understand [Architecture](./ARCHITECTURE.md) before making changes
- Check [Technologies](./TECHNOLOGIES.md) for framework details

---

## 📊 Documentation Stats

| Document | Size | Topics | Last Updated |
|----------|------|--------|--------------|
| **MOTIVATION.md** | ~5 KB | 8 | Nov 2025 |
| **DEVELOPMENT.md** | ~14 KB | 12 | Nov 2025 |
| **TECHNOLOGIES.md** | ~15 KB | 10 | Nov 2025 |
| **ARCHITECTURE.md** | ~23 KB | 9 | Nov 2025 |
| **FEATURES.md** | ~27 KB | 8 | Nov 2025 |

**Total:** ~84 KB of comprehensive documentation

---

## 🎯 Learning Paths

### Path 1: Understanding the App (1-2 hours)
1. Read [Motivation](./MOTIVATION.md) (15 min)
2. Skim [Features](./FEATURES.md) (30 min)
3. Review [Technologies](./TECHNOLOGIES.md) overview (30 min)

### Path 2: Building & Running (30 minutes)
1. Follow [Development Guide → Getting Started](./DEVELOPMENT.md#-getting-started)
2. Complete installation steps
3. Run the app and explore

### Path 3: Contributing Code (2-3 hours)
1. Complete Path 1 & 2
2. Study [Architecture](./ARCHITECTURE.md) in detail (1 hour)
3. Review [Technologies](./TECHNOLOGIES.md) implementation details (1 hour)
4. Read [Development Guide → Common Tasks](./DEVELOPMENT.md#-common-tasks)

### Path 4: ML Integration (1-2 hours)
1. Read [Technologies → Machine Learning](./TECHNOLOGIES.md#-machine-learning)
2. Follow [Development Guide → Core ML Integration](./DEVELOPMENT.md#-core-ml-integration)
3. Study [Features → ML Predictions](./FEATURES.md#-ml-powered-predictions)

---

## 🔍 Search by Topic

### Authentication & Security
- [MOTIVATION.md → Privacy-First Design](./MOTIVATION.md#-our-vision)
- [TECHNOLOGIES.md → CryptoKit](./TECHNOLOGIES.md#5-cryptokit)
- [ARCHITECTURE.md → Security Architecture](./ARCHITECTURE.md#-security-architecture)
- [FEATURES.md → Authentication System](./FEATURES.md#-authentication-system)

### Machine Learning
- [MOTIVATION.md → AI-Powered Intelligence](./MOTIVATION.md#-our-vision)
- [TECHNOLOGIES.md → Core ML](./TECHNOLOGIES.md#3-core-ml)
- [ARCHITECTURE.md → Service Layer → SpendingPredictionService](./ARCHITECTURE.md#spendingpredictionservice-responsibilities)
- [FEATURES.md → ML-Powered Predictions](./FEATURES.md#-ml-powered-predictions)
- [DEVELOPMENT.md → Core ML Integration](./DEVELOPMENT.md#-core-ml-integration)

### Data Persistence
- [TECHNOLOGIES.md → SwiftData](./TECHNOLOGIES.md#2-swiftdata)
- [ARCHITECTURE.md → Persistence Layer](./ARCHITECTURE.md#-persistence-layer)
- [DEVELOPMENT.md → Adding a New Model](./DEVELOPMENT.md#adding-a-new-model)

### UI/UX Design
- [MOTIVATION.md → Design Philosophy](./MOTIVATION.md#-design-philosophy)
- [FEATURES.md → UI/UX Features](./FEATURES.md#-uiux-features)
- [DEVELOPMENT.md → Adding a New View](./DEVELOPMENT.md#adding-a-new-view)

---

## 💡 Tips for Reading

### For Skimmers
Each document has:
- ✅ Table of contents at the top
- ✅ Visual diagrams and code examples
- ✅ Tables summarizing key information
- ✅ Cross-references to related sections

### For Deep Learners
- Start with motivation, then architecture
- Follow code references to actual files
- Run the app while reading features documentation
- Try modifying code as you learn

### For Contributors
- Read contributing guidelines first
- Understand MVVM pattern thoroughly
- Study service layer architecture
- Review code style conventions

---

## 🤝 Contributing to Documentation

Found a typo or want to improve docs?

1. **Fork the repository**
2. **Edit markdown files** in `docs/` directory
3. **Submit a pull request**

### Documentation Guidelines
- Use clear, concise language
- Include code examples
- Add diagrams where helpful
- Keep cross-references updated
- Test all links

---

## 📧 Questions?

If the documentation doesn't answer your questions:

1. Check [Development Guide → Troubleshooting](./DEVELOPMENT.md#-troubleshooting)
2. Review [Architecture](./ARCHITECTURE.md) for design decisions
3. Open an issue on GitHub

---

<div align="center">

**Happy Learning! 📚**

[← Back to Main README](../README.md)

</div>
