# Firebase Registration Testing Guide

## Overview

This document provides comprehensive manual testing procedures for the registration screen's Firebase integration. These tests should be performed on multiple platforms (Web, Android, iOS) to ensure consistent behavior.

## Prerequisites

- **Firebase Project**: Ensure your Firebase project is properly configured
- **Test Environment**: Have access to Firebase Console to verify data
- **Platforms**: Test on Web (Chrome), Android emulator/device, and iOS simulator (if available)
- **Network**: Stable internet connection for Firebase operations
- **Test Data**: Prepare test email accounts that don't exist in production

## Test Environment Setup

### 1. Firebase Console Access
- URL: https://console.firebase.google.com
- Navigate to your project: "Local Point TT" (localpointtt)
- Open Authentication → Users tab
- Open Firestore Database → users collection

### 2. Test Data Generation
Use this format for test emails to keep them organized:
- `test+web+TIMESTAMP@example.com` (for Web tests)
- `test+android+TIMESTAMP@example.com` (for Android tests)
- `test+ios+TIMESTAMP@example.com` (for iOS tests)

Replace TIMESTAMP with current timestamp or test run number.

---

## Test Cases

### TC-REG-001: Successful Registration - All Fields

**Platform**: Web, Android, iOS  
**Priority**: Critical  
**Prerequisites**: App launched and registration screen accessible

**Steps**:
1. Navigate to registration screen
2. Enter valid data in all fields:
   - First Name: "John"
   - Last Name: "Doe"
   - Email: Use unique email (e.g., test+001@example.com)
   - Phone: "+1 868-555-0123"
   - Password: "Password123!"
   - Confirm Password: "Password123!"
3. Check "I agree to the Terms and Conditions" checkbox
4. Tap "Sign Up" button

**Expected Results**:
- ✓ Loading indicator appears on button
- ✓ Green success snackbar: "Account created successfully!"
- ✓ Navigates to Home Screen
- ✓ Firebase Console → Authentication shows new user with correct email
- ✓ Firebase Console → Firestore users/{uid} document contains:
  - firstName: "John"
  - lastName: "Doe"
  - email: test email used
  - phone: "+1 868-555-0123"
  - createdAt: timestamp

**Verification Time**: 3-5 seconds for Firebase operations

---

### TC-REG-002: Successful Registration - Without Phone

**Platform**: Web, Android, iOS  
**Priority**: High  
**Prerequisites**: App launched

**Steps**:
1. Navigate to registration screen
2. Fill all fields EXCEPT phone:
   - First Name: "Jane"
   - Last Name: "Smith"
   - Email: Unique email
   - Password: "SecurePass456!"
   - Confirm Password: "SecurePass456!"
3. Accept terms and conditions
4. Tap "Sign Up"

**Expected Results**:
- ✓ Registration succeeds
- ✓ Success message appears
- ✓ Navigates to Home Screen
- ✓ Firestore document has phone: null or phone field missing

---

### TC-REG-003: Duplicate Email Error

**Platform**: Web, Android, iOS  
**Priority**: Critical  
**Prerequisites**: A user account already exists with email "existing@example.com"

**Steps**:
1. Navigate to registration screen
2. Fill form with email that already exists:
   - Email: "existing@example.com"
   - (Fill other required fields correctly)
3. Accept terms
4. Tap "Sign Up"

**Expected Results**:
- ✓ Red error snackbar appears: "This email is already registered."
- ✓ User remains on registration screen
- ✓ Form fields retain entered data
- ✓ No new user created in Firebase Authentication
- ✓ No new document created in Firestore

---

### TC-REG-004: Form Validation - Empty Fields

**Platform**: Web, Android, iOS  
**Priority**: High

**Steps**:
1. Navigate to registration screen
2. Leave all fields empty
3. Tap "Sign Up" button

**Expected Results**:
- ✓ Validation errors appear under each required field:
  - First Name: "This field is required"
  - Last Name: "This field is required"
  - Email: "This field is required"
  - Phone: "This field is required"
  - Password: "This field is required"
  - Confirm Password: "This field is required"
- ✓ No Firebase operations triggered
- ✓ User remains on registration screen

---

### TC-REG-005: Email Validation

**Platform**: Web, Android, iOS  
**Priority**: High

**Test Cases**:

| Input Email | Expected Result |
|-------------|----------------|
| invalidemail | "Invalid email address" error |
| test@ | "Invalid email address" error |
| @example.com | "Invalid email address" error |
| test..user@example.com | May pass UI validation but fail Firebase |
| test@example | "Invalid email address" error |
| valid@example.com | ✓ Passes validation |

