# Bukuku Restaurant Management System - Frontend

<p align="center">
    <img src="https://flutter.dev/images/flutter-logo-sharing.png" width="200" alt="Flutter Logo">
</p>

<p align="center">
    <strong>Restaurant Management System Mobile App</strong><br>
    Built with Flutter, GetX state management, and responsive UI design
</p>

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Environment Setup](#environment-setup)
- [Project Structure](#project-structure)
- [API Integration](#api-integration)
- [Modules Overview](#modules-overview)
- [Testing](#testing)
- [Build & Deployment](#build--deployment)
- [Troubleshooting](#troubleshooting)

## 🚀 Features

### Core Functionality
- **JWT Authentication** with OTP verification flow
- **User Management** with role-based navigation
- **F&B Menu Management** (Create, Read, Update, Delete)
- **Kitchen Dashboard** with real-time order tracking
- **Order Management** with status updates
- **Responsive Design** for mobile and tablet

### UI/UX Features
- **Modern Material Design** with custom themes
- **GetX State Management** for reactive UI
- **Form Validation** with user-friendly error messages
- **Loading States** and progress indicators
- **Navigation Drawer** with dynamic menu items
- **Image Picker** for menu item uploads

### Technical Features
- **Dio HTTP Client** for API communication
- **Local Storage** for user preferences
- **Environment Configuration** for different environments
- **Error Handling** with retry mechanisms
- **Logging** for debugging and monitoring

## 📋 Requirements

### System Requirements
- **Flutter SDK** >= 3.16.0
- **Dart SDK** >= 3.2.0
- **Android Studio** / **VS Code** with Flutter extensions
- **Git** for version control

### Platform Support
- **Android** (API level 21+)
- **iOS** (iOS 12.0+)
- **Web** (Chrome, Safari, Firefox)
- **Desktop** (Windows, macOS, Linux)

### Dependencies
- **GetX** - State management & routing
- **Dio** - HTTP client for API calls
- **Image Picker** - Camera & gallery access
- **Shared Preferences** - Local storage
- **Connectivity Plus** - Network status

## 🛠️ Installation

### 1. Clone Repository
```bash
git clone https://github.com/your-username/bukuku.git
cd bukuku/frontend
```

### 2. Install Flutter
```bash
# Install Flutter SDK
# Follow: https://docs.flutter.dev/get-started/install

# Verify installation
flutter doctor
```

### 3. Install Dependencies
```bash
# Get Flutter dependencies
flutter pub get

# Check for missing dependencies
flutter doctor
```

### 4. Environment Setup
See [Environment Setup](#environment-setup) section.

### 5. Run Application
```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d chrome
flutter run -d android
flutter run -d ios
```

## ⚙️ Environment Setup

### Environment Variables (.env)

Create a `.env` file in the root directory:

```bash
# API Configuration
API_BASE_URL=http://127.0.0.1:8001/api/v1
API_TIMEOUT=30000

# App Configuration
APP_NAME=Bukuku Restaurant
APP_VERSION=1.0.0

# Debug Settings
DEBUG_MODE=true
ENABLE_LOGGING=true

# Feature Flags
ENABLE_KITCHEN_MODULE=true
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
```

### Environment File Setup Steps

1. **Create Environment File**
   ```bash
   touch .env
   ```

2. **Add Configuration**
   ```bash
   # Copy the template above and customize for your environment
   ```

3. **Update API URL**
   ```bash
   # Development
   API_BASE_URL=http://127.0.0.1:8001/api/v1
   
   # Production
   API_BASE_URL=https://your-api-domain.com/api/v1
   ```

### Environment-Specific Configurations

#### Development (.env)
```bash
API_BASE_URL=http://127.0.0.1:8001/api/v1
DEBUG_MODE=true
ENABLE_LOGGING=true
```

#### Production (.env.production)
```bash
API_BASE_URL=https://api.bukuku.com/api/v1
DEBUG_MODE=false
ENABLE_LOGGING=false
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
```

#### Testing (.env.testing)
```bash
API_BASE_URL=http://127.0.0.1:8001/api/v1
DEBUG_MODE=true
ENABLE_LOGGING=true
```

## 📁 Project Structure

```
lib/
├── core/                          # Core utilities and services
│   ├── constants/                 # App constants and enums
│   ├── models/                    # Data models
│   ├── services/                  # API services and handlers
│   ├── theme/                     # App theme and colors
│   └── utils/                     # Utility functions
├── components/                    # Reusable UI components
│   ├── ui_card.dart              # Custom card component
│   ├── ui_scaffold.dart          # App scaffold
│   └── ui_sidebar.dart           # Navigation drawer
├── modules/                       # Feature modules
│   ├── auth/                     # Authentication module
│   │   ├── controllers/          # Auth controllers
│   │   ├── views/               # Auth screens
│   │   └── bindings/            # Dependency injection
│   ├── food_beverage/            # F&B management
│   │   ├── items/               # Menu items
│   │   ├── categories/          # Menu categories
│   │   └── orders/              # Order management
│   ├── kitchen/                  # Kitchen dashboard
│   │   ├── controllers/          # Kitchen controllers
│   │   ├── views/               # Kitchen screens
│   │   └── repositories/        # Data repositories
│   ├── home/                     # Home dashboard
│   ├── orders/                   # Order management
│   ├── pos/                      # Point of sale
│   └── splash/                   # Splash screen
├── routes/                        # App routing
│   ├── app_pages.dart            # Route definitions
│   └── app_routes.dart           # Route constants
└── main.dart                      # App entry point
```

### Module Structure Pattern

Each module follows the GetX pattern:

```
module_name/
├── controllers/          # Business logic
├── views/               # UI screens
├── models/              # Data models
├── repositories/        # Data access
└── bindings/            # Dependency injection
```

## 🔌 API Integration

### HTTP Client Configuration

The app uses **Dio** for HTTP communication:

```dart
// lib/core/services/api_handler.dart
class ApiHandler extends GetxService {
  late Dio _dio;
  
  void onInit() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8001/api/v1',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ));
  }
}
```

### Authentication Flow

```dart
// Login with OTP flow
1. POST /auth/login → Send OTP
2. POST /auth/verify-otp → Get JWT token
3. Store token locally
4. Add token to API headers
```

### API Response Handling

```dart
// Standard response format
class BaseResponse<T> {
  final int statusCode;
  final String message;
  final T? data;
  
  BaseResponse.fromJson(Map<String, dynamic> json)
    : statusCode = json['statusCode'],
      message = json['message'],
      data = json['data'];
}
```

### Error Handling

```dart
// Global error handler
void handleApiError(DioError error) {
  switch (error.type) {
    case DioErrorType.connectionTimeout:
      Get.snackbar('Error', 'Connection timeout');
      break;
    case DioErrorType.receiveTimeout:
      Get.snackbar('Error', 'Receive timeout');
      break;
    case DioErrorType.badResponse:
      handleHttpError(error.response?.statusCode);
      break;
  }
}
```

## 📱 Modules Overview

### Authentication Module

**Features:**
- Login with email/password
- OTP verification
- Registration
- Password reset
- JWT token management

**Key Files:**
- `lib/modules/auth/controllers/auth_controller.dart`
- `lib/modules/auth/views/login_view.dart`
- `lib/modules/auth/views/otp_view.dart`

### F&B Management Module

**Features:**
- Menu item CRUD operations
- Category management
- Image upload
- Price management
- Search and filtering

**Key Files:**
- `lib/modules/food_beverage/items/controllers/item_controller.dart`
- `lib/modules/food_beverage/items/views/item_view.dart`
- `lib/modules/food_beverage/items/repositories/item_repository.dart`

### Kitchen Module

**Features:**
- Order dashboard
- Real-time status updates
- Order filtering
- Status management (pending → preparing → ready → completed)

**Key Files:**
- `lib/modules/kitchen/controllers/kitchen_controller.dart`
- `lib/modules/kitchen/views/kitchen_view.dart`
- `lib/modules/kitchen/repositories/kitchen_repository.dart`

### Home Module

**Features:**
- Dashboard overview
- Quick statistics
- Recent activities
- Navigation hub

**Key Files:**
- `lib/modules/home/controllers/home_controller.dart`
- `lib/modules/home/views/home_view.dart`

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/auth_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure

```
test/
├── unit/                     # Unit tests
│   ├── auth_test.dart      # Authentication logic
│   ├── api_test.dart       # API integration
│   └── utils_test.dart    # Utility functions
├── widget/                  # Widget tests
│   ├── auth_widget_test.dart
│   └── kitchen_widget_test.dart
└── integration/             # Integration tests
    ├── auth_flow_test.dart
    └── kitchen_flow_test.dart
```

### Test Examples

```dart
// Authentication test
test('Should login with valid credentials', () async {
  final authController = AuthController();
  await authController.login('test@example.com', 'password');
  expect(authController.isLoggedIn.value, true);
});

// Widget test
testWidgets('Should display login form', (WidgetTester tester) async {
  await tester.pumpWidget(LoginView());
  expect(find.byType(TextField), findsWidgets);
});
```

## 🚀 Build & Deployment

### Build for Different Platforms

#### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (Play Store)
flutter build appbundle --release
```

#### iOS
```bash
# Build iOS app
flutter build ios --release

# Build for App Store
flutter build ipa --release
```

#### Web
```bash
# Build web app
flutter build web --release

# Build with specific renderer
flutter build web --web-renderer canvaskit --release
```

#### Desktop
```bash
# Build Windows
flutter build windows --release

# Build macOS
flutter build macos --release

# Build Linux
flutter build linux --release
```

### Release Configuration

#### Android Release

1. **Configure Signing**
   ```bash
   # Create keystore
   keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```

2. **Update build.gradle**
   ```gradle
   android {
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile file(keystoreProperties['storeFile'])
               storePassword keystoreProperties['storePassword']
           }
       }
   }
   ```

3. **ProGuard Configuration**
   ```gradle
   buildTypes {
       release {
           minifyEnabled true
           proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
       }
   }
   ```

#### iOS Release

1. **Update Info.plist**
   ```xml
   <key>NSAppTransportSecurity</key>
   <dict>
       <key>NSAllowsArbitraryLoads</key>
       <true/>
   </dict>
   ```

2. **Configure Xcode**
   - Set team and bundle identifier
   - Update provisioning profiles
   - Configure app signing

### Deployment Options

#### Google Play Store

1. **Prepare Release**
   ```bash
   flutter build appbundle --release
   ```

2. **Upload to Play Console**
   - Create new release
   - Upload AAB file
   - Fill release notes
   - Submit for review

#### App Store

1. **Prepare Release**
   ```bash
   flutter build ipa --release
   ```

2. **Upload with Xcode**
   - Open Xcode project
   - Archive build
   - Upload to App Store Connect

#### Web Deployment

```bash
# Build for web
flutter build web --release

# Deploy to hosting
# - Firebase Hosting
# - Netlify
# - Vercel
# - GitHub Pages
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Flutter Doctor Issues
```bash
# Check Flutter installation
flutter doctor -v

# Fix Android licenses
flutter doctor --android-licenses

# Clean Flutter cache
flutter clean
flutter pub get
```

#### 2. Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check for dependency conflicts
flutter pub deps
```

#### 3. API Connection Issues
```bash
# Check API URL in .env
cat .env | grep API_BASE_URL

# Test API connectivity
curl -I http://127.0.0.1:8001/api/v1

# Check network permissions
# Android: android/app/src/main/AndroidManifest.xml
# iOS: ios/Runner/Info.plist
```

#### 4. State Management Issues
```bash
# Check GetX bindings
# Ensure controllers are properly initialized
# Verify dependency injection

# Debug GetX state
Get.log('Debug message');
```

#### 5. Platform-Specific Issues

##### Android
```bash
# Check Android SDK path
flutter config --android-studio-dir

# Update Gradle
cd android && ./gradlew build

# Clear Android cache
cd android && ./gradlew clean
```

##### iOS
```bash
# Update CocoaPods
cd ios && pod update

# Clean iOS build
cd ios && xcodebuild clean

# Reinstall pods
cd ios && pod install --repo-update
```

### Debug Mode

#### Enable Debug Logging
```dart
// In main.dart
void main() {
  Get.config(
    logWriterCallback: (String log, {bool isError = false}) {
      if (kDebugMode) {
        print(log);
      }
    },
  );
  runApp(MyApp());
}
```

#### Network Debugging
```dart
// Add Dio interceptor for logging
_dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
  logPrint: (obj) => print(obj),
));
```

#### Performance Profiling
```bash
# Flutter performance tools
flutter run --profile

# Memory profiling
flutter run --profile --trace-startup
```

### Performance Optimization

#### Build Optimization
```bash
# Build with optimizations
flutter build apk --release --shrink --obfuscate

# Web optimization
flutter build web --release --web-renderer canvaskit
```

#### Code Optimization
```dart
// Use const constructors
const Text('Hello');

// Use lazy loading
Get.lazyPut(() => AuthController());

// Optimize rebuilds
Obx(() => Text(controller.value));
```

#### Asset Optimization
```dart
# Compress images
# Use WebP format
# Implement lazy loading
```

## 📞 Support

### Getting Help
- **Documentation**: Check this README first
- **Flutter Docs**: https://docs.flutter.dev/
- **GetX Docs**: https://pub.dev/packages/get
- **Issues**: Create GitHub issue for bugs
- **Discussions**: Use GitHub Discussions for questions

### Contributing
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Code Style
- Follow Dart style guide
- Use GetX patterns
- Write tests for new features
- Update documentation

### License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using Flutter**
