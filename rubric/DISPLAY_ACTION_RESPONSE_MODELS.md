# DISPLAY–ACTION RESPONSE MODELS
## Local Point TT - System Interaction Documentation

---

## 1. ONBOARDING FLOW

### 1.1 Splash Screen
**Display:**
- Application logo
- Loading indicator
- Brand colors and identity

**User Actions:**
None (automatic progression)

**System Response:**
- Check authentication state
- Check onboarding completion status
- **IF** onboarding incomplete → Navigate to Onboarding Screen
- **IF** onboarding complete AND user not authenticated → Navigate to Login Screen
- **IF** user authenticated → Navigate to Home Screen
- Duration: 2-3 seconds

---

### 1.2 Onboarding Screen
**Display:**
- Page 1: QR code icon, title, description about scanning
- Page 2: Trending icon, title, description about earning points
- Page 3: Gift card icon, title, description about rewards
- Page indicator dots (current page highlighted)
- Skip button (top-right)
- Next/Get Started button (bottom)

**User Actions:**
| Action | System Response |
|--------|----------------|
| Swipe left/right | Transition to next/previous onboarding page with animation |
| Tap page indicator dot | Jump to specific onboarding page |
| Tap "Skip" | Mark onboarding complete → Navigate to Login Screen |
| Tap "Next" (pages 1-2) | Progress to next onboarding page |
| Tap "Get Started" (page 3) | Mark onboarding complete → Navigate to Login Screen |

**System Behavior:**
- Persist onboarding completion status in local storage
- Never show onboarding again after completion
- Smooth page transitions with animation curves

---

## 2. AUTHENTICATION FLOWS

### 2.1 Login Screen
**Display:**
- Application logo/header
- Email input field (with keyboard type: email)
- Password input field (obscured text with toggle visibility icon)
- "Forgot Password?" link
- "Sign In" button (primary action)
- "Sign in with Google" button (secondary action)
- "Don't have an account? Sign Up" link
- Loading spinner (when processing)

**User Actions:**
| Action | System Response |
|--------|----------------|
| Enter email | Validate email format on focus loss; Show inline error if invalid |
| Enter password | Mask characters; Toggle visibility icon enabled |
| Tap password visibility icon | Toggle between masked/visible password text |
| Tap "Forgot Password?" | Navigate to Forgot Password Screen |
| Tap "Sign In" with invalid form | Show field-level validation errors; Prevent submission |
| Tap "Sign In" with valid form | Display loading state → Authenticate via Firebase → **Success:** Navigate to Home → **Failure:** Display error snackbar (red background) |
| Tap "Sign in with Google" | Launch Google sign-in dialog → **Success:** Navigate to Home → **Cancelled:** Dismiss loading → **Failure:** Show error snackbar |
| Tap "Sign Up" link | Navigate to Registration Screen |

**System Behavior:**
- Email validation: Must contain "@" and domain
- Password validation: Minimum length checked
- Error messages displayed via snackbar at bottom of screen
- Disable submit during processing to prevent duplicate requests
- Auto-trim whitespace from email input
- Maintain authentication state via Firebase SDK

---

### 2.2 Registration Screen
**Display:**
- "Create Account" header
- First name input field
- Last name input field
- Email input field (keyboard type: email)
- Phone number input field (optional, keyboard type: phone)
- Password input field (obscured with visibility toggle)
- Confirm password input field (obscured with visibility toggle)
- Terms and conditions checkbox with text
- "Create Account" button (primary action)
- "Sign up with Google" button (secondary action)
- "Already have an account? Log In" link
- Loading spinner (when processing)

**User Actions:**
| Action | System Response |
|--------|----------------|
| Enter first name | No immediate validation; Required field checked on submit |
| Enter last name | No immediate validation; Required field checked on submit |
| Enter email | Validate format on focus loss; Show inline error if invalid |
| Enter phone number | Optional field; Format validation on focus loss |
| Enter password | Mask characters; Enable visibility toggle |
| Enter confirm password | Mask characters; Enable visibility toggle |
| Tap password visibility toggle | Switch between masked/visible text |
| Tap terms checkbox | Toggle checkbox state (checked/unchecked) |
| Tap "Create Account" (terms not accepted) | Display snackbar: "Please accept the terms and conditions" |
| Tap "Create Account" (invalid form) | Display field-level validation errors; Prevent submission |
| Tap "Create Account" (valid form) | **Step 1:** Display loading state → **Step 2:** Create Firebase Auth account → **Step 3:** Create Firestore user document → **Step 4:** Display success snackbar (green) → **Step 5:** Navigate to Home Screen |
| Tap "Create Account" (duplicate email) | Stop loading → Display error snackbar: "Email already in use" → Remain on Registration Screen |
| Tap "Create Account" (network error) | Stop loading → Display error snackbar: "Network error. Check connection." |
| Tap "Sign up with Google" | Launch Google auth flow → Auto-populate user data → Navigate to Home on success |
| Tap "Log In" link | Navigate to Login Screen |

**System Behavior:**
- **Validation Rules:**
  - First name: Required, 2+ characters
  - Last name: Required, 2+ characters
  - Email: Required, valid email format
  - Phone: Optional, valid phone format if provided
  - Password: Required, 8+ characters, contains number and special character
  - Confirm password: Must match password exactly
  - Terms: Must be checked before submission

- **Error Handling:**
  - Display field-level errors inline below each field
  - Display system-level errors via snackbar
  - All error messages clear when user begins editing the field
  - Network errors include retry guidance

- **Success Flow:**
  - Create Firebase Authentication account
  - Store user profile in Firestore (users collection)
  - Set authentication state
  - Show success confirmation
  - Auto-navigate to Home Screen
  - User is now logged in across app

---

### 2.3 Forgot Password Screen
**Display:**
- "Reset Password" header
- Instructional text: "Enter your email to receive reset instructions"
- Email input field
- "Send Reset Link" button
- Back navigation button/icon

**User Actions:**
| Action | System Response |
|--------|----------------|
| Enter email | Validate format on focus loss |
| Tap "Send Reset Link" (invalid email) | Display inline validation error |
| Tap "Send Reset Link" (valid email) | Display loading → Send Firebase password reset email → **Success:** Show success message "Check your email for reset instructions" → Enable "Return to Login" button |
| Tap "Send Reset Link" (email not found) | Show message: "If account exists, reset email sent" (security measure) |
| Tap back button | Navigate back to Login Screen |

**System Behavior:**
- Uses Firebase Auth password reset flow
- Sends templated email with reset link
- Link expires after 1 hour
- Doesn't reveal if email exists (security best practice)

---

## 3. MAIN APPLICATION FLOWS

### 3.1 Home Screen (Main Navigation Hub)
**Display:**
- App bar with app name and notification bell icon
- Bottom navigation bar with 4 tabs:
  - Home (house icon)
  - Stats (bar chart icon)
  - History (clock icon)
  - Profile (person icon)
- Floating action button: "Scan" with QR scanner icon (center-docked)
- Tab-specific content in body

**User Actions:**
| Action | System Response |
|--------|----------------|
| App loads | Load Home tab by default; Fetch user programs and businesses from Firestore |
| Tap notification bell | Navigate to Notifications Screen |
| Tap bottom nav item | Switch to corresponding tab with smooth transition; Update selected state |
| Tap "Scan" FAB | Navigate to Scan Screen |

---

### 3.2 Home Tab (within Home Screen)
**Display:**
- Welcome message: "Hello, [First Name]!"
- "My Programs" section header
- List of enrolled loyalty programs (cards):
  - Business logo/image
  - Program name
  - Points balance
  - Progress bar toward next reward
- Empty state: "Join a program to get started" + "Scan QR Code" button
- Pull-to-refresh indicator

