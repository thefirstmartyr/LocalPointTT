/// Route name constants for the application
class AppRoutes {
  // Auth routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String forgotPassword = '/forgot-password';

  // Main app routes (customer)
  static const String home = '/home';
  static const String programDetail = '/program-detail';
  static const String scan = '/scan';
  static const String scanSuccess = '/scan-success';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String legalInfo = '/legal-info';

  // Staff routes
  static const String staffLogin = '/staff/login';
  static const String staffScanner = '/staff/scanner';
  static const String staffManualLookup = '/staff/manual-lookup';

  // Prevent instantiation
  AppRoutes._();
}
