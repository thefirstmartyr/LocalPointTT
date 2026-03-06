import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_point_tt/presentation/screens/auth/registration_screen.dart';
import 'package:local_point_tt/core/constants/app_strings.dart';

/// Widget tests for RegistrationScreen
/// 
/// Note: These tests verify UI rendering and basic interactions.
/// Full Firebase integration should be tested in integration tests.
/// Some tests may require Firebase initialization or Auth service mocking
/// to run successfully. See integration_test/ for end-to-end Firebase tests.

void main() {
  // Setup Firebase test environment if needed
  TestWidgetsFlutterBinding.ensureInitialized();
  group('RegistrationScreen - Widget Rendering', () {
    testWidgets('should render all form fields correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Assert - Check all fields are rendered
      expect(find.text(AppStrings.createAccount), findsOneWidget);
      expect(find.text('Sign up to start earning points'), findsOneWidget);
      
      // Form fields
      expect(find.byType(TextFormField), findsNWidgets(6)); // 6 input fields
      expect(find.text(AppStrings.firstName), findsOneWidget);
      expect(find.text(AppStrings.lastName), findsOneWidget);
      expect(find.text(AppStrings.email), findsOneWidget);
      expect(find.text(AppStrings.phone), findsOneWidget);
      expect(find.text(AppStrings.password), findsOneWidget);
      expect(find.text(AppStrings.confirmPassword), findsOneWidget);
      
      // Checkbox
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('I agree to the Terms and Conditions'), findsOneWidget);
      
      // Buttons
      expect(find.text(AppStrings.signUp), findsOneWidget);
      expect(find.text('Sign up with Google'), findsOneWidget);
      expect(find.text(AppStrings.signIn), findsOneWidget);
    });

    testWidgets('should render back button in AppBar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should have proper icons for each field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Assert - Check prefix icons
      expect(find.byIcon(Icons.person_outline), findsNWidgets(2)); // First + Last name
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsNWidgets(2)); // Password + Confirm
    });
  });

  group('RegistrationScreen - Form Validation', () {
    testWidgets('should show error when first name is empty', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Act - Find and tap sign up button without filling first name
      final signUpButton = find.text(AppStrings.signUp);
      await tester.tap(signUpButton);
      await tester.pump();

      // Assert
      expect(find.text(AppStrings.errorRequired), findsWidgets);
    });

    testWidgets('should show error when last name is empty', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Fill only first name
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'John',
      );

      // Act - Submit form
      await tester.tap(find.text(AppStrings.signUp));
      await tester.pump();

      // Assert - Should still show errors for other required fields
      expect(find.text(AppStrings.errorRequired), findsWidgets);
    });

    testWidgets('should show error for invalid email', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Act - Enter email without @ symbol
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.email),
        'invalidemail',
      );
      await tester.tap(find.text(AppStrings.signUp));
      await tester.pump();

      // Assert
      expect(find.text(AppStrings.errorInvalidEmail), findsOneWidget);
    });

    testWidgets('should show error when password is too short', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Act - Enter password with less than 8 characters
      final passwordField = find.widgetWithText(TextFormField, AppStrings.password);
      await tester.enterText(passwordField, '1234567');
      await tester.tap(find.text(AppStrings.signUp));
      await tester.pump();

      // Assert
      expect(find.text(AppStrings.errorPasswordLength), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Act - Enter different passwords
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.confirmPassword),
        'password456',
      );
      await tester.tap(find.text(AppStrings.signUp));
      await tester.pump();

      // Assert
      expect(find.text(AppStrings.errorPasswordMatch), findsOneWidget);
    });

    testWidgets('should show snackbar when terms not accepted', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Fill all fields correctly but don't check terms
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'John',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.lastName),
        'Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.email),
        'john@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.phone),
        '+1 868-123-4567',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.password),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.confirmPassword),
        'password123',
      );

      // Act - Submit without accepting terms
      await tester.tap(find.text(AppStrings.signUp));
      await tester.pump();

      // Assert - Snackbar should appear
      expect(find.text('Please accept the terms and conditions'), findsOneWidget);
    });
  });

  group('RegistrationScreen - Visibility Toggles', () {
    testWidgets('should toggle password visibility icon', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Check initial state - should show visibility_off icons
      expect(find.byIcon(Icons.visibility_off), findsWidgets);

      // Act - Tap first visibility toggle icon (for password field)
      final visibilityIcons = find.byIcon(Icons.visibility_off);
      await tester.tap(visibilityIcons.first);
      await tester.pump();

      // Assert - Should now show at least one visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should toggle confirm password visibility icon', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Check initial state
      expect(find.byIcon(Icons.visibility_off), findsWidgets);

      // Act - Tap second visibility toggle (for confirm password field)
      final visibilityIcons = find.byIcon(Icons.visibility_off);
      await tester.tap(visibilityIcons.last);
      await tester.pump();

      // Assert - Should show visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should toggle both password fields independently', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Act - Toggle both visibility icons
      final visibilityOffIcons = find.byIcon(Icons.visibility_off);
      await tester.tap(visibilityOffIcons.first);
      await tester.pump();
      
      final secondVisibilityOff = find.byIcon(Icons.visibility_off);
      await tester.tap(secondVisibilityOff.first);
      await tester.pump();

      // Assert - Both should now show visibility icons
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_off), findsNothing);
    });
  });

  group('RegistrationScreen - Checkbox Interaction', () {
    testWidgets('should toggle terms checkbox when tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Find checkbox
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      // Check initial state - should be unchecked
      Checkbox checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, isFalse);

      // Act - Tap checkbox
      await tester.tap(checkbox);
      await tester.pump();

      // Assert - Should be checked now
      checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, isTrue);
    });

    testWidgets('should toggle checkbox when text is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Find checkbox and text
      final checkbox = find.byType(Checkbox);
      final termsText = find.text('I agree to the Terms and Conditions');

      // Check initial state
      Checkbox checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, isFalse);

      // Act - Tap on the text
      await tester.tap(termsText);
      await tester.pump();

      // Assert - Checkbox should be checked
      checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, isTrue);
    });
  });

  group('RegistrationScreen - Navigation', () {
    testWidgets('should navigate back when back button is pressed', (WidgetTester tester) async {
      // Arrange
      bool popped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RegistrationScreen(),
                      ),
                    );
                    popped = true;
                  },
                  child: const Text('Go to Registration'),
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to registration screen
      await tester.tap(find.text('Go to Registration'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationScreen), findsOneWidget);

      // Act - Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - Should navigate back
      expect(popped, isTrue);
      expect(find.byType(RegistrationScreen), findsNothing);
    });

    testWidgets('should navigate back when "Sign In" is tapped', (WidgetTester tester) async {
      // Arrange
      bool popped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RegistrationScreen(),
                      ),
                    );
                    popped = true;
                  },
                  child: const Text('Go to Registration'),
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to registration screen
      await tester.tap(find.text('Go to Registration'));
      await tester.pumpAndSettle();

      // Act - Tap "Sign In" button
      await tester.tap(find.text(AppStrings.signIn));
      await tester.pumpAndSettle();

      // Assert - Should navigate back
      expect(popped, isTrue);
      expect(find.byType(RegistrationScreen), findsNothing);
    });
  });

  group('RegistrationScreen - Text Input', () {
    testWidgets('should accept text input in first name field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Act
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'John',
      );

      // Assert
      expect(find.text('John'), findsOneWidget);
    });

    testWidgets('should accept text input in all fields', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Act - Fill all fields
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.firstName),
        'John',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.lastName),
        'Doe',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.email),
        'john@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, AppStrings.phone),
        '+1 868-123-4567',
      );

      // Assert
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('+1 868-123-4567'), findsOneWidget);
    });
  });

  group('RegistrationScreen - UI Elements', () {
    testWidgets('should display divider with "OR" text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Assert
      expect(find.text('OR'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('should display "Already have account" text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: RegistrationScreen(),
        ),
      );

      // Assert
      expect(find.text(AppStrings.alreadyHaveAccount), findsOneWidget);
    });
  });
}
