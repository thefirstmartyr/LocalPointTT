# Firebase Integration Guide

> 📚 **Related Documentation**
> - **Testing**: [test/README.md](test/README.md) - Complete testing guide with 57+ test cases
> - **Setup**: [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Initial Firebase project setup
> - **Summary**: [FIREBASE_INTEGRATION_SUMMARY.md](FIREBASE_INTEGRATION_SUMMARY.md) - What's implemented

## Overview
Your app is now configured to use Firebase! This guide shows you how to use the repositories and integrate Firebase authentication.

## ⚠️ IMPORTANT: Before Running the App

**YOU MUST ADD `google-services.json` FIRST!**

1. Follow the instructions in `FIREBASE_SETUP.md`
2. Place `google-services.json` in: `android/app/google-services.json`
3. Without this file, the app will crash on startup

---

## 📦 What Has Been Added

### Models (lib/data/models/)
- ✅ `user_model.dart` - User data
- ✅ `business_model.dart` - Business information
- ✅ `loyalty_program_model.dart` - Loyalty program details
- ✅ `user_program_model.dart` - User enrollment in programs
- ✅ `transaction_model.dart` - Points transactions (earn/redeem)
- ✅ `reward_model.dart` - Rewards catalog

### Repositories (lib/data/repositories/)
- ✅ `auth_repository.dart` - Authentication operations
- ✅ `user_repository.dart` - User CRUD operations
- ✅ `business_repository.dart` - Business CRUD operations
- ✅ `loyalty_repository.dart` - Program, enrollment, and rewards
- ✅ `transaction_repository.dart` - Transaction history

### Services
- ✅ `firebase_service.dart` - Firebase initialization (enabled)

---

## 🔐 Authentication Usage

### Example: Update LoginScreen to use Firebase

```dart
// lib/presentation/screens/auth/login_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/services/local_storage_service.dart';

class _LoginScreenState extends State<LoginScreen> {
  final _authRepository = AuthRepository();
  final _userRepository = UserRepository();
  
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Sign in with Firebase
      final credential = await _authRepository.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Get user data from Firestore
      final user = await _userRepository.getUserById(credential.user!.uid);
      
      if (user != null) {
        // Save user ID locally
        await LocalStorageService.saveUserId(user.id);
        
        // Navigate to home
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
```

---

## 📝 Registration with Firebase

```dart
// In registration_screen.dart

Future<void> _handleRegistration() async {
  try {
    // 1. Create Firebase Auth account
    final credential = await _authRepository.registerWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    
    // 2. Create user document in Firestore
    final user = UserModel(
      id: credential.user!.uid,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      profileImageUrl: null,
      createdAt: DateTime.now(),
    );
    
    await _userRepository.createUser(user);
    
    // 3. Save locally and navigate
    await LocalStorageService.saveUserId(user.id);
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}
```

---

## 🏢 Fetching Businesses

```dart
// Example: Get all businesses
final businessRepo = BusinessRepository();
final businesses = await businessRepo.getAllBusinesses();

// Example: Search businesses
final results = await businessRepo.searchBusinesses('coffee');

// Example: Stream businesses (real-time updates)
businessRepo.streamBusinesses().listen((businesses) {
  setState(() {
    _businesses = businesses;
  });
});
```

---

## 🎯 Loyalty Programs

```dart
final loyaltyRepo = LoyaltyRepository();

// Get user's enrolled programs
final userPrograms = await loyaltyRepo.getUserPrograms(userId);

// Get specific user program
final userProgram = await loyaltyRepo.getUserProgram(userId, programId);

// Award points to user
await loyaltyRepo.updateUserProgramPoints(userProgramId, 10);

// Stream user programs (real-time)
loyaltyRepo.streamUserPrograms(userId).listen((programs) {
  setState(() {
    _programs = programs;
  });
});

// Get rewards for a program
final rewards = await loyaltyRepo.getRewardsByProgram(programId);
```

---

## 💰 Transaction History

```dart
final transactionRepo = TransactionRepository();

// Create a transaction (earn points)
final transaction = TransactionModel(
  id: '', // Will be generated by Firestore
  userId: currentUserId,
  businessId: businessId,
  programId: programId,
  type: TransactionType.earn,
  points: 10,
  description: 'Purchase at Joe\'s Coffee Shop',
  timestamp: DateTime.now(),
);

final transactionId = await transactionRepo.createTransaction(transaction);

// Get user's transaction history
final transactions = await transactionRepo.getUserTransactions(userId);

// Get user's total points earned
final totalPoints = await transactionRepo.getUserTotalPointsEarned(userId);

// Stream transactions (real-time)
transactionRepo.streamUserTransactions(userId).listen((transactions) {
  setState(() {
    _transactions = transactions;
  });
});
```

---

## 🔄 Real-Time Updates

All repositories support streaming data for real-time updates:

```dart
// Stream user data
_userRepository.streamUser(userId).listen((user) {
  if (user != null) {
    setState(() {
      _currentUser = user;
    });
  }
});

// Stream businesses
_businessRepository.streamBusinesses().listen((businesses) {
  setState(() {
    _businesses = businesses;
  });
});

// Stream user programs
_loyaltyRepository.streamUserPrograms(userId).listen((programs) {
  setState(() {
    _userPrograms = programs;
  });
});

// Stream transactions
_transactionRepository.streamUserTransactions(userId).listen((transactions) {
  setState(() {
    _transactions = transactions;
  });
});
```

---

## 🚪 Sign Out

```dart
// In profile screen or anywhere
await _authRepository.signOut();
await LocalStorageService.clearSession();

Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (_) => const LoginScreen()),
  (route) => false,
);
```

---

## 🔐 Password Reset

```dart
await _authRepository.sendPasswordResetEmail(email);

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Password reset email sent!')),
);
```

---

## ✅ Check Authentication State

```dart
// Listen to auth state changes
_authRepository.authStateChanges.listen((user) {
  if (user == null) {
    // User is signed out
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
});

// Check current user
final currentUser = _authRepository.currentUser;
if (currentUser != null) {
  print('User is signed in: ${currentUser.uid}');
}
```

---

## 📱 Update HomeScreen to Load Real Data

```dart
// lib/presentation/screens/home/home_screen.dart

class _HomeScreenState extends State<HomeScreen> {
  final _loyaltyRepo = LoyaltyRepository();
  final _userRepo = UserRepository();
  String? _userId;
  UserModel? _currentUser;
  List<UserProgramModel> _userPrograms = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    try {
      // Get current user ID
      _userId = await LocalStorageService.getUserId();
      if (_userId == null) return;
      
      // Load user data
      _currentUser = await _userRepo.getUserById(_userId!);
      
      // Load user's programs
      _userPrograms = await _loyaltyRepo.getUserPrograms(_userId!);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Use _userPrograms to display real data instead of mock data
}
```

---

## 🎨 Display Business with Program

```dart
// Combine business and program data
class ProgramWithBusiness {
  final UserProgramModel userProgram;
  final LoyaltyProgramModel loyaltyProgram;
  final BusinessModel business;
  
  ProgramWithBusiness({
    required this.userProgram,
    required this.loyaltyProgram,
    required this.business,
  });
}

// Load combined data
Future<List<ProgramWithBusiness>> _loadProgramsWithDetails() async {
  final userPrograms = await _loyaltyRepo.getUserPrograms(userId);
  final List<ProgramWithBusiness> result = [];
  
  for (final userProg in userPrograms) {
    final program = await _loyaltyRepo.getProgramById(userProg.programId);
    final business = await _businessRepo.getBusinessById(userProg.businessId);
    
    if (program != null && business != null) {
      result.add(ProgramWithBusiness(
        userProgram: userProg,
        loyaltyProgram: program,
        business: business,
      ));
    }
  }
  
  return result;
}
```

---

## 🧪 Testing Firebase (After Setup)

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Test Registration:**
   - Create a new account
   - Check Firebase Console → Authentication → Users
   - Check Firestore → users collection

3. **Test Login:**
   - Sign in with created account
   - Verify navigation to home screen

4. **Test Data Loading:**
   - Add test businesses in Firestore (follow FIREBASE_SETUP.md)
   - Verify they appear in the app

---

## 📊 Firestore Structure Summary

```
users/
  {userId}/
    - email
    - firstName
    - lastName
    - phone
    - profileImageUrl
    - createdAt

businesses/
  {businessId}/
    - name
    - description
    - category
    - address
    - phone
    - logo
    - ownerId
    - isActive
    - createdAt

loyalty_programs/
  {programId}/
    - businessId
    - name
    - description
    - pointsPerVisit
    - pointsPerDollar
    - isActive
    - createdAt

user_programs/
  {userProgramId}/
    - userId
    - programId
    - businessId
    - currentPoints
    - totalPointsEarned
    - enrolledAt
    - lastActivity

transactions/
  {transactionId}/
    - userId
    - businessId
    - programId
    - type (earn/redeem)
    - points
    - description
    - timestamp

rewards/
  {rewardId}/
    - programId
    - name
    - description
    - pointsRequired
    - isActive
    - createdAt
```

---

## 🔥 Next Steps

1. ✅ Complete Firebase setup (FIREBASE_SETUP.md)
2. ✅ Add `google-services.json` 
3. Run `flutter clean && flutter pub get`
4. Update `login_screen.dart` with real Firebase auth
5. Update `registration_screen.dart` with real Firebase auth
6. Update `home_screen.dart` to load real data
7. Test authentication flow
8. Add test data in Firestore Console
9. Test data loading and display

---

## 🆘 Common Issues

### "Default FirebaseApp is not initialized"
- Missing `google-services.json` file
- Package name mismatch in Firebase Console

### "Permission denied" in Firestore
- Check Firestore Security Rules
- Make sure "Test mode" is enabled for development

### "User not found after registration"
- Make sure you're calling `createUser()` after `registerWithEmailAndPassword()`

### Build errors after enabling Firebase
- Run `flutter clean`
- Run `flutter pub get`
- Restart your IDE

---

**Ready to integrate?** Start with updating `login_screen.dart` or ask for help with any specific screen!
