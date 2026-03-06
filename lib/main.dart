import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:provider/provider.dart';
import 'app.dart';
import 'data/services/firebase_service.dart';
import 'data/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 App starting...');
  
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase initialized');
  
  // Initialize Local Storage
  await LocalStorageService.init();
  print('✅ LocalStorageService initialized');
  
  // Initialize Firebase Services
  await FirebaseService.initialize();
  print('✅ FirebaseService initialized');
  
  print('✅ Running MyApp...');
  runApp(const MyApp());
  
  // TODO: When you have providers, wrap MyApp with MultiProvider:
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (_) => AuthProvider()),
  //       ChangeNotifierProvider(create: (_) => UserProvider()),
  //     ],
  //     child: const MyApp(),
  //   ),
  // );
}
