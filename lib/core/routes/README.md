# Routing System Documentation

This directory contains the centralized routing system for the Local Point TT app.

## Files

### `app_routes.dart`
Central location for all route name constants. Use these constants instead of hardcoding route strings.

Example:
```dart
Navigator.of(context).pushNamed(AppRoutes.home);
```

### `app_router.dart`
Main routing configuration that maps route names to screens. Handles:
- Route generation from `RouteSettings`
- Route arguments extraction and validation
- Error routes for undefined routes

Example usage in `app.dart`:
```dart
MaterialApp(
  initialRoute: AppRouter.getInitialRoute(),
  onGenerateRoute: AppRouter.generateRoute,
)
```

### `route_guards.dart`
Authentication and authorization guards for protecting routes.

**Features:**
- **isAuthenticated()**: Check if user is logged in
- **getUserRole()**: Get user role (customer/staff) from Firestore
- **getInitialRoute()**: Determine initial route based on auth + role
- **authGuard()**: Redirect unauthenticated users to login
- **roleGuard()**: Restrict access based on user role
- **guestGuard()**: Redirect authenticated users away from auth screens

## Navigation Patterns

### Basic Navigation
```dart
// Push named route
Navigator.of(context).pushNamed(AppRoutes.programDetail);

// Push with arguments
Navigator.of(context).pushNamed(
  AppRoutes.programDetail,
  arguments: {
    'programId': 'abc123',
    'businessId': 'xyz789',
  },
);
```

### Replace Navigation
```dart
// Replace current route
Navigator.of(context).pushReplacementNamed(AppRoutes.home);

// Replace all routes
Navigator.of(context).pushNamedAndRemoveUntil(
  AppRoutes.login,
  (route) => false,
);
```

### Route Arguments

Route arguments are passed as a `Map<String, dynamic>` or specific types:

**Example 1: Map arguments**
```dart
Navigator.of(context).pushNamed(
  AppRoutes.legalInfo,
  arguments: {
    'title': 'Privacy Policy',
    'content': 'Privacy content here...',
  },
);
```

**Example 2: String arguments**
```dart
Navigator.of(context).pushNamed(
  AppRoutes.scanSuccess,
  arguments: 'Successfully joined program!',
);
```

## Adding New Routes

1. **Add route constant** in `app_routes.dart`:
```dart
static const String myNewScreen = '/my-new-screen';
```

2. **Add route case** in `app_router.dart`:
```dart
case AppRoutes.myNewScreen:
  return _buildRoute(const MyNewScreen(), settings);
```

3. **Import the screen** at the top of `app_router.dart`:
```dart
import '../../presentation/screens/path/my_new_screen.dart';
```

## Role-Based Access

The routing system supports role-based access control:

- **Customer routes**: Home, scan, programs, profile
- **Staff routes**: Staff login, staff scanner, manual lookup
- **Public routes**: Login, registration, onboarding, splash

The splash screen automatically routes users based on:
1. Onboarding completion status
2. Authentication state
3. User role (customer vs staff)

## Route Flow

```
App Start
  ↓
Splash Screen
  ↓
Onboarding Complete? 
  ├─ No → Onboarding → Login
  └─ Yes → Authenticated?
             ├─ No → Login
             └─ Yes → Get Role
                       ├─ Customer → Home
                       └─ Staff → Staff Scanner
```

## Benefits

1. **Type Safety**: Route names are constants, preventing typos
2. **Centralized**: All routing logic in one place
3. **Testable**: Easy to test route generation
4. **Maintainable**: Changes to routing affect minimal code
5. **Secure**: Auth and role guards prevent unauthorized access
6. **Flexible**: Easy to add new routes or modify existing ones
