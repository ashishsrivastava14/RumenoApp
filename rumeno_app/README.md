# Rumeno – Digital Farm Management Platform

A comprehensive Flutter-based mobile app for livestock and agricultural farm management, supporting multiple user roles: **Farmer**, **Veterinarian**, **Admin**, and **Farm Products Vendor**.

---

## Table of Contents

- [Overview](#overview)
- [Screen Summary](#screen-summary)
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

Rumeno is a digital farm management platform that empowers farmers to manage their livestock, track health records, monitor finances, log milk production, and access a marketplace — all from a single app. Veterinarians, admins, and ecommerce vendors get dedicated portals tailored to their workflows.

**Current Status:** UI framework complete with mock data. Backend API integration pending.

---

## Screen Summary

| Section | Screens | Count |
|---|---|---|
| 🔐 Auth | Login, OTP Verification, Role Selection | **3** |
| 💫 Splash | Splash Screen | **1** |
| 🌾 Farmer — Tabs | Dashboard, More | **2** |
| 🌾 Farmer — Animals | Animal List, Add Animal, Animal Detail, Kid Management | **4** |
| 🌾 Farmer — Health | Health Dashboard, Vaccination, Treatment, Deworming, Lab Reports | **5** |
| 🌾 Farmer — Finance | Finance Dashboard, Expense List, Reports, Feed Calculator | **4** |
| 🌾 Farmer — Milk | Milk Log | **1** |
| 🌾 Farmer — Breeding | Breeding Dashboard | **1** |
| 🌾 Farmer — More | Farm Profile, Subscription, Team Management, Notification Settings, Farm Sanitization, Data Export, Help & Support | **7** |
| 🩺 Vet | Vet Dashboard, Farms List, Farm Detail, Animal Health, Consultations, Schedule, Earnings | **7** |
| 🛠️ Admin — Tabs | Dashboard, Farmers, Farm, Animals, Vets, Shop, Health Config, More | **8** |
| 🛠️ Admin — More | Vendors, Subscriptions, Settings, Reports, Payments, Partners, Notifications, Marketplace | **8** |
| 🛒 Shop | Shop Home, Search, Category, Product Detail, Cart, Checkout, Order Success, Orders List, Order Detail, Account, Vendor Registration | **11** |
| | **Total** | **62** |

---

## Features

### 🔐 Authentication (3 screens)
- **Role Selection** – Choose between Farmer, Veterinarian, Super Admin, or Farm Products roles
- **Phone Login** – OTP-based authentication with phone number
- **OTP Verification** – 4-digit OTP verification with resend support
- **Multi-language** – Hindi and English support on login itself

### 🌾 Farmer Portal (24 screens)

#### Dashboard
- Personalized greeting (morning/afternoon/evening)
- Farm logo upload (camera or gallery)
- Active alerts and upcoming events overview
- Quick navigation to Vet, Marketplace, and Farm sections

#### Animal Management (4 screens)
- **Animal List** – View all livestock with search, sort (tag, name, age, status), and multi-filter (species, gender, purpose, age range, status)
- **Animal Detail** – 8-tab detail view: Overview, Health, Vaccination, Breeding, Reproduction, Production, Finance, Family
- **Add Animal** – 5-step wizard: Species & basics → Appearance (weight, height, color, photo) → Family (parents, siblings) → Shed & purpose → Purchase info (optional)
- **Kid Management** – Track newborns: milk status, weaning, medicine schedules, add/edit/delete kid records with pagination
- **QR Code Scanning** – Scan animal tags via camera
- **Record Death** – Log death with date, reason (disease, pneumonia, diarrhea, snake bite, predator, cold, birth complication, sudden death, unknown)
- **Record Castration** – Log castration date and details
- Supports 6 species: Cow, Buffalo, Goat, Sheep, Pig, Horse

#### Health Center (5 screens)
- **Health Dashboard** – Status overview (healthy, sick, follow-up counts), quick action cards, alerts banner, upcoming vaccinations and active treatments
- **Vaccination** – 3-tab view (Schedule, History, Alerts), add vaccination records, 6 vaccine types (FMD, BQ, HS, PPR, Brucella, Deworming), date scheduling
- **Treatment** – Report sick animals with symptom picker (fever, diarrhea, limping, no appetite, coughing, bloating, eye/nasal discharge, skin lesions, less milk), diagnosis, medicine, vet name, withdrawal period, lab report attachment
- **Deworming** – Multi-step form: animal ID → medicine (brand + salt name) → dose & body weight → schedule date, multiple medicine support
- **Lab Reports** – 2-tab view, 10 test types (CBC, Brucella, Milk Culture, Fecal Egg, Liver Function, Tuberculin, Pregnancy, Blood Smear, Urine Analysis, Other), report file upload
- **Hoof Cutting** – Record hoof cutting details via bottom sheet

#### Breeding (1 screen)
- **Breeding Dashboard** – Track breeding records: heat detection (mild/moderate/strong intensity), artificial insemination, pregnancy checks
- Stat cards and progress indicators
- Add records via bottom sheet forms

#### Finance (4 screens)
- **Finance Dashboard** – Money spent/earned/profit summary, quick-add expense grid (Feed, Medicine, Doctor, Labour, Equipment, Transport, Other), pie chart for expense breakdown, monthly spending line chart, recent expenses list
- **Expense List** – Full expense list with search, category filtering (7 categories), total spend calculation
- **Financial Reports** – Date range picker, total spent/earned/profit cards, bar chart (where money goes), pie chart (payment methods: cash, UPI, bank, credit), CSV and PDF export
- **Animal Feed Calculator** – Feed mix calculator for 6 animal types with nutrient targets (protein, fiber, energy), 8 common feed items (maize, soybean meal, wheat bran, cottonseed cake, green fodder, dry hay, mustard cake, mineral mix), Feedipedia integration

#### Milk Production (1 screen)
- **Milk Log** – 4-step milk logging: session (morning/evening auto-detect) → animal selection → litres → confirmation
- Today summary (total, entries, animals), session management, add multiple records

#### Settings & More (8 screens)
- **More Screen** – Profile card, Pro plan badge, navigation to all settings
- **Farm Profile** – Farm name, owner, address, GPS, manager, vet, YouTube channel
- **Team Management** – Staff list with roles (Owner, Manager, Staff Edit, Staff View), add/invite members
- **Subscription Plans** – 4 tiers: Free (₹0, 5 animals), Starter (₹499/mo, 25 animals), Pro (₹999/mo, 100 animals), Business (₹2499/mo, unlimited)
- **Notification Settings** – Toggle vaccination, health, breeding, finance, milk, feed, SMS alerts with sound control
- **Data Export** – 2 tabs (Farm Data, Sell Animal), 6 export categories (Animals, Health, Breeding, Finance, Milk, Team), category-specific filters, date range, PDF/CSV/Excel format
- **Farm Sanitization** – Log sanitization records with 9 sanitizer options, 8 area options, schedule next sanitization
- **Help & Support** – Call, WhatsApp, email contact options, FAQ section

### 🩺 Veterinarian Portal (7 screens)
- **Vet Dashboard** – Hero header with greeting, key metrics (total farms, animals, active treatments), quick action cards, upcoming visits preview
- **Farms List** – Browse assigned farms with search, farm cards showing owner, plan, animal count, location
- **Farm Detail** – 3-tab view (Animals, Treatments, Vaccinations) for selected farm, farm info banner
- **Animal Health** – 4-tab view for treatments, vaccinations, deworming, and lab reports across all farms with animal-level detail
- **Consultations** – Treatment management with status filters (All, Active, Follow-up, Completed), search, treatment cards
- **Schedule** – Upcoming farm visits grouped by date, pending vaccinations list, event cards with time and location
- **Earnings** – Financial summary (this month, total earned, pending, commission %), monthly earnings line chart, commission breakdown bar chart, payout history

### 🛠️ Admin Portal (16 screens)
- **Admin Dashboard** – Greeting header with notification bell, key metrics grid (total farmers, animals, active plans, revenue), pending items alerts, quick access module grid, recent activity feed
- **Farmers Management** – Search and filter farmers by plan, stats header, farmer cards with plan badges, export option
- **Farm Management** – 3-tab view (Animals, Health, Stats) across all farms, species-based overview, health protocol monitoring
- **Animals Management** – Browse all animals with species filter, search by name/tag, export capability
- **Health Config** – 3-tab configuration (Vaccines, Diseases, Medicines), add/edit/delete health protocols
- **Vet Management** – 3-tab view (Vets, Consults, Earnings), invite vets, manage vet profiles, consultation tracking
- **Shop Management** – 5-tab ecommerce dashboard (Overview, Products, Orders, Vendors, Coupons), product CRUD, order management
- **Admin More** – System admin profile, quick access grid to all modules
- **Vendors** – Vendor list with status badges (approved, pending, rejected, suspended), approval workflow
- **Subscriptions** – Plan configuration and management, user counts per plan, editable plan details, add new plans
- **App Settings** – General settings, access control (sign-ups, maintenance mode), notification toggles, data management (backup, export, cache)
- **Reports** – 3-tab analytics (Revenue, Users, Health): revenue charts, MRR, user growth, species distribution
- **Payments** – Revenue summary, trend charts, recent payment list with status (success, failed, refunded)
- **Partners & Vets** – Partner management (vets, affiliates), referral tracking, earnings per partner
- **Push Notifications** – Compose and send notifications, audience targeting, notification history
- **Marketplace Admin** – Marketplace stats, quick actions, category-wise stats (product count, stock, revenue)

### 🛒 Ecommerce / Marketplace (11 screens)
- **Shop Home** – Category chips (Feed, Supplements, Medicines, Equipment), promotional banner, featured products carousel, product grid, bottom navigation
- **Search** – Real-time search with auto-focus, category and animal type filter chips, product result cards with add-to-cart
- **Product Detail** – Product image with badges, price/MRP/discount, rating & stock status, delivery info, description, reviews, Add to Cart / Buy Now, wishlist
- **Category Browse** – Products grid filtered by category, inline add-to-cart
- **Cart** – Cart items with quantity controls, coupon section (apply/remove, validation), price breakdown, proceed to checkout
- **Checkout** – 3-step flow: address selection → payment method (UPI, Card, Net Banking, Cash on Delivery) → order confirmation
- **Order Success** – Success message with order ID, track order / continue shopping buttons
- **Orders List** – All orders with status badges (pending, confirmed, packed, shipped, delivered), item preview
- **Order Detail** – Visual status timeline, order items, delivery address, payment details, reorder button, invoice view
- **Account** – Profile card, orders, addresses, wishlist, app switching (Farm/Vet/Vendor), language selector
- **Vendor Registration** – 4-step stepper form: business info → documents (GST, PAN) → bank details → address

#### Coupon System
- Coupon codes with percentage and flat discount types
- Validation: expiry dates, minimum order value, maximum discount, usage limits

#### Order Status Flow
- pending → confirmed → packed → shipped → delivered
- Timestamp tracking at each stage, tracking number, reorder capability

#### Vendor System
- Vendor registration and approval workflow (pending → approved/rejected/suspended)
- Commission tracking, wallet and earnings, multi-vendor product listings

### ✨ Cross-Cutting Features
- **Internationalization (i18n)** – Full Hindi and English support with 1500+ translated strings
- **QR Code Scanning** – Scan animal tags via mobile camera
- **Home Screen Widget** – iOS widget support for quick farm stats
- **Data Export** – PDF, CSV, and Excel export for all data categories
- **Charts & Visualizations** – Bar, line, pie charts, and progress indicators (fl_chart)
- **Image Handling** – Camera and gallery photo picker for animals, farm logos, lab reports
- **Role-Based Navigation** – Dedicated shell and bottom navigation per role
- **Responsive Layout** – Admin panel supports navigation rail on wider screens

---

## Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter (Dart 3.11.0+) |
| State Management | Provider (ChangeNotifier) |
| Navigation | GoRouter 14.x |
| Charts | fl_chart |
| Typography | Google Fonts (Poppins, Inter) |
| Image Handling | image_picker |
| QR Scanning | mobile_scanner |
| Home Widgets | home_widget |
| Internationalization | intl |
| Loading UI | shimmer |
| URL Launcher | url_launcher |

---

## Project Structure

```
rumeno_app/
├── lib/
│   ├── main.dart                   # App entry point
│   ├── config/
│   │   ├── router.dart             # GoRouter navigation
│   │   └── theme.dart              # App theme (colors, fonts)
│   ├── l10n/                       # Localization (EN + HI)
│   ├── models/                     # Data models (Animal, Health, Finance, Ecommerce)
│   ├── providers/                  # State management (auth, ecommerce, admin, locale)
│   ├── screens/
│   │   ├── auth/                   # Login, OTP, role selection (3 screens)
│   │   ├── farmer/                 # Farmer portal (24 screens)
│   │   │   ├── animals/            # Animal list, detail, add, kid management
│   │   │   ├── health/             # Vaccination, treatment, deworming, lab reports
│   │   │   ├── breeding/           # Breeding dashboard
│   │   │   ├── finance/            # Finance dashboard, expenses, reports, feed calc
│   │   │   ├── milk/               # Milk production logging
│   │   │   └── more/               # Profile, team, subscription, export, settings
│   │   ├── vet/                    # Veterinarian portal (7 screens)
│   │   ├── admin/                  # Admin portal (16 screens)
│   │   │   └── more/               # Vendors, subscriptions, reports, settings
│   │   └── shop/                   # Marketplace / Ecommerce (11 screens)
│   ├── widgets/
│   │   ├── cards/                  # Animal, health, vaccination, expense, farmer cards
│   │   ├── charts/                 # Line, bar, pie charts, progress indicators
│   │   └── common/                 # Search bar, stat card, section header, alerts
│   ├── services/                   # Platform services (home widget)
│   └── mock/                       # Mock data (animals, farmers, health, finance, ecommerce, milk)
├── assets/images/                  # App images and logos
├── android/                        # Android native config
├── ios/                            # iOS native config (+ home widget extension)
└── web/                            # Web support
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
- **Mock Data:** `lib/mock/` contains full mock datasets (animals, farmers, health, finance, e-commerce, milk, etc.) — no backend required for development
- **Theme:** Centralized in `config/theme.dart`
  - Primary green: `#5B7A2E`
  - Background cream: `#F5F0E8`
  - Fonts: Poppins (headings), Inter (body)

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
