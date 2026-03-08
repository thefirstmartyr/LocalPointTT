import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_test/integration_test.dart';
import 'package:local_point_tt/main.dart' as app;
import 'package:local_point_tt/presentation/screens/auth/login_screen.dart';
import 'package:local_point_tt/presentation/screens/auth/registration_screen.dart';
import 'package:local_point_tt/presentation/screens/home/home_screen.dart';
import 'package:local_point_tt/core/routes/app_routes.dart';
import 'package:local_point_tt/core/constants/app_strings.dart';
import 'package:local_point_tt/data/services/local_storage_service.dart';

/// Integration tests for the registration flow
/// 
/// These tests verify the complete user registration flow including:
/// - UI interactions
/// - Firebase Authentication
/// - Firestore data persistence
/// - Navigation after successful registration
/// 
/// Prerequisites:
/// 1. Firebase project must be configured (firebase_options.dart)
/// 2. For local testing, use Firebase Emulator Suite
/// 3. Test user accounts should be cleaned up after tests
/// 
/// Run tests with:
/// flutter test integration_test/registration_flow_test.dart
/// 
/// Or on a specific device:
/// flutter drive \
///   --driver=test_driver/integration_test.dart \
///   --target=integration_test/registration_flow_test.dart \
///   -d chrome

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder byKey(String key) => find.byKey(Key(key));

  Future<void> ensureVisible(WidgetTester tester, Finder finder) async {
    if (finder.evaluate().isEmpty) {
      fail('Expected widget not found: $finder');
    }

    if (find.byType(Scrollable).evaluate().isNotEmpty) {
      await tester.scrollUntilVisible(
        finder,
        160,
        scrollable: find.byType(Scrollable).first,
      );
    }

    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  Future<void> enterByKey(WidgetTester tester, String key, String value) async {
    final finder = byKey(key);
    await ensureVisible(tester, finder);
    await tester.enterText(finder, value);
    await tester.pumpAndSettle();
  }

  Future<void> ensureDuplicateUserExists(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      // If the user already exists we can continue.
    } finally {
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<void> launchAndOpenRegistration(WidgetTester tester) async {
    // Keep onboarding deterministic for whichever app instance is active.
    await LocalStorageService.init();
    await LocalStorageService.setOnboardingComplete(true);

    // Ensure a clean auth state where possible.
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // Ignore sign-out issues in setup.
    }

    // Bootstrap app if integration harness has not already done it.
    if (find.byType(Navigator).evaluate().isEmpty) {
      app.main();
      await tester.pump();
    }

    // Wait until a recognizable screen is available.
    final deadline = DateTime.now().add(const Duration(seconds: 45));
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 300));
      final onOnboarding = find.text('Skip').evaluate().isNotEmpty;
      final onLogin = find.byType(LoginScreen).evaluate().isNotEmpty;
      final onRegistration = find.byType(RegistrationScreen).evaluate().isNotEmpty;
      final onHome = find.byType(HomeScreen).evaluate().isNotEmpty;
      if (onOnboarding || onLogin || onRegistration || onHome) {
        break;
      }
    }
    await tester.pumpAndSettle();

    if (find.text('Skip').evaluate().isNotEmpty) {
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
    }

    if (find.byType(HomeScreen).evaluate().isNotEmpty &&
        find.byType(Navigator).evaluate().isNotEmpty) {
      final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
      navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      await tester.pumpAndSettle();
    }

    if (find.byType(LoginScreen).evaluate().isNotEmpty) {
      final signUpCta = find.byKey(const Key('login_sign_up_cta'));
      if (signUpCta.evaluate().isNotEmpty) {
        await tester.ensureVisible(signUpCta);
        await tester.pumpAndSettle();
        final buttonWidget = tester.widget<TextButton>(signUpCta);
        buttonWidget.onPressed?.call();
        await tester.pumpAndSettle();
      }
    }

    if (find.byType(RegistrationScreen).evaluate().isEmpty &&
        find.byType(Navigator).evaluate().isNotEmpty) {
      final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
      navigator.pushNamed(AppRoutes.registration);
      await tester.pumpAndSettle();
    }

    expect(find.byType(RegistrationScreen), findsOneWidget);
  }

  group('Registration Flow - End to End', () {
    testWidgets('Complete successful registration flow', (WidgetTester tester) async {
      // Arrange - Launch app and navigate to registration screen
      await launchAndOpenRegistration(tester);

      // Generate unique test email to avoid conflicts
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'test+$timestamp@example.com';

      // Act - Fill registration form
      await enterByKey(tester, 'reg_first_name_field', 'Integration');
      await enterByKey(tester, 'reg_last_name_field', 'Test');
      await enterByKey(tester, 'reg_email_field', testEmail);
      await enterByKey(tester, 'reg_phone_field', '+1 868-555-0123');
      await enterByKey(tester, 'reg_password_field', 'TestPassword123!');
      await enterByKey(tester, 'reg_confirm_password_field', 'TestPassword123!');

      // Accept terms and conditions
      final termsCheckbox = byKey('reg_terms_checkbox');
      await ensureVisible(tester, termsCheckbox);
      await tester.tap(termsCheckbox, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Submit form
      final submitButton = byKey('reg_submit_button');
      await ensureVisible(tester, submitButton);
      await tester.tap(submitButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Assert - Should navigate to HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);

      // TODO: Add cleanup - delete test user from Firebase Auth and Firestore
    }, timeout: const Timeout(Duration(minutes: 2)));

    testWidgets('Registration with duplicate email shows error', (WidgetTester tester) async {
      // Arrange - Launch app and navigate to registration screen
      await launchAndOpenRegistration(tester);

      // Use an email that already exists in your test Firebase project
      const duplicateEmail = 'integration.existing@example.com';
      const duplicatePassword = 'Password123!';

      // Ensure duplicate user exists in Firebase Auth.
      await ensureDuplicateUserExists(duplicateEmail, duplicatePassword);

      // Act - Fill form with existing email
      await enterByKey(tester, 'reg_first_name_field', 'Duplicate');
      await enterByKey(tester, 'reg_last_name_field', 'User');
      await enterByKey(tester, 'reg_email_field', duplicateEmail);
      await enterByKey(tester, 'reg_phone_field', '+1 868-555-9999');
      await enterByKey(tester, 'reg_password_field', 'Password123!');
      await enterByKey(tester, 'reg_confirm_password_field', 'Password123!');

      // Accept terms
      final termsCheckbox = byKey('reg_terms_checkbox');
      await ensureVisible(tester, termsCheckbox);
      await tester.tap(termsCheckbox, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Submit form
      final submitButton = byKey('reg_submit_button');
      await ensureVisible(tester, submitButton);
      await tester.tap(submitButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Should show error message
      expect(find.byType(HomeScreen), findsNothing);
      
      // Should still be on registration screen
      expect(find.byType(RegistrationScreen), findsOneWidget);
    }, timeout: const Timeout(Duration(minutes: 2)));

    testWidgets('Registration without phone number works', (WidgetTester tester) async {
      // Arrange
      await launchAndOpenRegistration(tester);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'test+nophone+$timestamp@example.com';

      // Act - Fill form without phone number
      await enterByKey(tester, 'reg_first_name_field', 'NoPhone');
      await enterByKey(tester, 'reg_last_name_field', 'User');
      await enterByKey(tester, 'reg_email_field', testEmail);
      // Skip phone field
      await enterByKey(tester, 'reg_password_field', 'Password123!');
      await enterByKey(tester, 'reg_confirm_password_field', 'Password123!');

      final termsCheckbox = byKey('reg_terms_checkbox');
      await ensureVisible(tester, termsCheckbox);
      await tester.tap(termsCheckbox, warnIfMissed: false);
      await tester.pumpAndSettle();

      final submitButton = byKey('reg_submit_button');
      await ensureVisible(tester, submitButton);
      await tester.tap(submitButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Assert - Should succeed and navigate to HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);

      // TODO: Verify in Firestore that phone field is null
      // TODO: Cleanup test user
    }, timeout: const Timeout(Duration(minutes: 2)));

    testWidgets('Network error during registration shows appropriate message', (WidgetTester tester) async {
      // Note: This test requires simulating network failure
      // This can be done by:
      // 1. Disabling network on the device/emulator before running
      // 2. Using a proxy to block Firebase requests
      // 3. Configuring Firebase emulator to simulate failures

      // Arrange
      await launchAndOpenRegistration(tester);

      // TODO: Simulate network failure here

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'test+offline+$timestamp@example.com';

      // Act - Try to register
      await enterByKey(tester, 'reg_first_name_field', 'Offline');
      await enterByKey(tester, 'reg_last_name_field', 'Test');
      await enterByKey(tester, 'reg_email_field', testEmail);
      await enterByKey(tester, 'reg_phone_field', '+1 868-555-0000');
      await enterByKey(tester, 'reg_password_field', 'Password123!');
      await enterByKey(tester, 'reg_confirm_password_field', 'Password123!');

      final termsCheckbox = byKey('reg_terms_checkbox');
      await ensureVisible(tester, termsCheckbox);
      await tester.tap(termsCheckbox, warnIfMissed: false);
      await tester.pumpAndSettle();

      final submitButton = byKey('reg_submit_button');
      await ensureVisible(tester, submitButton);
      await tester.tap(submitButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Should show network error message
      expect(find.text('Network error. Check your connection.'), findsOneWidget);
      expect(find.byType(RegistrationScreen), findsOneWidget);
    }, skip: true); // Skip by default - requires network simulation setup
  });

  group('Registration Form Validation - Integration', () {
    testWidgets('Cannot submit form with invalid data', (WidgetTester tester) async {
      // Arrange
      await launchAndOpenRegistration(tester);

      // Act - Try to submit with invalid email
      await enterByKey(tester, 'reg_first_name_field', 'Invalid');
      await enterByKey(tester, 'reg_last_name_field', 'Email');
      await enterByKey(tester, 'reg_email_field', 'not-an-email');
      await enterByKey(tester, 'reg_password_field', 'Password123!');
      await enterByKey(tester, 'reg_confirm_password_field', 'Password123!');

      final termsCheckbox = byKey('reg_terms_checkbox');
      await ensureVisible(tester, termsCheckbox);
      await tester.tap(termsCheckbox, warnIfMissed: false);
      await tester.pumpAndSettle();

      final submitButton = byKey('reg_submit_button');
      await ensureVisible(tester, submitButton);
      await tester.tap(submitButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Assert - Should show validation error
      expect(find.text(AppStrings.errorInvalidEmail), findsOneWidget);
      expect(find.byType(RegistrationScreen), findsOneWidget);
    });

    testWidgets('Cannot submit with mismatched passwords', (WidgetTester tester) async {
      // Arrange
      await launchAndOpenRegistration(tester);

      // Act - Enter different passwords
      await enterByKey(tester, 'reg_first_name_field', 'Mismatch');
      await enterByKey(tester, 'reg_last_name_field', 'Password');
      await enterByKey(tester, 'reg_email_field', 'test@example.com');
      await enterByKey(tester, 'reg_password_field', 'Password123!');
      await enterByKey(tester, 'reg_confirm_password_field', 'DifferentPassword456!');

      final termsCheckbox = byKey('reg_terms_checkbox');
      await ensureVisible(tester, termsCheckbox);
      await tester.tap(termsCheckbox, warnIfMissed: false);
      await tester.pumpAndSettle();

      final submitButton = byKey('reg_submit_button');
      await ensureVisible(tester, submitButton);
      await tester.tap(submitButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.errorPasswordMatch), findsOneWidget);
    });
  });
}
