# Bukuku Restaurant Management System - Frontend App

<p align="center">
    <img src="https://flutter.dev/images/flutter-logo-sharing.png" width="300" alt="Flutter Logo">
</p>

<p align="center">
    <strong>Restaurant Management System Mobile & Tablet App</strong><br>
    Built with Flutter 3.16+, GetX state management, and responsive UI design
</p>

---

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Environment Setup](#environment-setup)
- [Project Architecture](#project-architecture)
- [Project Dependencies](#project-dependencies)
- [Registration & Authentication](#registration--authentication)
- [Testing](#testing)
- [Build & Deployment](#build--deployment)

---

## 🚀 Features

### Core Functionality
- **Multi-role Navigation**: Specific views for Admin, Staff, and regular users.
- **F&B Menu Management**: Complete CRUD UI for restaurant owners to manage items.
- **Kitchen Dashboard**: Real-time status updates and order tracking.
- **POS Integration**: Interactive interface for table-based ordering.
- **OTP Verification Flow**: Secure login and registration with automated OTP handling.
- **Responsive Layout**: Designed for mobile phones and tablet displays.

### UI/UX Features
- **Modern Material Design**: Using custom themes and sleek animations.
- **GetX Reactive UI**: Instant updates without unnecessary rebuilds.
- **User-friendly Forms**: Clear validation and error states for all fields.
- **Image Picker Support**: Upload menu item images directly from the camera or gallery.

---

## 📋 Requirements

- **Flutter SDK** >= 3.16.0
- **Dart SDK** >= 3.2.0
- **Android Studio** or **VS Code** (with Flutter extensions)
- **Git**

---

## 🛠️ Installation

1. **Clone the Project**
   ```bash
   git clone https://github.com/filzaharry/bukuku-restaurant-frontend.git
   cd bukuku-restaurant-frontend
   ```

2. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

3. **Initialize Environment Variables**
   ```bash
   cp .env.example .env
   ```
   (If `.env.example` is missing, create a new `.env` file)

4. **Verify Environment**
   ```bash
   flutter doctor
   ```

5. **Run Application**
   ```bash
   flutter run
   ```

---

## ⚙️ Environment Setup

Create a `.env` file in the root of the frontend folder:

```bash
# API Configuration
API_BASE_URL=http://your-server-ip:8001/api/v1
API_TIMEOUT=30000

# App Settings
APP_NAME=Bukuku Restaurant
DEBUG_MODE=true
```

---

## 🏗️ Project Architecture (GetX Pattern)

We follow the strictly organized GetX architecture:

```
lib/
├── core/            # Core services, themes, and constants
├── core/services/   # API handlers and data processing
├── components/      # Reusable UI widgets (cards, buttons, etc.)
├── modules/         # Feature-based folders
│   ├── auth/        # Login, Register, OTP
│   ├── pos/         # Point of Sale UI
│   ├── kitchen/     # Kitchen Dashboard
│   └── home/        # Dashboard Overview
├── routes/          # Navigation and route definitions
└── main.dart        # Entry point
```

---

## 🔗 Project Dependencies

The frontend expects a running [Bukuku Backend API](https://github.com/filzaharry/bukuku-restaurant-backend) with:

1. **MySQL Database**: For user and menu data persistence.
2. **File Storage**: For image uploads and retrieval (Local Public Storage).
3. **Redis Caching**: Required by the backend for session and rate-limit tracking.

---

## 🔐 Registration & Authentication Flow

1. **User Registration**:
   - User signs up → Input data (Username, Email, Phone, Password).
   - Validation ensures email and phone are unique.
   - **Automatic Redirect**: On successful register, the user is instantly redirected to the **Login Page**.
2. **Login Process**:
   - Enter credentials → Receives **OTP Code** via email.
   - Enter OTP → Received JWT Token → Token stored securely via `GetStorage` or `Shared Preferences`.
3. **Session Management**:
   - Redirect to Home if token is present and valid.

---

## 🧪 Testing

```bash
# Run all frontend tests
flutter test

# Run Specific module tests
flutter test test/unit/auth_test.dart
```

---

## 📱 Build & Deployment

### Build for Android
```bash
# Build release APK
flutter build apk --release
```

### Build for Web
```bash
# Build release for Web hosting
flutter build web --release
```

---

**Built with ❤️ using Flutter**
