# local_point_tt

```markdown
# Local Point TT - Flutter Project Initial Setup

## Project Information
- **App Name:** Local Point TT
- **Package Name:** com.localpointtt.app
- **Platform:** Android (Primary), iOS (Future)
- **Framework:** Flutter with Material Design 3
- **State Management:** Provider (recommended) or Riverpod

---

## 1. Update pubspec.yaml

Replace your `pubspec.yaml` dependencies section with the following:

```yaml
name: local_point_tt
description: Digital loyalty platform for local businesses in Trinidad and Tobago
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # UI Components
  cupertino_icons: ^1.0.6
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  fl_chart: ^0.66.0
  animations: ^2.0.11

  # QR Code
  qr_flutter: ^4.1.0
  qr_code_scanner: ^1.0.1
  mobile_scanner: ^3.5.5

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_messaging: ^14.7.9
  firebase_storage: ^11.5.6

  # State Management
  provider: ^6.1.1
  # OR use riverpod: ^2.4.9

  # Networking
  http: ^1.1.2
  dio: ^5.4.0

  # Local Storage
  shared_preferences: ^2.2.2
  sqflite: ^2.3.0
  path_provider: ^2.1.1

  # Utilities
  intl: ^0.18.1
  uuid: ^4.2.2
  connectivity_plus: ^5.0.2
  permission_handler: ^11.1.0
  image_picker: ^1.0.5
  url_launcher: ^6.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.7

flutter:
  uses-material-design: true

  # Uncomment and add assets as needed
  # assets:
  #   - assets/images/
  #   - assets/icons/
  #   - assets/illustrations/

  # fonts:
  #   - family: Roboto
  #     fonts:
  #       - asset: fonts/Roboto-Regular.ttf
  #       - asset: fonts/Roboto-Bold.ttf
  #         weight: 700
```

---

## 2. Project Structure

Create the following folder structure in your `lib` directory:

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_dimensions.dart
│   │   └── app_strings.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── helpers.dart
│   │   └── extensions.dart
│   └── config/
│       └── app_config.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── business_model.dart
│   │   ├── loyalty_program_model.dart
│   │   ├── transaction_model.dart
│   │   └── reward_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── user_repository.dart
│   │   ├── business_repository.dart
│   │   ├── loyalty_repository.dart
│   │   └── transaction_repository.dart
│   └── services/
│       ├── firebase_service.dart
│       ├── api_service.dart
│       ├── local_storage_service.dart
│       └── notification_service.dart
├── presentation/
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   ├── program_detail/
│   │   │   └── program_detail_screen.dart
│   │   ├── scan/
│   │   │   └── scan_screen.dart
│   │   ├── stats/
│   │   │   └── stats_screen.dart
│   │   ├── history/
│   │   │   └── history_screen.dart
│   │   ├── profile/
│   │   │   └── profile_screen.dart
│   │   └── notifications/
│   │       └── notifications_screen.dart
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── loading_indicator.dart
│   │   │   ├── empty_state.dart
│   │   │   └── error_widget.dart
│   │   ├── qr_code_display.dart
│   │   ├── program_card.dart
│   │   ├── transaction_card.dart
│   │   └── reward_card.dart
│   └── providers/
│       ├── auth_provider.dart
│       ├── user_provider.dart
│       ├── loyalty_provider.dart
│       └── transaction_provider.dart
└── routes/
    ├── app_router.dart
    └── route_names.dart
```

---

## 3. Core Configuration Files

### 3.1 `lib/core/constants/app_colors.dart`

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF00A86B); // Caribbean Green
  static const Color primaryVariant = Color(0xFF008C5A);
  static const Color primaryLight = Color(0xFFE6F7F0);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFFF6B35); // Coral Orange
  static const Color secondaryVariant = Color(0xFFE85A2B);
  static const Color secondaryLight = Color(0xFFFFE8E0);
  
  // Neutral Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Border & Divider
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFBDBDBD);
}
```

### 3.2 `lib/core/constants/app_dimensions.dart`

```dart
class AppDimensions {
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  
  // Elevation
  static const double elevationCard = 2.0;
  static const double elevationAppBar = 4.0;
  static const double elevationFAB = 6.0;
  static const double elevationModal = 8.0;
  
  // Button
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 40.0;
  
  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // QR Code
  static const double qrCodeSize = 180.0;
  static const double qrCodeSizeLarge = 300.0;
  
  // App Bar
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 56.0;
}
```

### 3.3 `lib/core/constants/app_strings.dart`

```dart
class AppStrings {
  // App
  static const String appName = 'Local Point TT';
  static const String appTagline = 'Loyalty Made Simple';
  