**User Actions:**
| Action | System Response |
|--------|----------------|
| Screen loads | Fetch user's enrolled programs from Firestore → Display loading skeleton → Populate program cards |
| Pull down to refresh | Show refresh indicator → Re-fetch programs → Update display |
| Tap program card | Navigate to Program Detail Screen with program data |
| Tap "Scan QR Code" (empty state) | Navigate to Scan Screen |
| No programs enrolled | Display empty state with call-to-action |

**System Behavior:**
- Query Firestore for user_programs where userId matches current user
- For each program, fetch associated business and program details
- Calculate points balance from transactions
- Display real-time data (uses Firestore listeners)
- Cache data for offline viewing

---

### 3.3 Stats Tab (within Home Screen)
**Display:**
- Total points earned (all programs)
- Total transactions count
- Most frequent business (with logo)
- Monthly activity chart/graph
- Achievements section

**User Actions:**
| Action | System Response |
|--------|----------------|
| Tab loads | Aggregate statistics from all user transactions → Display visualizations |
| Pull to refresh | Re-calculate statistics → Update display |

**System Behavior:**
- Query all transactions for current user
- Calculate aggregations (sum, count, group by business)
- Generate chart data for last 6 months
- Update in real-time when new transactions occur

---

### 3.4 History Tab (within Home Screen)
**Display:**
- "Transaction History" header
- Chronological list of transactions (most recent first):
  - Business name and logo
  - Points earned/redeemed
  - Transaction type (earn/redeem)
  - Date and time
  - Transaction ID
- Filter options: All, Earned, Redeemed
- Empty state: "No transactions yet"

**User Actions:**
| Action | System Response |
|--------|----------------|
| Tab loads | Fetch user transactions from Firestore → Display in list |
| Scroll down | Load more transactions (pagination, 20 per page) |
| Tap filter option | Filter transactions by type → Refresh list |
| Tap transaction item | Show transaction detail dialog with full information |
| Pull to refresh | Re-fetch recent transactions |

**System Behavior:**
- Query transactions collection where userId matches
- Order by timestamp descending
- Implement infinite scroll with pagination
- Color coding: Green for points earned, Blue for points redeemed
- Real-time updates via Firestore listeners

---

### 3.5 Profile Tab (within Home Screen)
**Display:**
- User avatar/profile picture placeholder
- User full name
- User email
- Menu options:
  - Edit Profile
  - Change Password
  - Settings
  - Legal Information
  - Sign Out
- App version number (footer)

**User Actions:**
| Action | System Response |
|--------|----------------|
| Tab loads | Display current user information from Firebase Auth + Firestore |
| Tap "Edit Profile" | Navigate to Edit Profile Screen |
| Tap "Change Password" | Navigate to Change Password Screen |
| Tap "Settings" | Navigate to Settings Screen |
| Tap "Legal Information" | Navigate to Legal Info Screen (Terms, Privacy Policy) |
| Tap "Sign Out" | Show confirmation dialog → **Confirm:** Sign out from Firebase → Clear local data → Navigate to Login Screen |

**System Behavior:**
- Load user data from Firestore users collection
- Sync with Firebase Auth current user
- Sign out clears authentication state globally

---

## 4. QR CODE SCANNING FLOW

### 4.1 Scan Screen
**Display:**
- Camera viewfinder (full screen or large area)
- Scanning frame/overlay (guides QR code placement)
- "Point camera at QR code" instruction text
- Flashlight toggle button (if device supports)
- Back button
- Camera permission request dialog (first time)

**User Actions:**
| Action | System Response |
|--------|----------------|
| Screen opens | **IF** camera permission granted → Initialize camera → Start scanning → **IF** camera permission not granted → Show permission request dialog |
| Tap "Allow" (permission dialog) | Grant camera access → Initialize camera → Start scanning |
| Tap "Deny" (permission dialog) | Show error message → Display manual program entry option |
| QR code detected in frame | Highlight detected code → Auto-capture → Process code → Disable further scanning (prevent duplicates) |
| Processing QR code (valid format) | Parse programId and businessId → Call enrollUserInProgram API → Navigate to Scan Success Screen |
| Processing QR code (invalid format) | Display error snackbar: "Invalid QR code format" → Resume scanning after 2 seconds |
| Processing fails (network error) | Display error snackbar: "Network error. Try again." → Resume scanning |
| Processing fails (already enrolled) | Display error snackbar: "Already enrolled in this program" → Resume scanning |
| Tap flashlight toggle | Turn flashlight on/off |
| Tap back button | Stop camera → Dispose controller → Navigate back to Home |

**System Behavior:**
- **Expected QR Code Format:** `programId|businessId`
- **Processing Steps:**
  1. Detect and capture QR code
  2. Parse raw value string
  3. Split on "|" delimiter
  4. Validate both IDs are non-empty
  5. Query Firestore to verify program and business exist
  6. Check if user already enrolled
  7. Create user_programs document
  8. Initialize points balance to 0
  9. Set enrollment date to current timestamp
  10. Navigate to success screen

- **Error Handling:**
  - Invalid format: Missing delimiter, empty fields
  - Non-existent program: Program ID not found in database
  - Non-existent business: Business ID not found
  - Already enrolled: user_programs document already exists
  - Network failure: Firestore connection error

---

### 4.2 Scan Success Screen
**Display:**
- Success icon (checkmark animation)
- Success message: "Program Joined!"
- Program details (name, business, description)
- Points balance: 0
- "View My Programs" button (primary)
- "Scan Another" button (secondary)

**User Actions:**
| Action | System Response |
|--------|----------------|
| Screen loads | Display success animation (1 second) → Show program details |
| Tap "View My Programs" | Navigate to Home Screen (Home tab selected) |
| Tap "Scan Another" | Navigate back to Scan Screen |
| Tap back button | Navigate to Home Screen |

---

## 5. PROFILE MANAGEMENT FLOWS

### 5.1 Edit Profile Screen
**Display:**
- "Edit Profile" header with back button
- Profile picture (with edit icon overlay)
- First name input field (pre-populated)
- Last name input field (pre-populated)
- Email input field (pre-populated, disabled/read-only)
- Phone number input field (pre-populated, optional)
- "Save Changes" button
- Loading indicator (when saving)

**User Actions:**
| Action | System Response |
|--------|----------------|
| Screen loads | Fetch current user data from Firestore → Populate fields |
| Edit first name | Enable save button; Clear any previous errors |
| Edit last name | Enable save button; Clear any previous errors |
| Edit phone number | Validate format on focus loss |
| Tap profile picture | Show options: "Take Photo", "Choose from Library", "Remove Photo" |
| Tap "Save Changes" (invalid data) | Display field-level validation errors |
| Tap "Save Changes" (valid data) | Display loading → Update Firestore user document → Update Firebase Auth displayName → Display success snackbar → Navigate back to Profile tab |
| Tap "Save Changes" (network error) | Stop loading → Display error snackbar |
| Tap back button | Ask confirmation if unsaved changes → Navigate back (discard changes) |

**System Behavior:**
- Email cannot be changed (requires re-authentication)
- Phone number optional but must be valid format if provided
- Update both Firestore and Firebase Auth in transaction
- Optimistic updates with rollback on failure

---

### 5.2 Change Password Screen
**Display:**
- "Change Password" header
- Current password input field (obscured)
- New password input field (obscured, with strength indicator)
- Confirm new password input field (obscured)
- Password requirements list (with checkmarks):
  - At least 8 characters
  - Contains a number
  - Contains a special character
- "Update Password" button

**User Actions:**
| Action | System Response |
|--------|----------------|
| Enter current password | No immediate validation |
| Enter new password | Update strength indicator in real-time; Check requirements; Show checkmarks for met requirements |
| Enter confirm new password | Validate match with new password on focus loss |
| Tap "Update Password" (invalid) | Display validation errors |
| Tap "Update Password" (valid) | Display loading → Re-authenticate user with current password → Update password in Firebase Auth → Display success message → Navigate back |
| Tap "Update Password" (wrong current password) | Display error: "Current password is incorrect" |
| Tap "Update Password" (network error) | Display error snackbar with retry option |

