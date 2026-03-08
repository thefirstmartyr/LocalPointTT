import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return await getUserData(result.user!.uid);
      }
      return null;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw Exception('Failed to create user');
      }

      // Create user document in Firestore
      final userModel = UserModel(
        id: result.user!.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(result.user!.uid).set(userModel.toMap());

      // Update display name in Firebase Auth
      await result.user!.updateDisplayName('$firstName $lastName');

      return userModel;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Update user data
  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user == null) {
        throw Exception('Failed to sign in with Google');
      }

      // Check if user document exists in Firestore
      final userDoc = await _firestore.collection('users').doc(result.user!.uid).get();

      if (!userDoc.exists) {
        // Create new user document for first-time Google sign-in
        final names = (result.user!.displayName ?? '').split(' ');
        final userModel = UserModel(
          id: result.user!.uid,
          firstName: names.isNotEmpty ? names.first : 'User',
          lastName: names.length > 1 ? names.sublist(1).join(' ') : '',
          email: result.user!.email ?? '',
          phone: result.user!.phoneNumber,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(result.user!.uid).set(userModel.toMap());
        return userModel;
      }

      // Return existing user data
      return await getUserData(result.user!.uid);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'weak-password':
          return 'Password is too weak. Use at least 8 characters.';
        case 'operation-not-allowed':
          return 'This sign-in method is not enabled.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Check your connection.';
        default:
          return 'Authentication error: ${e.message ?? 'Unknown error'}';
      }
    }
    return 'An unexpected error occurred: $e';
  }
}
