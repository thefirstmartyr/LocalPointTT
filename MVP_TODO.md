# Local Point TT - MVP TODO

Last updated: 2026-03-06

## 1. Missing Screens (Must Build)
- [x] Staff Login Screen (`lib/presentation/screens/staff/staff_login_screen.dart`)
- [x] Staff Scanner Screen (`lib/presentation/screens/staff/staff_scanner_screen.dart`)
- [x] Scan Success Screen (standalone screen, not dialog)
- [x] Manual Customer Lookup Screen

## 2. Existing Screens That Need Completion

### Login Screen
- [x] Implement Google Sign-In action
- [x] Implement Forgot Password flow

### Registration Screen
- [x] Implement Google Sign-Up action (currently TODO)
- [x] Wire terms link to actual Terms/Privacy content
- [ ] Add stronger validation rules (phone format, password strength)

### Home Screen (Dashboard)
- [x] Remove or gate `Developer Tools` in production builds
- [ ] Ensure all dashboard numbers are from Firestore, not placeholders

### Program Detail Screen
- [x] Replace hardcoded rewards/program details with Firestore data
- [x] Implement `Share` button behavior
- [x] Implement `Redeem Now` flow (backend write + confirmation)

### Scan Screen (Join New Program)
- [x] Validate scanned code against backend
- [x] Persist join-program action to Firestore
- [x] Add scanner permission error/denied states
- [x] Replace success dialog with navigation to Scan Success Screen

### Statistics Screen
- [ ] Move from static values to live user/business data
- [ ] Implement real 6-month trend chart using `fl_chart`
- [ ] Calculate and display true top-program ranking

### Transaction History Screen
- [x] Make filter chips interactive (`All`, `Earned`, `Redeemed`)
- [x] Load transactions from repository/Firestore
- [x] Add empty, loading, and error states

### Notifications Screen
- [ ] Load notifications from backend (or local persisted source)
- [x] Implement `Mark all read`
- [x] Mark notification as read on tap
- [x] Route tap action to related screen

### Profile / Settings
- [x] Connect Edit Profile save to real backend update
- [x] Build Change Password screen and wire both entry points
- [x] Implement Privacy Policy and Terms pages
- [x] Persist notification/privacy/preferences toggles

## 3. App Navigation and Structure
- [x] Add centralized named routing (`routes/app_router.dart`) instead of scattered `MaterialPageRoute`
- [x] Add route guards for auth vs unauthenticated flows
- [x] Add role-based route entry for customer vs staff users

## 4. MVP Quality and Release Readiness
- [ ] Add widget/integration tests for critical flows:
- [ ] Splash -> Onboarding -> Login
- [ ] Register -> Home
- [ ] Scan join flow
- [ ] Staff scan flow
- [ ] Fix remaining TODO comments in production paths
- [ ] Verify Android/iOS camera permissions and UX
- [ ] Run final regression checklist for all MVP screens

## 5. MVP Exit Criteria
- [ ] All 15 MVP screens exist and are reachable through navigation
- [ ] No mock-only success paths for primary user actions
- [ ] Core flows are backed by Firebase data writes/reads
- [ ] Basic tests pass for auth, scan, and transaction flows
- [ ] No blocking TODOs in customer/staff core journeys