**Steps**:
1. For each invalid email format above:
   - Enter the email
   - Fill other fields correctly
   - Tap "Sign Up"
   - Verify appropriate error message

---

### TC-REG-006: Password Validation

**Platform**: Web, Android, iOS  
**Priority**: High

**Test Cases**:

| Password | Confirm Password | Expected Result |
|----------|-----------------|-----------------|
| 1234567 (7 chars) | 1234567 | "Password must be at least 8 characters" |
| Password1 | Password2 | "Passwords do not match" |
| Pass123! | Pass123! | ✓ Valid |
| 12345678 | 12345678 | ✓ Valid (passes UI, may fail Firebase weak-password check) |

**Steps**:
1. Test each password combination
2. Verify appropriate validation messages

---

### TC-REG-007: Terms and Conditions Requirement

**Platform**: Web, Android, iOS  
**Priority**: High

**Steps**:
1. Navigate to registration screen
2. Fill all fields correctly
3. Leave "Terms and Conditions" checkbox UNCHECKED
4. Tap "Sign Up"

**Expected Results**:
- ✓ Snackbar appears: "Please accept the terms and conditions"
- ✓ No Firebase operations triggered
- ✓ User remains on registration screen

---

### TC-REG-008: Password Visibility Toggle

**Platform**: Web, Android, iOS  
**Priority**: Medium

**Steps**:
1. Navigate to registration screen
2. Enter password in "Password" field
3. Verify password is obscured (shows dots/asterisks)
4. Tap the eye icon on password field
5. Verify password is now visible
6. Tap eye icon again
7. Verify password is obscured again
8. Repeat for "Confirm Password" field

**Expected Results**:
- ✓ Password fields initially obscured
- ✓ Eye icon toggles between visibility_off and visibility
- ✓ Password text becomes visible/hidden on toggle
- ✓ Both fields work independently

---

### TC-REG-009: Network Failure Handling

**Platform**: Web, Android, iOS  
**Priority**: High  
**Prerequisites**: Ability to disable network connection

**Steps**:
1. Navigate to registration screen
2. Fill all fields correctly
3. Disable network connection (airplane mode or disconnect WiFi)
4. Tap "Sign Up"

**Expected Results**:
- ✓ Error message appears: "Network error. Check your connection."
- ✓ Loading indicator stops
- ✓ User remains on registration screen
- ✓ Can retry after re-enabling network

---

### TC-REG-010: Special Characters in Name Fields

**Platform**: Web, Android, iOS  
**Priority**: Medium

**Test Cases**:

| First Name | Last Name | Expected Result |
|------------|-----------|-----------------|
| José | Martínez | ✓ Should work |
| O'Brien | McDonald | ✓ Should work |
| Anne-Marie | St. Pierre | ✓ Should work |
| 李 (Chinese) | 明 (Chinese) | ✓ Should work |
| Test123 | User456 | ✓ Should work (no validation prevents this) |

**Steps**:
1. Test each name combination
2. Complete registration
3. Verify data appears correctly in Firebase Console

---

### TC-REG-011: International Phone Numbers

**Platform**: Web, Android, iOS  
**Priority**: Medium

**Test Cases**:

| Phone Number | Country | Expected Result |
|--------------|---------|-----------------|
| +1 868-555-0123 | Trinidad & Tobago | ✓ Valid |
| +44 20 7946 0958 | UK | ✓ Valid |
| +1 (555) 123-4567 | USA | ✓ Valid |
| +86 138 0013 8000 | China | ✓ Valid |
| 868-555-0123 | Trinidad (no country code) | ✓ Valid (no format validation) |

**Steps**:
1. Test each phone format
2. Complete registration
3. Verify phone stored correctly in Firestore

---

### TC-REG-012: Navigation Tests

**Platform**: Web, Android, iOS  
**Priority**: Medium

**Test 1**: Back Button
1. Navigate to registration screen
2. Tap back arrow in AppBar
3. **Expected**: Returns to previous screen (login screen)

**Test 2**: "Sign In" Link
1. On registration screen
2. Tap "Sign In" button at bottom
3. **Expected**: Returns to login screen

**Test 3**: After Successful Registration
1. Complete valid registration
2. **Expected**: Automatically navigates to Home Screen

---

### TC-REG-013: Loading State Behavior

**Platform**: Web, Android, iOS  
**Priority**: Medium

**Steps**:
1. Navigate to registration screen
2. Fill form with valid data
3. Tap "Sign Up" button
4. Observe UI during registration process

**Expected Results**:
- ✓ "Sign Up" button shows CircularProgressIndicator (small spinner)
- ✓ Button is disabled (no double-tap possible)
- ✓ Form fields remain accessible but not interactable
- ✓ Loading indicator disappears after success/error