**System Behavior:**
- Requires re-authentication for security
- Password strength calculation in real-time
- Visual feedback for each requirement met
- Success automatically logs user in with new password

---

## 6. PROGRAM DETAIL FLOW

### 6.1 Program Detail Screen
**Display:**
- Business header image/banner
- Business name and logo
- Program name
- Current points balance (large, prominent)
- Progress toward next reward (visual bar)
- "Rewards" section:
  - List of available rewards with point costs
  - Locked/unlocked states based on balance
- Transaction history for this program
- "Earn Points" button → Opens scan screen
- "Redeem Points" button (if balance > 0)

**User Actions:**
| Action | System Response |
|--------|----------------|
| Screen loads | Fetch program details, user_program data, and rewards from Firestore → Display information |
| Scroll through rewards | Show all rewards with required points |
| Tap reward item (insufficient points) | Show message: "Need X more points to unlock this reward" |
| Tap reward item (sufficient points) | Show confirmation dialog with reward details → **Confirm:** Navigate to redemption flow |
| Tap "Earn Points" | Navigate to Scan Screen |
| Tap "Redeem Points" | Show available rewards in bottom sheet |
| Pull to refresh | Re-fetch program data and balance |

**System Behavior:**
- Calculate points balance from all transactions for this program
- Update progress bar based on next reward threshold
- Show visual indicators (locked icons) for unavailable rewards
- Real-time balance updates

---

## 7. STAFF INTERFACE FLOWS

### 7.1 Staff Login Screen
**Display:**
- "Staff Portal" header
- Staff ID input field
- PIN input field (numeric keyboard, obscured)
- "Sign In" button
- Link back to customer login

**User Actions:**
| Action | System Response |
|--------|----------------|
| Enter staff ID | No immediate validation |
| Enter PIN | Mask input; Numeric keyboard displayed |
| Tap "Sign In" (valid credentials) | Authenticate against staff collection in Firestore → Navigate to Staff Scanner Screen |
| Tap "Sign In" (invalid credentials) | Display error: "Invalid staff ID or PIN" |
| Tap customer login link | Navigate to regular Login Screen |

**System Behavior:**
- Query staff collection for matching staffId and PIN hash
- Store staff session separately from customer auth
- Different permissions and navigation flow

---