  // Onboarding
  static const String onboarding1Title = 'Earn Points at Your Favorite Local Shops';
  static const String onboarding1Desc = 'Scan your unique QR code at participating businesses to earn points with every visit';
  
  static const String onboarding2Title = 'Track Your Progress';
  static const String onboarding2Desc = 'Watch your points grow and see exactly how close you are to your next reward';
  
  static const String onboarding3Title = 'Redeem Amazing Rewards';
  static const String onboarding3Desc = 'Use your points for discounts, free items, and exclusive deals at local businesses';
  
  // Auth
  static const String welcomeBack = 'Welcome Back';
  static const String createAccount = 'Create Account';
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signInWithGoogle = 'Sign in with Google';
  
  // Form Fields
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String phone = 'Phone';
  
  // Home
  static const String yourPrograms = 'Your Programs';
  static const String joinNewProgram = 'Join New Program';
  static const String showAtCheckout = 'Show this at checkout';
  static const String tapToEnlarge = 'Tap to Enlarge';
  
  // Errors
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection';
  static const String errorInvalidEmail = 'Invalid email format';
  static const String errorPasswordLength = 'Password must be at least 8 characters';
  static const String errorPasswordMatch = 'Passwords do not match';
  static const String errorRequired = 'This field is required';
  
  // Success
  static const String successAccountCreated = 'Account created successfully!';
  static const String successPointsAdded = 'Points added successfully!';
  static const String successRewardRedeemed = 'Reward redeemed successfully!';
}
```

### 3.4 `lib/core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: AppDimensions.elevationAppBar,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: AppDimensions.elevationCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          side: const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingM,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationAppBar,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }
}
```

---

## 4. Main Application Files

### 4.1 `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/services/firebase_service.dart';
import 'data/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Local Storage
  await LocalStorageService.init();
  
  // Initialize Firebase Services
  await FirebaseService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        // Add your providers here
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
        // ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 4.2 `lib/app.dart`

```dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'presentation/screens/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      // Add routes here when router is implemented
    );
  }
}
```

---

## 5. Service Files (Stubs)

### 5.1 `lib/data/services/firebase_service.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  static Future<void> initialize() async {
    // Request notification permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    print('Notification permission: ${settings.authorizationStatus}');
    
    // Get FCM token
    String? token = await messaging.getToken();
    print('FCM Token: $token');
  }
}
```

### 5.2 `lib/data/services/local_storage_service.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // User Session
  static Future<void> saveUserId(String userId) async {
    await _prefs.setString('user_id', userId);
  }
  
  static String? getUserId() {
    return _prefs.getString('user_id');
  }
  
  static Future<void> clearSession() async {
    await _prefs.clear();
  }
  
  // Onboarding
  static Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool('onboarding_complete', value);
  }
  
  static bool isOnboardingComplete() {
    return _prefs.getBool('onboarding_complete') ?? false;
  }
}
```

---

## 6. Model Files (Examples)

### 6.1 `lib/data/models/user_model.dart`

```dart
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? profileImageUrl;
  final DateTime createdAt;
  
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.profileImageUrl,
    required this.createdAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  String get fullName => '$firstName $lastName';
  
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
}
```

### 6.2 `lib/data/models/loyalty_program_model.dart`

```dart
class LoyaltyProgramModel {
  final String id;
  final String businessId;
  final String businessName;
  final String businessIcon;
  final int currentPoints;
  final int totalPointsEarned;
  final int nextRewardThreshold;
  final String nextRewardName;
  final DateTime enrolledAt;
  
  LoyaltyProgramModel({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.businessIcon,
    required this.currentPoints,
    required this.totalPointsEarned,
    required this.nextRewardThreshold,
    required this.nextRewardName,
    required this.enrolledAt,
  });
  
  factory LoyaltyProgramModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyProgramModel(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      businessName: json['businessName'] as String,
      businessIcon: json['businessIcon'] as String,
      currentPoints: json['currentPoints'] as int,
      totalPointsEarned: json['totalPointsEarned'] as int,
      nextRewardThreshold: json['nextRewardThreshold'] as int,
      nextRewardName: json['nextRewardName'] as String,
      enrolledAt: DateTime.parse(json['enrolledAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessId': businessId,
      'businessName': businessName,
      'businessIcon': businessIcon,
      'currentPoints': currentPoints,
      'totalPointsEarned': totalPointsEarned,
      'nextRewardThreshold': nextRewardThreshold,
      'nextRewardName': nextRewardName,
      'enrolledAt': enrolledAt.toIso8601String(),
    };
  }
  
  int get pointsToNextReward => nextRewardThreshold - currentPoints;
  
  double get progressPercentage => 
      (currentPoints / nextRewardThreshold * 100).clamp(0, 100);
}
```

---

## 7. Splash Screen (First Screen)

### 7.1 `lib/presentation/screens/splash/splash_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/local_storage_service.dart';
import '../onboarding/onboarding_screen.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _animationController.forward();
    
