# Rumeno – Digital Farm Management Platform

A comprehensive Flutter-based mobile app for livestock and agricultural farm management, supporting multiple user roles: **Farmer**, **Veterinarian**, **Admin**, and **Farm Products Vendor**.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Build & Run](#build--run)
- [Architecture](#architecture)
- [Platform Support](#platform-support)
- [Roadmap](#roadmap)

---

## Overview

Rumeno is a digital farm management platform that empowers farmers to manage their livestock, track health records, monitor finances, log milk production, and access a marketplace — all from a single app. Veterinarians and admins get dedicated portals tailored to their workflows.

**Current Status:** UI framework complete with mock data. Backend API integration pending.

---

## Features

### 🌾 Farmer
- **Animal Management** – Add, edit, and track livestock (cattle, buffalo, goat, sheep, pig, horse) with breed, age, weight, health status, and purpose
- **Health Records** – Vaccination, treatment, deworming logs, and lab reports
- **Finance Dashboard** – Expense tracking, feed cost calculator, and financial analytics
- **Breeding Management** – Breeding records and offspring (kids) tracking
- **Milk Logging** – Production tracking with analytics
- **Team & Farm Settings** – Staff management, sanitization records, data export
- **Subscriptions** – Free, Starter, Pro, and Business plans

### 🩺 Veterinarian
- Dashboard with key metrics
- Farm and animal health overview
- Consultation and schedule management
- Earnings tracking

### 🛠️ Admin
- Farmer, animal, and vendor management
- Health protocol configuration
- Subscription and payment oversight
- Reports and analytics

### 🛒 Marketplace
- Product catalog with search and categories
- Shopping cart and checkout
- Order tracking and history
- Vendor registration and account management

### ✨ Additional
- QR code scanning
- Home screen widget support
- Data export
- Charts and visualizations (bar, line, pie)

---

## Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter (Dart 3.11.0+) |
| State Management | Provider (ChangeNotifier) |
| Navigation | GoRouter 14.x |
| Charts | fl_chart |
| Typography | Google Fonts (Poppins) |
| Image Handling | image_picker |
| QR Scanning | mobile_scanner |
| Home Widgets | home_widget |
| Internationalization | intl |
| Loading UI | shimmer |

---

## Project Structure

```
rumeno_app/
├── lib/
│   ├── main.dart               # App entry point
│   ├── config/
│   │   ├── router.dart         # GoRouter navigation
│   │   └── theme.dart          # App theme (colors, fonts)
│   ├── models/                 # Data models
│   ├── providers/              # State management (auth, e-commerce)
│   ├── screens/
│   │   ├── auth/               # Login, OTP, role selection
│   │   ├── farmer/             # Farmer portal
│   │   ├── vet/                # Veterinarian portal
│   │   ├── admin/              # Admin portal
│   │   └── shop/               # Marketplace
│   ├── widgets/                # Reusable UI components & charts
│   ├── services/               # Platform services (home widget)
│   └── mock/                   # Mock data for development
├── assets/images/              # App images and logos
├── android/                    # Android native config
├── ios/                        # iOS native config (+ widget extension)
└── web/                        # Web support
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Dart 3.11.0+
- Android Studio / Xcode (for mobile targets)
- `flutter doctor` shows no critical errors

### Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. (Optional) Regenerate app icons
dart run flutter_launcher_icons

# 3. iOS only — install CocoaPods dependencies
cd ios && pod install && cd ..
```

---

## Build & Run

```bash
# Run on connected device / emulator
flutter run

# Android release APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS release
flutter build ios --release

# Web
flutter build web

# Run tests
flutter test

# Lint / analyze
flutter analyze

# Format code
dart format .

# Clean build cache
flutter clean
```

---

## Architecture

- **Pattern:** Provider-based MVVM
- **Navigation:** GoRouter with nested shell routes per role
- **Mock Data:** `lib/mock/` contains full mock datasets (animals, farmers, health, finance, e-commerce, etc.) — no backend required for development
- **Theme:** Centralized in `config/theme.dart`
  - Primary green: `#5B7A2E`
  - Background cream: `#F5F0E8`
  - Font: Poppins

---

## Platform Support

| Platform | Status |
|---|---|
| Android (5.0+, API 21+) | ✅ Supported |
| iOS (11.0+) | ✅ Supported |
| Web | ⚗️ Experimental |

---

## Roadmap

- [ ] Backend API integration (authentication, CRUD)
- [ ] Push notifications
- [ ] Payment gateway integration
- [ ] Cloud file storage (images, exports)
- [ ] Real-time data syncing
- [ ] Offline support
- [ ] Production deployment (Play Store / App Store)
