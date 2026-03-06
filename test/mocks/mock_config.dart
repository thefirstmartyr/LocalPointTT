// Mock configuration for code generation using mockito
// Generate mocks by running: flutter pub run build_runner build

import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_point_tt/data/services/auth_service.dart';

// Generate mocks for these classes
@GenerateMocks([
  // Firebase Auth
  FirebaseAuth,
  UserCredential,
  User,
  
  // Firestore
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  
  // App Services
  AuthService,
])
void main() {}