    _navigateToNextScreen();
  }
  
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check if onboarding is complete
    bool onboardingComplete = LocalStorageService.isOnboardingComplete();
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => onboardingComplete 
            ? const LoginScreen() 
            : const OnboardingScreen(),
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder - replace with actual logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'LP',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                // Loading dots animation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(
                              ((_animationController.value + (index * 0.3)) % 1.0),
                            ),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 8. Android Configuration

### 8.1 Update `android/app/build.gradle`

Add the following after `android {` block:

```gradle
android {
    // ... existing config ...
    
    defaultConfig {
        // ... existing config ...
        minSdkVersion 21
        targetSdkVersion 34
        multiDexEnabled true
    }
}

dependencies {
    implementation 'com.android.support:multidex:1.0.3'
}
```

### 8.2 Update `android/app/src/main/AndroidManifest.xml`

Add permissions before `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

---

## 9. Firebase Setup Instructions

1. **Go to Firebase Console:** https://console.firebase.google.com
2. **Create a new project** named "Local Point TT"
3. **Add Android app:**
   - Package name: `com.localpointtt.app`
   - Download `google-services.json`
   - Place in `android/app/` directory
4. **Enable Authentication:**
   - Email/Password
   - Google Sign-In
5. **Create Firestore Database** (Start in test mode for now)
6. **Enable Cloud Messaging**

---

## 10. Setup Commands

Run these commands in order:

```bash
# Get dependencies
flutter pub get

# Clean build
flutter clean

# Run the app
flutter run
```

---

## 11. Next Steps After Initial Setup

1. ✅ Verify splash screen displays correctly
2. ✅ Create onboarding screen
3. ✅ Create login/register screens
4. ✅ Implement authentication
5. ✅ Create home screen with QR code display
6. ✅ Implement QR code scanning
7. ✅ Build remaining screens (stats, history, profile)
8. ✅ Integrate Firebase backend
9. ✅ Add state management
10. ✅ Test on physical Android device

---

## 12. API Keys & Secrets Management

### Secure Storage for API Keys

Store your API keys securely in the `config/secrets/` folder (automatically git-ignored):

```bash
# Copy template and add your keys
cp config/secrets.example/api_keys.dart config/secrets/api_keys.dart
# Edit config/secrets/api_keys.dart with your real API keys
```

**Available Formats:**
- `api_keys.dart` - Dart constants (recommended)
- `.env` - Environment variables
- `secrets.json` - JSON configuration

**Usage:**
```dart
import 'package:local_point_tt/config/secrets/api_keys.dart';

final key = ApiKeys.googleMapsApiKey;
```

**Documentation:**
- [config/README.md](config/README.md) - Configuration structure
- [config/secrets/README.md](config/secrets/README.md) - Detailed instructions

✅ **Security**: All files in `config/secrets/` are automatically ignored by git

---

## 13. Testing

### Comprehensive Testing Infrastructure

The app now has complete testing coverage with 57+ test cases:

- **Unit Tests**: 15 tests for AuthService (✅ all passing)
- **Widget Tests**: 20+ UI component tests
- **Integration Tests**: 8 end-to-end scenarios
- **Manual Tests**: 14 cross-platform test cases

**Quick Start:**
```bash
# Run unit tests
flutter test test/unit/

# View full testing guide
cat test/README.md
```

**Documentation:**
- [test/README.md](test/README.md) - Complete testing guide
- [test/MANUAL_TESTING_GUIDE.md](test/MANUAL_TESTING_GUIDE.md) - Manual test procedures
- [test/IMPLEMENTATION_SUMMARY.md](test/IMPLEMENTATION_SUMMARY.md) - What was implemented

---

## 14. Common Issues & Solutions

**Issue:** Firebase not initializing
- **Solution:** Ensure `google-services.json` is in correct location

**Issue:** Camera permission denied
- **Solution:** Check AndroidManifest.xml permissions

**Issue:** Package not found errors
- **Solution:** Run `flutter pub get` and restart IDE

**Issue:** Build fails on Android
- **Solution:** Run `flutter clean` then `flutter pub get`

---

## Notes

- This setup uses **Provider** for state management (can be swapped with Riverpod)
- **Material Design 3** is enabled for modern UI components
- All UI constants are centralized for easy theming
- Firebase is configured but requires `google-services.json` file
- The splash screen includes smooth animations
- Project structure follows clean architecture principles

You're now ready to start building the Local Point TT MVP! 🚀
```