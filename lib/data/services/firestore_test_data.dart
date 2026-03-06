import 'package:cloud_firestore/cloud_firestore.dart';

/// This script helps you add test data to Firestore
/// 
/// To use this script:
/// 1. Make sure you're logged in with a test account
/// 2. Call the functions from your app (e.g., from a debug button)
/// 3. Or use Flutter's DevTools to run these functions
/// 
/// Example usage in your app:
/// ```dart
/// ElevatedButton(
///   onPressed: () async {
///     await FirestoreTestData.addAllTestData('your-user-id');
///     print('Test data added!');
///   },
///   child: Text('Add Test Data'),
/// )
/// ```

class FirestoreTestData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add all test data at once
  static Future<void> addAllTestData(String userId) async {
    try {
      print('🚀 Starting to add test data...');
      
      // Add businesses
      final businessIds = await addTestBusinesses();
      print('✅ Added ${businessIds.length} businesses');
      
      // Add loyalty programs
      final programIds = await addTestPrograms(businessIds);
      print('✅ Added ${programIds.length} loyalty programs');
      
      // Add user programs
      await addTestUserPrograms(userId, programIds, businessIds);
      print('✅ Added user programs');
      
      print('🎉 All test data added successfully!');
    } catch (e) {
      print('❌ Error adding test data: $e');
      rethrow;
    }
  }

  /// Add sample businesses
  static Future<List<String>> addTestBusinesses() async {
    final businesses = [
      {
        'name': "Joe's Coffee Shop",
        'description': 'Premium coffee and pastries in the heart of Port of Spain',
        'category': 'Food & Beverage',
        'address': '123 Frederick Street, Port of Spain',
        'phone': '+1 868-555-0101',
        'logo': null,
        'ownerId': 'test-owner-1',
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Best Bakery TT',
        'description': 'Fresh bread and pastries daily',
        'category': 'Food & Beverage',
        'address': '456 Queen Street, San Fernando',
        'phone': '+1 868-555-0102',
        'logo': null,
        'ownerId': 'test-owner-2',
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Tech Store',
        'description': 'Latest tech gadgets and accessories',
        'category': 'Electronics',
        'address': '789 Independence Square, Port of Spain',
        'phone': '+1 868-555-0103',
        'logo': null,
        'ownerId': 'test-owner-3',
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Fitness First Gym',
        'description': 'Modern gym with professional trainers',
        'category': 'Health & Fitness',
        'address': '321 Ariapita Avenue, Woodbrook',
        'phone': '+1 868-555-0104',
        'logo': null,
        'ownerId': 'test-owner-4',
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
      {
        'name': 'Book Haven',
        'description': 'Your local bookstore with a great selection',
        'category': 'Retail',
        'address': '654 Charlotte Street, Port of Spain',
        'phone': '+1 868-555-0105',
        'logo': null,
        'ownerId': 'test-owner-5',
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
    ];

    final businessIds = <String>[];
    for (var business in businesses) {
      final docRef = await _firestore.collection('businesses').add(business);
      businessIds.add(docRef.id);
      print('  Added business: ${business['name']}');
    }

    return businessIds;
  }

  /// Add sample loyalty programs
  static Future<List<String>> addTestPrograms(List<String> businessIds) async {
    if (businessIds.length < 5) {
      throw Exception('Need at least 5 business IDs');
    }

    final programs = [
      {
        'businessId': businessIds[0], // Joe's Coffee Shop
        'name': 'Coffee Rewards',
        'description': 'Earn points with every coffee purchase',
        'pointsPerVisit': 10,
        'pointsPerDollar': 1.0,
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
      {
        'businessId': businessIds[1], // Best Bakery TT
        'name': 'Baker\'s Club',
        'description': 'Sweet rewards for our loyal customers',
        'pointsPerVisit': 15,
        'pointsPerDollar': 1.5,
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
      {
        'businessId': businessIds[2], // Tech Store
        'name': 'Tech Points',
        'description': 'Earn big points on tech purchases',
        'pointsPerVisit': 20,
        'pointsPerDollar': 2.0,
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
      {
        'businessId': businessIds[3], // Fitness First Gym
        'name': 'Fit Rewards',
        'description': 'Stay fit and earn rewards',
        'pointsPerVisit': 25,
        'pointsPerDollar': 0.5,
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
      {
        'businessId': businessIds[4], // Book Haven
        'name': 'Reader\'s Club',
        'description': 'Rewards for book lovers',
        'pointsPerVisit': 12,
        'pointsPerDollar': 1.2,
        'isActive': true,
        'createdAt': Timestamp.now(),
      },
    ];

    final programIds = <String>[];
    for (var program in programs) {
      final docRef = await _firestore.collection('loyalty_programs').add(program);
      programIds.add(docRef.id);
      print('  Added program: ${program['name']}');
    }

    return programIds;
  }

  /// Add sample user programs (user enrollments)
  static Future<void> addTestUserPrograms(
    String userId,
    List<String> programIds,
    List<String> businessIds,
  ) async {
    if (programIds.length < 3 || businessIds.length < 3) {
      throw Exception('Need at least 3 program and business IDs');
    }

    // Enroll user in first 3 programs
    final userPrograms = [
      {
        'userId': userId,
        'programId': programIds[0],
        'businessId': businessIds[0],
        'currentPoints': 450,
        'totalPointsEarned': 450,
        'enrolledAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 60))),
        'lastActivity': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
      },
      {
        'userId': userId,
        'programId': programIds[1],
        'businessId': businessIds[1],
        'currentPoints': 280,
        'totalPointsEarned': 280,
        'enrolledAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 45))),
        'lastActivity': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
      },
      {
        'userId': userId,
        'programId': programIds[2],
        'businessId': businessIds[2],
        'currentPoints': 520,
        'totalPointsEarned': 520,
        'enrolledAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 30))),
        'lastActivity': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      },
    ];

    for (var userProgram in userPrograms) {
      await _firestore.collection('user_programs').add(userProgram);
      print('  Added user program with ${userProgram['currentPoints']} points');
    }
  }

  /// Clear all test data (use with caution!)
  static Future<void> clearAllTestData() async {
    print('⚠️  Clearing all test data...');
    
    // Delete all businesses
    final businessSnapshot = await _firestore.collection('businesses').get();
    for (var doc in businessSnapshot.docs) {
      await doc.reference.delete();
    }
    print('  Deleted ${businessSnapshot.docs.length} businesses');
    
    // Delete all loyalty programs
    final programSnapshot = await _firestore.collection('loyalty_programs').get();
    for (var doc in programSnapshot.docs) {
      await doc.reference.delete();
    }
    print('  Deleted ${programSnapshot.docs.length} programs');
    
    // Delete all user programs
    final userProgramSnapshot = await _firestore.collection('user_programs').get();
    for (var doc in userProgramSnapshot.docs) {
      await doc.reference.delete();
    }
    print('  Deleted ${userProgramSnapshot.docs.length} user programs');
    
    print('✅ All test data cleared');
  }
}