---

### TC-REG-014: Cross-Platform Consistency

**Platform**: Web, Android, iOS (run on all)  
**Priority**: High

Perform TC-REG-001 (successful registration) on all platforms:

**Verification Points**:
- ✓ UI layout appears correctly on all platforms
- ✓ Form validation works identically
- ✓ Firebase operations succeed on all platforms
- ✓ Success messages appear consistently
- ✓ Navigation behavior is consistent
- ✓ Same data structure in Firestore regardless of platform

---

## Firestore Data Verification

After each successful registration test, verify the Firestore document:

1. Open Firebase Console → Firestore Database
2. Navigate to users collection
3. Find document with UID matching the registered user
4. Verify document contains:

```json
{
  "firstName": "Expected First Name",
  "lastName": "Expected Last Name",
  "email": "test@example.com",
  "phone": "+1 868-555-0123" or null,
  "profileImageUrl": null,
  "createdAt": Timestamp (within last few minutes)
}
```

---

## Firebase Authentication Verification

1. Open Firebase Console → Authentication → Users
2. Verify new user entry shows:
   - UID (matches Firestore document ID)
   - Email
   - Created date
   - Display Name: "FirstName LastName"
   - Sign-in Provider: Email/Password

---

## Test Data Cleanup

After completing tests, clean up test accounts:

### Via Firebase Console

1. **Authentication**:
   - Go to Authentication → Users
   - Find test users (filter by email containing "test+")
   - Click three dots → Delete user

2. **Firestore**:
   - Go to Firestore Database → users collection
   - Delete corresponding user documents

### Via Script (Optional)

Create a cleanup script using Firebase Admin SDK:
```dart
// See test/scripts/cleanup_test_users.dart
// Run with: dart test/scripts/cleanup_test_users.dart
```

---

## Performance Benchmarks

Track registration completion time:

| Platform | Expected Time | Acceptable Range |
|----------|--------------|------------------|
| Web | 2-3 seconds | < 5 seconds |
| Android | 2-4 seconds | <6 seconds |
| iOS | 2-3 seconds | < 5 seconds |

Measure from "Sign Up" button tap to Home Screen appearance.

---

## Known Issues / Edge Cases

Document any issues found during testing:

1. **Issue**: [Description]
   - **Platform**: [Web/Android/iOS/All]
   - **Steps to Reproduce**: [Steps]
   - **Expected**: [What should happen]
   - **Actual**: [What actually happens]
   - **Workaround**: [If any]

---

## Test Execution Checklist

Mark tests completed for each platform:

| Test Case | Web | Android | iOS | Notes |
|-----------|-----|---------|-----|-------|
| TC-REG-001 | ☐ | ☐ | ☐ | |
| TC-REG-002 | ☐ | ☐ | ☐ | |
| TC-REG-003 | ☐ | ☐ | ☐ | |
| TC-REG-004 | ☐ | ☐ | ☐ | |
| TC-REG-005 | ☐ | ☐ | ☐ | |
| TC-REG-006 | ☐ | ☐ | ☐ | |
| TC-REG-007 | ☐ | ☐ | ☐ | |
| TC-REG-008 | ☐ | ☐ | ☐ | |
| TC-REG-009 | ☐ | ☐ | ☐ | |
| TC-REG-010 | ☐ | ☐ | ☐ | |
| TC-REG-011 | ☐ | ☐ | ☐ | |
| TC-REG-012 | ☐ | ☐ | ☐ | |
| TC-REG-013 | ☐ | ☐ | ☐ | |
| TC-REG-014 | ☐ | ☐ | ☐ | |

---

## Test Report Template

**Test Date**: [Date]  
**Tester**: [Name]  
**Platform**: [Web/Android/iOS]  
**App Version**: [Version]  
**Firebase Project**: localpointtt

**Summary**:
- Total Tests: 14
- Passed: [X]
- Failed: [X]
- Blocked: [X]

**Failed Tests**:
1. [Test Case ID]: [Brief description of failure]

**Critical Issues**:
1. [Issue description and impact]

**Notes**:
[Any additional observations]

---

## Automated Test Support

While manual testing is comprehensive, consider running these automated tests first:

```bash
# Run unit tests
flutter test test/unit/services/auth_service_test.dart

# Run widget tests (if Firebase mocks are configured)
flutter test test/widget/screens/registration_screen_test.dart

# Run integration tests (requires Firebase emulator or test project)
flutter test integration_test/registration_flow_test.dart
```

Automated tests should pass before beginning manual testing to ensure core functionality is working.
