import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:local_point_tt/main.dart' as app;
import 'package:local_point_tt/presentation/screens/auth/registration_screen.dart';
import 'package:local_point_tt/presentation/screens/home/home_screen.dart';
import 'package:local_point_tt/core/constants/app_strings.dart';

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

  group('Registration Flow - End to End', () {
    testWidgets('Complete successful registration flow', (WidgetTester tester) async {
      // Arrange - Launch app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to registration screen (assumes there's a way to get there from home)
      // This might need adjustment based on your actual navigation flow
      // Example: await tester.tap(find.text('Sign Up'));
      // await tester.pumpAndSettle();

      // Generate unique test email to avoid conflicts
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'test+$timestamp@example.com';

      // Act - Fill registration form
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'Integration',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.lastName),
        'Test',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.email),
        testEmail,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.phone),
        '+1 868-555-0123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.password),
        'TestPassword123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.confirmPassword),
        'TestPassword123!',
      );

      // Accept terms and conditions
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.text(AppStrings.signUp));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Assert - Should navigate to HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
      
      // Verify success message appeared
      expect(find.text(AppStrings.successAccountCreated), findsOneWidget);

      // TODO: Add cleanup - delete test user from Firebase Auth and Firestore
    }, timeout: const Timeout(Duration(minutes: 2)));

    testWidgets('Registration with duplicate email shows error', (WidgetTester tester) async {
      // Arrange - Launch app
      app.main();
      await tester.pumpAndSettle();

      // Use an email that already exists in your test Firebase project
      const duplicateEmail = 'existing@example.com';

      // Act - Fill form with existing email
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'Duplicate',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.lastName),
        'User',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.email),
        duplicateEmail,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.phone),
        '+1 868-555-9999',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.password),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.confirmPassword),
        'Password123!',
      );

      // Accept terms
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.text(AppStrings.signUp));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Should show error message
      expect(find.text('This email is already registered.'), findsOneWidget);
      
      // Should still be on registration screen
      expect(find.byType(RegistrationScreen), findsOneWidget);
    }, timeout: const Timeout(Duration(minutes: 2)));

    testWidgets('Registration without phone number works', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'test+nophone+$timestamp@example.com';

      // Act - Fill form without phone number
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'NoPhone',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.lastName),
        'User',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.email),
        testEmail,
      );
      // Skip phone field
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.password),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.confirmPassword),
        'Password123!',
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.signUp));
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
      app.main();
      await tester.pumpAndSettle();

      // TODO: Simulate network failure here

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'test+offline+$timestamp@example.com';

      // Act - Try to register
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'Offline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.lastName),
        'Test',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.email),
        testEmail,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.phone),
        '+1 868-555-0000',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.password),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.confirmPassword),
        'Password123!',
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.signUp));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Should show network error message
      expect(find.text('Network error. Check your connection.'), findsOneWidget);
      expect(find.byType(RegistrationScreen), findsOneWidget);
    }, skip: true); // Skip by default - requires network simulation setup
  });

  group('Registration Form Validation - Integration', () {
    testWidgets('Cannot submit form with invalid data', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Try to submit with invalid email
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'Invalid',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.lastName),
        'Email',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.email),
        'not-an-email',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.password),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.confirmPassword),
        'Password123!',
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.signUp));
      await tester.pumpAndSettle();

      // Assert - Should show validation error
      expect(find.text(AppStrings.errorInvalidEmail), findsOneWidget);
      expect(find.byType(RegistrationScreen), findsOneWidget);
    });

    testWidgets('Cannot submit with mismatched passwords', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Enter different passwords
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'Mismatch',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.lastName),
        'Password',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.email),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.password),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.confirmPassword),
        'DifferentPassword456!',
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.signUp));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.errorPasswordMatch), findsOneWidget);
    });
  });
}