### 7.2 Staff Scanner Screen
**Display:**
- Camera viewfinder
- Scan instruction: "Scan customer's program QR code"
- Manual lookup button
- Transaction type toggle: "Award Points" / "Redeem Points"
- Points input field (numeric)
- Staff name and business name (header)
- Transaction counter (today's total)

**User Actions:**
| Action | System Response |
|--------|----------------|
| QR code detected | Parse customer program QR → Fetch customer details → Display customer name and current balance → Enable points input |
| Enter points amount | Validate against business rules (min/max limits) |
| Toggle transaction type | Switch between award and redemption modes |
| Tap "Complete Transaction" (award points) | Create transaction record → Update user_program balance (+points) → Display success → Reset scanner |
| Tap "Complete Transaction" (redeem, insufficient balance) | Display error: "Customer has insufficient points" |
| Tap "Complete Transaction" (redeem, sufficient balance) | Create transaction record → Update user_program balance (-points) → Display success → Reset scanner |
| Tap "Manual Lookup" | Navigate to Manual Customer Lookup Screen |

**System Behavior:**
- Validate staff permissions for business
- Enforce daily transaction limits per staff member
- Create audit trail for all transactions
- Update balances in real-time
- Log transaction metadata (staff ID, timestamp, location)

---

### 7.3 Manual Customer Lookup Screen
**Display:**
- Search input field (customer email or phone)
- "Search" button
- Search results list:
  - Customer name
  - Enrolled programs
  - Current balances
- Select customer action

**User Actions:**
| Action | System Response |
|--------|----------------|
| Enter search term | No immediate validation |
| Tap "Search" | Query Firestore users collection → Display matching customers → Show their active programs for current business |
| Tap customer in results | Select customer → Display program selection dialog |
| Select program | Navigate back to Staff Scanner with customer data pre-loaded |
| Tap back | Return to Staff Scanner Screen |

**System Behavior:**
- Search across email and phone fields
- Filter results to only show customers with programs at current business
- Prevent cross-business data access

---

## 8. NOTIFICATIONS FLOW

### 8.1 Notifications Screen
**Display:**
- "Notifications" header
- List of notifications (chronological):
  - Notification icon (based on type)
  - Title
  - Message
  - Timestamp
  - Read/unread indicator
- Empty state: "No notifications yet"
- "Mark all as read" button (header)

**User Actions:**
| Action | System Response |
|--------|----------------|
| Screen loads | Fetch notifications from Firestore → Mark as read → Display list |
| Tap notification | Navigate to relevant screen (program detail, transaction history, etc.) |
| Tap "Mark all as read" | Update all notifications → Remove unread indicators |
| Pull to refresh | Re-fetch notifications |
| Swipe notification left | Show delete button → **Tap delete:** Remove notification |

**System Behavior:**
- Query notifications where userId matches
- Notification types:
  - Points earned
  - Points redeemed  
  - Reward unlocked
  - Program joined
  - Promotional messages
- Push notification integration
- Auto-mark as read when viewed

---

# PSEUDOCODE / ALGORITHM

## ALGORITHM 1: USER REGISTRATION

### Trigger
User submits registration form by tapping "Create Account" button

### Preconditions
- App has network connectivity
- Firebase is initialized
- User has not submitted form already (no duplicate request in progress)
- Form validation has passed:
  - firstName is not empty AND length > 1
  - lastName is not empty AND length > 1
  - email matches valid email regex pattern
  - password length >= 8 AND contains digit AND contains special char
  - confirmPassword exactly matches password
  - termsAccepted is true

### Postconditions (Success)
- User account created in Firebase Authentication
- User document created in Firestore `users` collection with structure:
  ```
  {
    uid: string,
    firstName: string,
    lastName: string,
    email: string,
    phone: string | null,
    createdAt: timestamp,
    updatedAt: timestamp
  }
  ```
- User is authenticated (currentUser is set)
- User navigated to Home Screen
- Success message displayed

### Postconditions (Failure)
- No user account created
- User remains on Registration Screen
- Error message displayed
- Form re-enabled for editing

---

### Normal Flow

```
FUNCTION handleRegistration()
  // Step 1: Pre-submission validation
  IF NOT termsAccepted THEN
    DISPLAY_SNACKBAR("Please accept the terms and conditions")
    RETURN
  END IF

  IF NOT validateForm() THEN
    DISPLAY_INLINE_ERRORS()
    RETURN
  END IF

  // Step 2: Start processing
  SET isLoading = TRUE
  DISABLE_FORM_INPUTS()
  DISABLE_SUBMIT_BUTTON()

  // Step 3: Prepare user data
  SET userData = {
    email: TRIM(emailInput.text),
    password: passwordInput.text,
    firstName: TRIM(firstNameInput.text),
    lastName: TRIM(lastNameInput.text),
    phone: TRIM(phoneInput.text) OR NULL
  }

  TRY
    // Step 4: Create Firebase Auth account
    authResult = AWAIT authService.createUserWithEmailAndPassword(
      email: userData.email,
      password: userData.password
    )
    
    SET userId = authResult.user.uid
    SET timestamp = CURRENT_TIMESTAMP()

    // Step 5: Create Firestore user document
    userDocument = {
      uid: userId,
      firstName: userData.firstName,
      lastName: userData.lastName,
      email: userData.email,
      phone: userData.phone,
      createdAt: timestamp,
      updatedAt: timestamp,
      role: "customer"
    }

    AWAIT firestoreService.collection("users").document(userId).SET(userDocument)

    // Step 6: Update Firebase Auth profile
    AWAIT authResult.user.updateDisplayName(
      userData.firstName + " " + userData.lastName
    )

    // Step 7: Success handling
    SET isLoading = FALSE
    DISPLAY_SNACKBAR("Account created successfully", color: GREEN)
    
    WAIT 500ms  // Brief delay for user to see success message
    
    NAVIGATE_TO_HOME_SCREEN(replace: TRUE)

  CATCH error
    // Error handling delegated to alternative/exception flows
    HANDLE_REGISTRATION_ERROR(error)
  END TRY
END FUNCTION
```

---

### Alternative Flow 1: Email Already Exists

```
FUNCTION handleEmailExistsError(error)
  SET isLoading = FALSE
  ENABLE_FORM_INPUTS()
  ENABLE_SUBMIT_BUTTON()
  
  DISPLAY_SNACKBAR(
    message: "This email is already registered. Try logging in instead.",
    color: RED,
    duration: 5000ms,
    action: {
      label: "Go to Login",
      onTap: NAVIGATE_TO_LOGIN_SCREEN
    }
  )
  
  HIGHLIGHT_EMAIL_FIELD(color: RED)
  SET_FOCUS_TO(emailField)
END FUNCTION
```

---

### Alternative Flow 2: Weak Password Rejected

```
FUNCTION handleWeakPasswordError(error)
  SET isLoading = FALSE
  ENABLE_FORM_INPUTS()
  ENABLE_SUBMIT_BUTTON()
  
  DISPLAY_INLINE_ERROR(
    field: passwordField,
    message: "Password must be at least 8 characters with 1 number and 1 special character"
  )
  
  DISPLAY_PASSWORD_REQUIREMENTS_POPUP()
  SET_FOCUS_TO(passwordField)
  CLEAR_FIELD(passwordField)
  CLEAR_FIELD(confirmPasswordField)
END FUNCTION
```

---

### Exception Flow 1: Network Failure

```
FUNCTION handleNetworkError(error)
  SET isLoading = FALSE
  ENABLE_FORM_INPUTS()
  ENABLE_SUBMIT_BUTTON()
  
  // Check if device truly offline or server unreachable
  isOnline = CHECK_NETWORK_CONNECTIVITY()
  
  IF NOT isOnline THEN
    errorMessage = "No internet connection. Check your network and try again."
  ELSE
    errorMessage = "Server unreachable. Please try again in a moment."
  END IF
  
  DISPLAY_SNACKBAR(
    message: errorMessage,
    color: RED,
    duration: 7000ms,
    action: {
      label: "Retry",
      onTap: RETRY_REGISTRATION
    }
  )
  
  // Optionally save form data locally for recovery
  SAVE_FORM_DATA_TO_LOCAL_STORAGE(userData)
END FUNCTION
```

---

### Exception Flow 2: Firestore Write Failure (Partial Registration)

```
FUNCTION handleFirestoreWriteFailure(error, authResult)
  // Critical: Auth account created but Firestore write failed
  // This creates an inconsistent state that must be resolved
  
  SET isLoading = FALSE
  
  LOG_ERROR("Partial registration: Auth succeeded, Firestore failed", {
    userId: authResult.user.uid,
    email: authResult.user.email,
    error: error.message
  })
  
  // Attempt to delete the Auth account to maintain consistency
  TRY
    AWAIT authResult.user.DELETE()
    errorMessage = "Registration failed. Please try again."
  CATCH deleteError
    // Account deletion failed - user account exists without profile data
    errorMessage = "Registration incomplete. Please contact support."
    
    // Send alert to admin/monitoring system
    SEND_ADMIN_ALERT({
      type: "PARTIAL_REGISTRATION",
      userId: authResult.user.uid,
      email: authResult.user.email,
      timestamp: CURRENT_TIMESTAMP()
    })
  END TRY
  
  ENABLE_FORM_INPUTS()
  ENABLE_SUBMIT_BUTTON()
  
  DISPLAY_SNACKBAR(errorMessage, color: RED, duration: 10000ms)
END FUNCTION
```

---

### System Integrations

```
// Firebase Authentication Integration
INTEGRATION FirebaseAuth
  METHOD createUserWithEmailAndPassword(email, password)
    RETURNS UserCredential OR THROWS AuthException
  
  EXCEPTIONS:
    - email-already-in-use
    - invalid-email
    - operation-not-allowed
    - weak-password
    - network-request-failed
END INTEGRATION

// Firestore Database Integration
INTEGRATION Firestore
  METHOD collection(path).document(id).set(data)
    RETURNS Promise<void> OR THROWS FirestoreException
  
  EXCEPTIONS:
    - permission-denied
    - unavailable (network error)
    - deadline-exceeded (timeout)
    - resource-exhausted (quota exceeded)
END INTEGRATION
```

---

## ALGORITHM 2: QR CODE PROGRAM ENROLLMENT

### Trigger
Camera detects and captures QR code on Scan Screen

### Preconditions
- User is authenticated
- Camera permission granted
- Camera initialized and scanning
- Network connectivity available
- QR code is in valid format: `programId|businessId`

### Postconditions (Success)
- User enrolled in loyalty program
- New document created in `user_programs` collection:
  ```
  {
    userId: string,
    programId: string,
    businessId: string,
    pointsBalance: 0,
    enrolledAt: timestamp,
    status: "active"
  }
  ```
- User navigated to Scan Success Screen
- Camera stopped and disposed

### Postconditions (Failure)
- No enrollment created
- Error message displayed
- Camera scanning resumed (for recoverable errors)
- User navigated back (for critical errors)

---

### Normal Flow

```
FUNCTION onQRCodeDetected(barcodeCapture)
  // Step 1: Prevent duplicate processing
  IF isProcessing THEN
    RETURN  // Ignore additional scans while processing
  END IF

  // Step 2: Extract barcode data
  barcodes = barcodeCapture.barcodes
  IF barcodes.isEmpty THEN
    RETURN
  END IF

  rawCode = barcodes[0].rawValue
  IF rawCode IS NULL OR rawCode.trim().isEmpty THEN
    RETURN
  END IF

  // Step 3: Start processing
  SET isProcessing = TRUE
  STOP_CAMERA_SCANNING()  // Prevent further detections
  SHOW_PROCESSING_INDICATOR()

  TRY
    // Step 4: Validate and parse QR code
    enrollmentResult = AWAIT processEnrollment(rawCode.trim())

    // Step 5: Navigate to success screen
    AWAIT NAVIGATE_TO_SCAN_SUCCESS_SCREEN(
      arguments: {
        title: "Program Joined!",
        message: enrollmentResult.successMessage,
        programData: enrollmentResult.programData
      }
    )

  CATCH error
    // Step 6: Handle errors
    HANDLE_ENROLLMENT_ERROR(error)
    
    // Resume scanning after brief delay (allow user to read error)
    AWAIT DELAY(2000ms)
    SET isProcessing = FALSE
    RESUME_CAMERA_SCANNING()
    
  END TRY
END FUNCTION

---

FUNCTION processEnrollment(rawCode)
  // Step 1: Get current user
  currentUser = authService.getCurrentUser()
  IF currentUser IS NULL THEN
    THROW AuthException("User not authenticated")
  END IF
  
  userId = currentUser.uid

  // Step 2: Parse QR code format (programId|businessId)
  parts = rawCode.SPLIT("|")
  IF parts.length != 2 THEN
    THROW FormatException("Invalid QR code format")
  END IF

  programId = parts[0].trim()
  businessId = parts[1].trim()

  IF programId.isEmpty OR businessId.isEmpty THEN
    THROW FormatException("QR code contains empty values")
  END IF

  // Step 3: Validate program exists
  programDoc = AWAIT firestore.collection("loyalty_programs")
    .document(programId)
    .GET()
  
  IF NOT programDoc.EXISTS THEN
    THROW NotFoundException("Loyalty program not found")
  END IF

  programData = programDoc.DATA()

  // Step 4: Validate business exists
  businessDoc = AWAIT firestore.collection("businesses")
    .document(businessId)
    .GET()
  
  IF NOT businessDoc.EXISTS THEN
    THROW NotFoundException("Business not found")
  END IF

  businessData = businessDoc.DATA()

  // Step 5: Check if already enrolled
  existingEnrollment = AWAIT firestore.collection("user_programs")
    .WHERE("userId", "==", userId)
    .WHERE("programId", "==", programId)
    .GET()

  IF NOT existingEnrollment.isEmpty THEN
    THROW AlreadyEnrolledException("Already enrolled in this program")
  END IF

  // Step 6: Create enrollment
  timestamp = CURRENT_TIMESTAMP()
  enrollmentData = {
    userId: userId,
    programId: programId,
    businessId: businessId,
    pointsBalance: 0,
    enrolledAt: timestamp,
    updatedAt: timestamp,
    status: "active"
  }

  AWAIT firestore.collection("user_programs")
    .DOCUMENT_AUTO_ID()
    .SET(enrollmentData)

  // Step 7: Log enrollment event
  AWAIT firestore.collection("events").ADD({
    type: "program_enrollment",
    userId: userId,
    programId: programId,
    businessId: businessId,
    timestamp: timestamp
  })

  // Step 8: Return success data
  RETURN {
    successMessage: "Successfully joined " + programData.name,
    programData: {
      name: programData.name,
      businessName: businessData.name,
      pointsBalance: 0
    }
  }
END FUNCTION
```

---

### Alternative Flow 1: Already Enrolled

```
FUNCTION handleAlreadyEnrolled(error, programId)
  STOP_PROCESSING_INDICATOR()
  
  // Fetch existing enrollment data
  enrollment = AWAIT firestore.collection("user_programs")
    .WHERE("userId", "==", currentUserId)
    .WHERE("programId", "==", programId)
    .GET_FIRST()

  currentBalance = enrollment.pointsBalance

  DISPLAY_SNACKBAR(
    message: "You're already enrolled! Current balance: " + currentBalance + " points",
    color: BLUE,
    duration: 4000ms,
    action: {
      label: "View Details",
      onTap: () => NAVIGATE_TO_PROGRAM_DETAIL(programId)
    }
  )
END FUNCTION
```

---

### Alternative Flow 2: Invalid QR Code Format

```
FUNCTION handleInvalidFormat(error, rawCode)
  STOP_PROCESSING_INDICATOR()
  
  LOG_WARNING("Invalid QR code scanned", {
    rawCode: rawCode,
    userId: currentUserId,
    timestamp: CURRENT_TIMESTAMP()
  })
  
  DISPLAY_SNACKBAR(
    message: "Invalid QR code. Please scan a Local Point TT loyalty program code.",
    color: ORANGE,
    duration: 3000ms
  )
  
  // Visual feedback on scanner frame
  FLASH_SCANNER_FRAME(color: RED, duration: 500ms)
END FUNCTION
```

---

### Exception Flow 1: Network Timeout During Enrollment

```
FUNCTION handleNetworkTimeout(error)
  STOP_PROCESSING_INDICATOR()
  
  DISPLAY_SNACKBAR(
    message: "Connection timeout. Enrollment may still be processing...",
    color: ORANGE,
    duration: 5000ms,
    action: {
      label: "Check Programs",
      onTap: () => NAVIGATE_TO_HOME_SCREEN()
    }
  )
  
  // Schedule background check to verify enrollment status
  SCHEDULE_BACKGROUND_TASK({
    taskId: "verify_enrollment",
    delay: 3000ms,
    action: VERIFY_LAST_ENROLLMENT_ATTEMPT
  })
  
  SET isProcessing = FALSE
  RESUME_CAMERA_SCANNING()
END FUNCTION
```

---

### Exception Flow 2: Permission Denied (Firestore Rules)

```
FUNCTION handlePermissionDenied(error)
  STOP_PROCESSING_INDICATOR()
  STOP_CAMERA()
  
  LOG_ERROR("Firestore permission denied during enrollment", {
    userId: currentUserId,
    error: error.message,
    timestamp: CURRENT_TIMESTAMP()
  })
  
  DISPLAY_ALERT_DIALOG(
    title: "Access Error",
    message: "Unable to enroll in program. Your account may need verification. Please contact support.",
    buttons: [
      {
        label: "Contact Support",
        action: () => OPEN_SUPPORT_EMAIL()
      },
      {
        label: "Return Home",
        action: () => NAVIGATE_TO_HOME_SCREEN()
      }
    ]
  )
END FUNCTION
```

---

### System Integrations

```
// Camera Scanner Integration
INTEGRATION MobileScanner
  METHOD startScanning()
    RETURNS void
    EMITS onBarcodeDetected(BarcodeCapture)
  
  METHOD stopScanning()
    RETURNS void
  
  METHOD dispose()
    RETURNS void
    SIDE_EFFECT: Releases camera resources
END INTEGRATION

// Firestore Query Integration
INTEGRATION FirestoreQuery
  METHOD collection(path).where(field, operator, value).get()
    RETURNS QuerySnapshot OR THROWS FirestoreException
  
  METHOD collection(path).document(id).get()
    RETURNS DocumentSnapshot OR THROWS FirestoreException
  
  METHOD collection(path).document(id).set(data)
    RETURNS Promise<void> OR THROWS FirestoreException
END INTEGRATION
```

---

## ALGORITHM 3: USER AUTHENTICATION (LOGIN)

### Trigger
User submits login form by tapping "Sign In" button

### Preconditions
- Network connectivity available
- Firebase initialized
- Form validation passed:
  - email is not empty AND matches email format
  - password is not empty

### Postconditions (Success)
- User authenticated with Firebase
- User session established
- Current user set in auth state
- User data loaded from Firestore
- User navigated to Home Screen

### Postconditions (Failure)
- User not authenticated
- User remains on Login Screen
- Error message displayed
- Form re-enabled

---

### Normal Flow

```
FUNCTION handleLogin()
  // Step 1: Validate form
  IF NOT validateForm() THEN
    DISPLAY_INLINE_ERRORS()
    RETURN
  END IF

  // Step 2: Start authentication
  SET isLoading = TRUE
  DISABLE_FORM_INPUTS()
  DISABLE_SIGN_IN_BUTTON()
  SHOW_LOADING_INDICATOR()

  // Step 3: Prepare credentials
  email = TRIM(emailInput.text)
  password = passwordInput.text

  TRY
    // Step 4: Authenticate with Firebase
    userCredential = AWAIT authService.signInWithEmailAndPassword(
      email: email,
      password: password
    )

    user = userCredential.user

    // Step 5: Verify user account is active
    userData = AWAIT firestore.collection("users")
      .document(user.uid)
      .GET()

    IF NOT userData.EXISTS THEN
      THROW DataException("User profile not found")
    END IF

    IF userData.status == "suspended" THEN
      THROW AuthException("Account suspended. Contact support.")
    END IF

    // Step 6: Update last login timestamp
    AWAIT firestore.collection("users")
      .document(user.uid)
      .UPDATE({
        lastLoginAt: CURRENT_TIMESTAMP()
      })

    // Step 7: Success handling
    SET isLoading = FALSE
    HIDE_LOADING_INDICATOR()

    // Brief success indicator
    SHOW_SUCCESS_CHECKMARK(duration: 300ms)
    AWAIT DELAY(300ms)

    // Step 8: Navigate to home
    NAVIGATE_TO_HOME_SCREEN(replace: TRUE)

  CATCH error
    HANDLE_LOGIN_ERROR(error)
  END TRY
END FUNCTION
```

---

### Alternative Flow 1: Invalid Credentials

```
FUNCTION handleInvalidCredentials(error)
  SET isLoading = FALSE
  ENABLE_FORM_INPUTS()
  ENABLE_SIGN_IN_BUTTON()
  HIDE_LOADING_INDICATOR()

  // Don't specify which field is wrong (security best practice)
  DISPLAY_SNACKBAR(
    message: "Invalid email or password. Please try again.",
    color: RED,
    duration: 4000ms
  )

  // Highlight both fields
  SET_FIELD_BORDER_COLOR(emailField, RED)
  SET_FIELD_BORDER_COLOR(passwordField, RED)

  // Clear password for security
  CLEAR_FIELD(passwordField)
  SET_FOCUS_TO(passwordField)

  // Track failed attempt (for security monitoring)
  AWAIT LOG_FAILED_LOGIN_ATTEMPT(email)
END FUNCTION
```

---

### Alternative Flow 2: Too Many Attempts (Rate Limiting)

```
FUNCTION handleTooManyAttempts(error)
  SET isLoading = FALSE
  ENABLE_FORM_INPUTS()
  ENABLE_SIGN_IN_BUTTON()

  // Firebase automatically implements rate limiting
  lockoutEndTime = error.retryAfter OR CALCULATE_LOCKOUT_END()

  DISPLAY_ALERT_DIALOG(
    title: "Too Many Attempts",
    message: "Your account has been temporarily locked for security. Try again in " + lockoutEndTime + " minutes.",
    buttons: [
      {
        label: "Forgot Password",
        action: () => NAVIGATE_TO_FORGOT_PASSWORD_SCREEN()
      },
      {
        label: "OK",
        action: () => CLOSE_DIALOG()
      }
    ]
  )

  // Disable sign in button temporarily
  DISABLE_SIGN_IN_BUTTON()
  START_COUNTDOWN_TIMER(lockoutEndTime)
END FUNCTION
```

---

### Alternative Flow 3: Account Not Found

```
FUNCTION handleUserNotFound(error)
  SET isLoading = FALSE
  ENABLE_FORM_INPUTS()
  ENABLE_SIGN_IN_BUTTON()

  DISPLAY_SNACKBAR(
    message: "No account found with this email. Would you like to sign up?",
    color: ORANGE,
    duration: 6000ms,
    action: {
      label: "Sign Up",
      onTap: () => NAVIGATE_TO_REGISTRATION_SCREEN(prefillEmail: email)
    }
  )

  HIGHLIGHT_EMAIL_FIELD(color: ORANGE)
END FUNCTION
```

---

### Exception Flow 1: Network Error During Login

```
FUNCTION handleNetworkError(error)
  SET isLoading = FALSE
  ENABLE_FORM_INPUTS()
  ENABLE_SIGN_IN_BUTTON()

  isOnline = CHECK_NETWORK_CONNECTIVITY()

  IF NOT isOnline THEN
    message = "No internet connection. Please check your network."
  ELSE
    message = "Unable to reach servers. Please try again."
  END IF

  DISPLAY_SNACKBAR(
    message: message,
    color: RED,
    duration: 5000ms,
    action: {
      label: "Retry",
      onTap: RETRY_LOGIN
    }
  )
END FUNCTION
```

---

### Exception Flow 2: Account Suspended

```
FUNCTION handleAccountSuspended(error, userData)
  SET isLoading = FALSE
  
  // Sign out to clear partial session
  AWAIT authService.signOut()

  suspensionReason = userData.suspensionReason OR "Terms of Service violation"
  supportEmail = "support@localpointtt.com"

  DISPLAY_ALERT_DIALOG(
    title: "Account Suspended",
    message: "Your account has been suspended due to: " + suspensionReason + 
             "\n\nFor more information, contact " + supportEmail,
    buttons: [
      {
        label: "Contact Support",
        action: () => OPEN_EMAIL_CLIENT(to: supportEmail, subject: "Account Suspension Inquiry")
      },
      {
        label: "Close",
        action: () => {
          CLOSE_DIALOG()
          ENABLE_FORM_INPUTS()
          CLEAR_ALL_FIELDS()
        }
      }
    ]
  )
END FUNCTION
```

---

### System Integrations

```
// Firebase Authentication Integration
INTEGRATION FirebaseAuth
  METHOD signInWithEmailAndPassword(email, password)
    RETURNS UserCredential OR THROWS AuthException
  
  METHOD getCurrentUser()
    RETURNS User OR NULL
  
  METHOD signOut()
    RETURNS Promise<void>
  
  EXCEPTIONS:
    - user-not-found
    - wrong-password
    - invalid-email
    - user-disabled
    - too-many-requests
    - network-request-failed
END INTEGRATION

// Firestore Integration
INTEGRATION Firestore
  METHOD collection(path).document(id).get()
    RETURNS DocumentSnapshot
  
  METHOD collection(path).document(id).update(data)
    RETURNS Promise<void>
  
  PROPERTIES:
    - EXISTS: boolean (document exists check)
    - DATA(): object (document data)
END INTEGRATION
```

---

## ALGORITHM 4: STAFF TRANSACTION PROCESSING

### Trigger
Staff completes transaction on Staff Scanner Screen by tapping "Complete Transaction"

### Preconditions
- Staff authenticated and authorized
- Customer QR code scanned and validated
- Customer enrolled in program for staff's business
- Points amount entered and validated
- Transaction type selected (award/redeem)
- If redeeming: customer balance >= points to redeem

### Postconditions (Success)
- Transaction record created in `transactions` collection
- Customer points balance updated in `user_programs`
- Transaction confirmation displayed
- Scanner reset for next transaction
- Audit log updated

### Postconditions (Failure)
- No transaction created
- No balance changes
- Error message displayed
- Transaction form remains populated for correction

---

### Normal Flow

```
FUNCTION handleStaffTransaction()
  // Step 1: Validation
  IF customerData IS NULL THEN
    DISPLAY_ERROR("No customer selected. Please scan QR code.")
    RETURN
  END IF

  IF pointsAmount <= 0 OR pointsAmount > MAX_POINTS_PER_TRANSACTION THEN
    DISPLAY_ERROR("Invalid points amount")
    RETURN
  END IF

  // Step 2: Check current balance for redemptions
  IF transactionType == "REDEEM" THEN
    IF customerProgram.pointsBalance < pointsAmount THEN
      DISPLAY_ERROR("Customer has insufficient points. Balance: " + 
                    customerProgram.pointsBalance)
      RETURN
    END IF
  END IF

  // Step 3: Start processing
  SET isProcessing = TRUE
  DISABLE_COMPLETE_BUTTON()
  SHOW_PROCESSING_INDICATOR()

  TRY
    // Step 4: Create transaction record
    timestamp = CURRENT_TIMESTAMP()
    transactionId = GENERATE_UNIQUE_ID()

    transactionData = {
      id: transactionId,
      userId: customerData.userId,
      programId: customerProgram.programId,
      businessId: staffData.businessId,
      staffId: staffData.staffId,
      type: transactionType,  // "AWARD" or "REDEEM"
      pointsAmount: pointsAmount,
      timestamp: timestamp,
      status: "completed",
      metadata: {
        staffName: staffData.fullName,
        businessName: staffData.businessName,
        deviceId: DEVICE_ID
      }
    }

    // Step 5: Calculate new balance
    IF transactionType == "AWARD" THEN
      newBalance = customerProgram.pointsBalance + pointsAmount
      balanceDelta = pointsAmount
    ELSE  // REDEEM
      newBalance = customerProgram.pointsBalance - pointsAmount
      balanceDelta = -pointsAmount
    END IF

    // Step 6: Execute as Firestore transaction (atomic operation)
    AWAIT firestore.RUN_TRANSACTION(transaction => {
      // Write transaction record
      transactionRef = firestore.collection("transactions").document(transactionId)
      transaction.SET(transactionRef, transactionData)

      // Update customer balance
      programRef = firestore.collection("user_programs").document(customerProgram.id)
      transaction.UPDATE(programRef, {
        pointsBalance: newBalance,
        updatedAt: timestamp,
        lastTransactionAt: timestamp
      })

      // Update staff transaction counter
      staffRef = firestore.collection("staff").document(staffData.staffId)
      transaction.UPDATE(staffRef, {
        todayTransactionCount: INCREMENT(1),
        totalTransactionsProcessed: INCREMENT(1),
        lastTransactionAt: timestamp
      })
    })

    // Step 7: Success handling
    SET isProcessing = FALSE
    HIDE_PROCESSING_INDICATOR()

    // Show success animation
    PLAY_SUCCESS_SOUND()
    SHOW_SUCCESS_ANIMATION()

    // Display transaction summary
    DISPLAY_TRANSACTION_RECEIPT({
      customerName: customerData.fullName,
      transactionType: transactionType,
      points: pointsAmount,
      newBalance: newBalance,
      transactionId: transactionId,
      timestamp: timestamp
    })

    // Step 8: Reset for next transaction
    AWAIT DELAY(2000ms)  // Allow time to read receipt
    RESET_TRANSACTION_FORM()
    CLEAR_CUSTOMER_DATA()
    RESUME_SCANNER()

  CATCH error
    HANDLE_TRANSACTION_ERROR(error)
  END TRY
END FUNCTION
```

---

### Alternative Flow 1: Insufficient Customer Balance (Redemption)

```
FUNCTION handleInsufficientBalance(customerBalance, requestedPoints)
  SET isProcessing = FALSE

  shortfall = requestedPoints - customerBalance

  DISPLAY_ALERT_DIALOG(
    title: "Insufficient Points",
    message: "Customer needs " + shortfall + " more points for this redemption.\n\n" +
             "Current balance: " + customerBalance + " points\n" +
             "Requested: " + requestedPoints + " points",
    buttons: [
      {
        label: "Award Points First",
        action: () => {
          SWITCH_TO_AWARD_MODE()
          CLOSE_DIALOG()
        }
      },
      {
        label: "Cancel",
        action: () => CLOSE_DIALOG()
      }
    ]
  )

  // Visual feedback
  FLASH_BALANCE_DISPLAY(color: RED)
END FUNCTION
```

---

### Alternative Flow 2: Daily Transaction Limit Reached

```
FUNCTION handleDailyLimitReached(staffData)
  SET isProcessing = FALSE

  dailyLimit = staffData.dailyTransactionLimit OR 500
  currentCount = staffData.todayTransactionCount

  DISPLAY_ALERT_DIALOG(
    title: "Daily Limit Reached",
    message: "You have reached your daily transaction limit (" + dailyLimit + " transactions).\n\n" +
             "Contact your manager to increase your limit or wait until tomorrow.",
    buttons: [
      {
        label: "Contact Manager",
        action: () => OPEN_MANAGER_CONTACT()
      },
      {
        label: "Close",
        action: () => {
          CLOSE_DIALOG()
          NAVIGATE_TO_STAFF_HOME()
        }
      }
    ]
  )

  // Log limit reached event
  LOG_EVENT({
    type: "daily_limit_reached",
    staffId: staffData.staffId,
    timestamp: CURRENT_TIMESTAMP()
  })
END FUNCTION
```

---

### Exception Flow 1: Transaction Write Failure (Race Condition)

```
FUNCTION handleTransactionConflict(error)
  SET isProcessing = FALSE
  ENABLE_COMPLETE_BUTTON()

  LOG_WARNING("Transaction conflict detected", {
    staffId: staffData.staffId,
    customerId: customerData.userId,
    attemptedPoints: pointsAmount,
    error: error.message
  })

  DISPLAY_ALERT_DIALOG(
    title: "Transaction Conflict",
    message: "Another transaction is being processed for this customer. Please wait a moment and try again.",
    buttons: [
      {
        label: "Retry",
        action: () => {
          CLOSE_DIALOG()
          AWAIT DELAY(1000ms)
          RETRY_TRANSACTION()
        }
      },
      {
        label: "Cancel",
        action: () => {
          CLOSE_DIALOG()
          RESET_TRANSACTION_FORM()
        }
      }
    ]
  )
END FUNCTION
```

---

### Exception Flow 2: Customer Program No Longer Active

```
FUNCTION handleInactivateProgram(error, customerProgram)
  SET isProcessing = FALSE

  LOG_ERROR("Attempted transaction on inactive program", {
    programId: customerProgram.programId,
    userId: customerProgram.userId,
    programStatus: customerProgram.status
  })

  DISPLAY_ALERT_DIALOG(
    title: "Program Inactive",
    message: "This customer's enrollment is no longer active. They may need to re-enroll in the program.",
    buttons: [
      {
        label: "Contact Support",
        action: () => OPEN_SUPPORT_CONTACT()
      },
      {
        label: "Cancel",
        action: () => {
          CLOSE_DIALOG()
          RESET_TRANSACTION_FORM()
          CLEAR_CUSTOMER_DATA()
        }
      }
    ]
  )
END FUNCTION
```

---

### System Integrations

```
// Firestore Atomic Transaction Integration
INTEGRATION FirestoreTransaction
  METHOD runTransaction(updateFunction)
    RETURNS Promise<TransactionResult>
    GUARANTEES: Atomicity (all writes succeed or all fail)
  
  METHODS_WITHIN_TRANSACTION:
    - transaction.get(documentRef): Read document
    - transaction.set(documentRef, data): Create document
    - transaction.update(documentRef, data): Update document
    - transaction.delete(documentRef): Delete document
  
  EXCEPTIONS:
    - aborted: Transaction failed due to conflict
    - deadline-exceeded: Transaction took too long
    - permission-denied: Insufficient permissions
END INTEGRATION

// Field Value Operations
INTEGRATION FieldValue
  METHOD increment(value)
    RETURNS FieldValue
    DESCRIPTION: Atomically increment numeric field
  
  METHOD serverTimestamp()
    RETURNS FieldValue
    DESCRIPTION: Set field to server timestamp
END INTEGRATION
```

---

## ALGORITHM 5: HOME SCREEN DATA LOADING

### Trigger
User navigates to Home Screen or pulls to refresh

### Preconditions
- User authenticated
- Network connectivity available (or cached data available)
- Firestore initialized

### Postconditions (Success)
- User programs loaded and displayed
- Business data fetched for each program
- Points balances calculated
- UI updated with current data
- Loading indicators hidden

### Postconditions (Failure - Network)
- Cached data displayed (if available)
- Offline indicator shown
- Retry option provided

---

### Normal Flow

```
FUNCTION loadHomeScreenData()
  // Step 1: Initialize loading state
  SET isLoading = TRUE
  SHOW_SKELETON_LOADING_UI()
  
  currentUserId = authService.getCurrentUser().uid
  
  IF currentUserId IS NULL THEN
    NAVIGATE_TO_LOGIN_SCREEN()
    RETURN
  END IF

  TRY
    // Step 2: Fetch user's enrolled programs
    userProgramsQuery = firestore.collection("user_programs")
      .WHERE("userId", "==", currentUserId)
      .WHERE("status", "==", "active")
      .ORDER_BY("enrolledAt", "DESC")
    
    userProgramsSnapshot = AWAIT userProgramsQuery.GET()

    IF userProgramsSnapshot.isEmpty THEN
      // Step 3a: No programs - show empty state
      SET isLoading = FALSE
      HIDE_SKELETON_LOADING_UI()
      SHOW_EMPTY_STATE({
        icon: QR_CODE_ICON,
        title: "No Programs Yet",
        message: "Scan a QR code to join your first loyalty program",
        action: {
          label: "Scan Now",
          onTap: () => NAVIGATE_TO_SCAN_SCREEN()
        }
      })
      RETURN
    END IF

    // Step 3b: Process each enrolled program
    programData = []
    
    FOR EACH programDoc IN userProgramsSnapshot.documents DO
      userProgram = programDoc.DATA()
      
      // Fetch program details in parallel
      programDetailsPromise = firestore.collection("loyalty_programs")
        .document(userProgram.programId)
        .GET()
      
      businessDetailsPromise = firestore.collection("businesses")
        .document(userProgram.businessId)
        .GET()
      
      // Wait for both fetches
      [programDetails, businessDetails] = AWAIT Promise.all([
        programDetailsPromise,
        businessDetailsPromise
      ])

      // Calculate points progress
      pointsBalance = userProgram.pointsBalance
      nextRewardThreshold = CALCULATE_NEXT_REWARD_THRESHOLD(
        programDetails.rewardTiers,
        pointsBalance
      )
      
      progressPercentage = (pointsBalance / nextRewardThreshold) * 100

      // Combine data
      programData.APPEND({
        id: programDoc.id,
        programName: programDetails.name,
        businessName: businessDetails.name,
        businessLogo: businessDetails.logoUrl,
        pointsBalance: pointsBalance,
        nextRewardAt: nextRewardThreshold,
        progressPercentage: progressPercentage,
        enrolledDate: userProgram.enrolledAt,
        programColor: programDetails.themeColor OR DEFAULT_COLOR
      })
    END FOR

    // Step 4: Update UI with loaded data
    SET isLoading = FALSE
    HIDE_SKELETON_LOADING_UI()
    DISPLAY_PROGRAM_CARDS(programData)

    // Step 5: Set up real-time listeners for updates
    SETUP_REALTIME_LISTENERS(currentUserId)

  CATCH error
    HANDLE_DATA_LOAD_ERROR(error)
  END TRY
END FUNCTION

---

FUNCTION setupRealtimeListeners(userId)
  // Listen for changes to user programs
  programsListener = firestore.collection("user_programs")
    .WHERE("userId", "==", userId)
    .LISTEN(snapshot => {
      FOR EACH change IN snapshot.documentChanges DO
        IF change.type == "modified" THEN
          // Update specific program card
          UPDATE_PROGRAM_CARD(change.document.id, change.document.DATA())
        ELSE IF change.type == "added" THEN
          // Add new program card
          ADD_PROGRAM_CARD(change.document.DATA())
        ELSE IF change.type == "removed" THEN
          // Remove program card
          REMOVE_PROGRAM_CARD(change.document.id)
        END IF
      END FOR
    })

  // Store listener for cleanup
  STORE_LISTENER(programsListener)
END FUNCTION

---

FUNCTION calculateNextRewardThreshold(rewardTiers, currentBalance)
  // Find the next reward tier above current balance
  sortedTiers = SORT(rewardTiers, BY: pointsRequired, ASCENDING)
  
  FOR EACH tier IN sortedTiers DO
    IF tier.pointsRequired > currentBalance THEN
      RETURN tier.pointsRequired
    END IF
  END FOR
  
  // If at max tier, return current tier
  RETURN sortedTiers[sortedTiers.length - 1].pointsRequired
END FUNCTION
```

---

### Alternative Flow: Pull to Refresh

```
FUNCTION onPullToRefresh()
  SET isRefreshing = TRUE
  SHOW_REFRESH_INDICATOR()
  
  TRY
    // Re-fetch all data
    AWAIT loadHomeScreenData()
    
    SET isRefreshing = FALSE
    HIDE_REFRESH_INDICATOR()
    
    // Brief success feedback
    SHOW_TOAST("Updated", duration: 1000ms)
    
  CATCH error
    SET isRefreshing = FALSE
    HIDE_REFRESH_INDICATOR()
    
    SHOW_TOAST("Update failed. Using cached data.", duration: 2000ms)
  END TRY
END FUNCTION
```

---

### Exception Flow: Network Error with Cache

```
FUNCTION handleDataLoadErrorWithCache(error)
  SET isLoading = FALSE
  HIDE_SKELETON_LOADING_UI()

  // Try to load cached data
  cachedData = GET_CACHED_PROGRAM_DATA()
  
  IF cachedData IS NOT NULL AND NOT cachedData.isEmpty THEN
    // Display cached data
    DISPLAY_PROGRAM_CARDS(cachedData)
    
    // Show offline indicator
    SHOW_OFFLINE_BANNER({
      message: "Showing saved data. Connect to internet for latest updates.",
      action: {
        label: "Retry",
        onTap: () => {
          HIDE_OFFLINE_BANNER()
          loadHomeScreenData()
        }
      }
    })
  ELSE
    // No cached data available
    SHOW_ERROR_STATE({
      icon: OFFLINE_ICON,
      title: "Connection Error",
      message: "Unable to load your programs. Check your internet connection and try again.",
      action: {
        label: "Retry",
        onTap: () => loadHomeScreenData()
      }
    })
  END IF
END FUNCTION
```

---

### Exception Flow: Malformed Data

```
FUNCTION handleMalformedData(error, documentId)
  LOG_ERROR("Malformed program data", {
    documentId: documentId,
    userId: currentUserId,
    error: error.message
  })

  // Skip this program but continue loading others
  SHOW_TOAST("Some program data couldn't be loaded", duration: 2000ms)
  
  // Continue with remaining programs
  CONTINUE_TO_NEXT_PROGRAM()
END FUNCTION
```

---

### System Integrations

```
// Firestore Real-time Listeners
INTEGRATION FirestoreListeners
  METHOD collection(path).where(...).listen(callback)
    RETURNS StreamSubscription
    EMITS snapshot on data changes
  
  CALLBACK_STRUCTURE:
    snapshot.documentChanges: Array<DocumentChange>
    - type: "added" | "modified" | "removed"
    - document: DocumentSnapshot
  
  CLEANUP:
    listener.cancel(): Stop listening and free resources
END INTEGRATION

// Local Cache Integration
INTEGRATION LocalCache
  METHOD getCachedData(key)
    RETURNS CachedData OR NULL
  
  METHOD setCachedData(key, data, expiry)
    RETURNS void
  
  METHOD clearCache()
    RETURNS void
  
  CACHE_STRATEGY: Cache-first with background refresh
END INTEGRATION
```

---

## SUMMARY OF SYSTEM-WIDE PATTERNS

### Error Display Hierarchy
1. **Field-level errors**: Inline below input fields (validation errors)
2. **Snackbar errors**: Bottom of screen, dismissible (operation failures)
3. **Alert dialogs**: Center screen, modal (critical errors, confirmations)
4. **Banner errors**: Top/bottom persistent (connectivity, warnings)

### Loading States
1. **Skeleton screens**: Initial page load
2. **Spinners**: Button/form submission
3. **Progress indicators**: Pull-to-refresh
4. **Shimmer effects**: List item loading

### Navigation Patterns
1. **Push**: Stack-based, allows back navigation
2. **Replace**: Remove current screen from stack
3. **PopUntil**: Navigate back multiple screens
4. **Named routes**: Centralized route management

### Data Persistence Strategy
1. **Firestore**: Source of truth for all user data
2. **Local Storage**: Onboarding flags, preferences
3. **Cache**: Temporary offline data access
4. **Real-time listeners**: Automatic UI updates

### Security Measures
1. **Authentication required**: All protected routes
2. **Permission checks**: Firestore security rules
3. **Input validation**: Client and server-side
4. **Rate limiting**: Firebase Auth built-in
5. **Audit logs**: All transactions tracked

---

*This document provides comprehensive display-action-response models and algorithmic patterns for all major user flows in the Local Point TT application.*
