import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/business_model.dart';
import '../models/loyalty_program_model.dart';
import '../models/user_program_model.dart';

class FirestoreDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all businesses
  Future<List<BusinessModel>> getAllBusinesses() async {
    try {
      final snapshot = await _firestore
          .collection('businesses')
          .where('isActive', isEqualTo: true)
          .get();
      
      return snapshot.docs
          .map((doc) => BusinessModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load businesses: $e');
    }
  }

  // Get all active loyalty programs
  Future<List<LoyaltyProgramModel>> getAllPrograms() async {
    try {
      final snapshot = await _firestore
          .collection('loyalty_programs')
          .where('isActive', isEqualTo: true)
          .get();
      
      return snapshot.docs
          .map((doc) => LoyaltyProgramModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load programs: $e');
    }
  }

  // Get programs for a specific business
  Future<List<LoyaltyProgramModel>> getBusinessPrograms(String businessId) async {
    try {
      final snapshot = await _firestore
          .collection('loyalty_programs')
          .where('businessId', isEqualTo: businessId)
          .where('isActive', isEqualTo: true)
          .get();
      
      return snapshot.docs
          .map((doc) => LoyaltyProgramModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load business programs: $e');
    }
  }

  // Get user's enrolled programs
  Future<List<UserProgramModel>> getUserPrograms(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('user_programs')
          .where('userId', isEqualTo: userId)
          .get();
      
      final programs = snapshot.docs
          .map((doc) => UserProgramModel.fromFirestore(doc))
          .toList();
      
      // Sort by lastActivity in memory to avoid needing a composite index
      programs.sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
      
      return programs;
    } catch (e) {
      throw Exception('Failed to load user programs: $e');
    }
  }

  // Stream user's enrolled programs (real-time updates)
  Stream<List<UserProgramModel>> streamUserPrograms(String userId) {
    return _firestore
        .collection('user_programs')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final programs = snapshot.docs
              .map((doc) => UserProgramModel.fromFirestore(doc))
              .toList();
          
          // Sort by lastActivity in memory to avoid needing a composite index
          programs.sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
          
          return programs;
        });
  }

  // Get business by ID
  Future<BusinessModel?> getBusinessById(String businessId) async {
    try {
      final doc = await _firestore.collection('businesses').doc(businessId).get();
      if (doc.exists) {
        return BusinessModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load business: $e');
    }
  }

  // Get program by ID
  Future<LoyaltyProgramModel?> getProgramById(String programId) async {
    try {
      final doc = await _firestore.collection('loyalty_programs').doc(programId).get();
      if (doc.exists) {
        return LoyaltyProgramModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load program: $e');
    }
  }

  // Enroll user in a program
  Future<UserProgramModel> enrollUserInProgram({
    required String userId,
    required String programId,
    required String businessId,
  }) async {
    try {
      final userProgram = UserProgramModel(
        id: '', // Will be set by Firestore
        userId: userId,
        programId: programId,
        businessId: businessId,
        currentPoints: 0,
        totalPointsEarned: 0,
        enrolledAt: DateTime.now(),
        lastActivity: DateTime.now(),
      );

      final docRef = await _firestore.collection('user_programs').add(userProgram.toMap());
      
      return userProgram.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to enroll in program: $e');
    }
  }

  // Update user program points
  Future<void> updateUserProgramPoints({
    required String userProgramId,
    required int pointsToAdd,
  }) async {
    try {
      final docRef = _firestore.collection('user_programs').doc(userProgramId);
      
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        
        if (!snapshot.exists) {
          throw Exception('User program not found');
        }
        
        final currentPoints = snapshot.data()?['currentPoints'] ?? 0;
        final totalPointsEarned = snapshot.data()?['totalPointsEarned'] ?? 0;
        
        transaction.update(docRef, {
          'currentPoints': currentPoints + pointsToAdd,
          'totalPointsEarned': totalPointsEarned + pointsToAdd,
          'lastActivity': Timestamp.now(),
        });
      });
    } catch (e) {
      throw Exception('Failed to update points: $e');
    }
  }

  // Get total points across all programs for a user
  Future<int> getTotalUserPoints(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('user_programs')
          .where('userId', isEqualTo: userId)
          .get();
      
      int totalPoints = 0;
      for (var doc in snapshot.docs) {
        totalPoints += (doc.data()['currentPoints'] ?? 0) as int;
      }
      
      return totalPoints;
    } catch (e) {
      throw Exception('Failed to calculate total points: $e');
    }
  }
}
