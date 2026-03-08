import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/registration_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/programs/program_detail_screen.dart';
import '../../presentation/screens/scan/scan_screen.dart';
import '../../presentation/screens/scan/scan_success_screen.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/profile/settings_screen.dart';
import '../../presentation/screens/profile/change_password_screen.dart';
import '../../presentation/screens/profile/legal_info_screen.dart';
import '../../presentation/screens/staff/staff_login_screen.dart';
import '../../presentation/screens/staff/staff_scanner_screen.dart';
import '../../presentation/screens/staff/manual_customer_lookup_screen.dart';

/// Central app router that generates routes based on named routes
class AppRouter {
  /// Generate route for the given route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments if provided
    final args = settings.arguments;

    switch (settings.name) {
      // Auth routes
      case AppRoutes.splash:
        return _buildRoute(const SplashScreen(), settings);
      
      case AppRoutes.onboarding:
        return _buildRoute(const OnboardingScreen(), settings);
      
      case AppRoutes.login:
        return _buildRoute(const LoginScreen(), settings);
      
      case AppRoutes.registration:
        return _buildRoute(const RegistrationScreen(), settings);
      
      case AppRoutes.forgotPassword:
        return _buildRoute(const ForgotPasswordScreen(), settings);

      // Main app routes
      case AppRoutes.home:
        return _buildRoute(const HomeScreen(), settings);
      
      case AppRoutes.programDetail:
        if (args is Map<String, String>) {
          return _buildRoute(
            ProgramDetailScreen(
              programId: args['programId']!,
              businessId: args['businessId']!,
            ),
            settings,
          );
        }
        return _errorRoute(settings);
      
      case AppRoutes.scan:
        return _buildRoute(const ScanScreen(), settings);
      
      case AppRoutes.scanSuccess:
        if (args is Map<String, String>) {
          return _buildRoute(
            ScanSuccessScreen(
              title: args['title'] ?? 'Success',
              message: args['message'] ?? 'Scan completed successfully.',
            ),
            settings,
          );
        }
        return _buildRoute(const ScanSuccessScreen(), settings);
      
      case AppRoutes.notifications:
        return _buildRoute(const NotificationsScreen(), settings);
      
      case AppRoutes.editProfile:
        return _buildRoute(const EditProfileScreen(), settings);
      
      case AppRoutes.settings:
        return _buildRoute(const SettingsScreen(), settings);
      
      case AppRoutes.changePassword:
        return _buildRoute(const ChangePasswordScreen(), settings);
      
      case AppRoutes.legalInfo:
        if (args is Map<String, String>) {
          return _buildRoute(
            LegalInfoScreen(
              title: args['title']!,
              content: args['content']!,
            ),
            settings,
          );
        }
        return _errorRoute(settings);

      // Staff routes
      case AppRoutes.staffLogin:
        return _buildRoute(const StaffLoginScreen(), settings);
      
      case AppRoutes.staffScanner:
        return _buildRoute(const StaffScannerScreen(), settings);
      
      case AppRoutes.staffManualLookup:
        return _buildRoute(const ManualCustomerLookupScreen(), settings);

      // Unknown route
      default:
        return _errorRoute(settings);
    }
  }

  /// Build a MaterialPageRoute with the given widget
  static MaterialPageRoute _buildRoute(Widget widget, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => widget,
      settings: settings,
    );
  }

  /// Build an error route for undefined routes
  static MaterialPageRoute _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Route not found: ${settings.name}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Try to go back, or go to home
                  Navigator.of(_).pop();
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
      settings: settings,
    );
  }

  /// Get initial route based on authentication state
  /// This should be called from main.dart
  static String getInitialRoute() {
    // For now, always start at splash which will check auth
    return AppRoutes.splash;
  }
}
