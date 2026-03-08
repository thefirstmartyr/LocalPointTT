import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_routes.dart';

/// Enum for user roles
enum UserRole {
  customer,
  staff,
  unknown,
}

/// Route guard utilities for authentication and authorization
class RouteGuards {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check if user is authenticated
  static bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  /// Get current user role from Firestore
  /// Returns UserRole.unknown if role cannot be determined
  static Future<UserRole> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return UserRole.unknown;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return UserRole.unknown;

      final role = userDoc.data()?['role'] as String?;
      
      switch (role) {
        case 'staff':
          return UserRole.staff;
        case 'customer':
        default:
          return UserRole.customer;
      }
    } catch (e) {
      return UserRole.customer; // Default to customer on error
    }
  }

  /// Navigate to appropriate screen based on auth state
  static Future<String> getInitialRoute() async {
    if (!isAuthenticated()) {
      return AppRoutes.login;
    }

    final role = await getUserRole();
    
    switch (role) {
      case UserRole.staff:
        return AppRoutes.staffScanner;
      case UserRole.customer:
        return AppRoutes.home;
      case UserRole.unknown:
        return AppRoutes.login;
    }
  }

  /// Auth guard middleware - redirects to login if not authenticated
  static Widget authGuard({
    required Widget child,
    required BuildContext context,
  }) {
    if (!isAuthenticated()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      });
      return const SizedBox.shrink();
    }
    return child;
  }

  /// Role guard - ensures user has required role
  static Future<Widget> roleGuard({
    required Widget child,
    required UserRole requiredRole,
    required BuildContext context,
  }) async {
    if (!isAuthenticated()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      });
      return const SizedBox.shrink();
    }

    final userRole = await getUserRole();
    
    if (userRole != requiredRole) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          userRole == UserRole.staff ? AppRoutes.staffScanner : AppRoutes.home,
          (route) => false,
        );
      });
      return const SizedBox.shrink();
    }

    return child;
  }

  /// Guest guard - redirect authenticated users away from auth screens
  static void guestGuard(BuildContext context) {
    if (isAuthenticated()) {
      getUserRole().then((role) {
        final route = role == UserRole.staff 
            ? AppRoutes.staffScanner 
            : AppRoutes.home;
        
        Navigator.of(context).pushNamedAndRemoveUntil(
          route,
          (route) => false,
        );
      });
    }
  }
}
