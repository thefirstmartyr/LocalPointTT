import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/loyalty_program_model.dart';
import '../models/user_program_model.dart';
import '../models/reward_model.dart';
import '../services/firebase_service.dart';

class LoyaltyRepository {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final String _programsCollection = 'loyalty_programs';
  final String _userProgramsCollection = 'user_programs';
  final String _rewardsCollection = 'rewards';

  // ===== Loyalty Programs =====

  // Create a loyalty program
  Future<String> createProgram(LoyaltyProgramModel program) async {
    try {
      final docRef = await _firestore.collection(_programsCollection).add(program.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create loyalty program: $e');
    }
  }

  // Get program by ID
  Future<LoyaltyProgramModel?> getProgramById(String programId) async {
    try {
      final doc = await _firestore.collection(_programsCollection).doc(programId).get();
      if (doc.exists) {
        return LoyaltyProgramModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get program: $e');
    }
  }

  // Get programs by business
  Future<List<LoyaltyProgramModel>> getProgramsByBusiness(String businessId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_programsCollection)
          .where('businessId', isEqualTo: businessId)
          .where('isActive', isEqualTo: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => LoyaltyProgramModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get programs by business: $e');
    }
  }

  // Update program
  Future<void> updateProgram(LoyaltyProgramModel program) async {
    try {
      await _firestore.collection(_programsCollection).doc(program.id).update(program.toMap());
    } catch (e) {
      throw Exception('Failed to update program: $e');
    }
  }

  // ===== User Programs =====

  // Enroll user in a program
  Future<String> enrollUserInProgram(UserProgramModel userProgram) async {
    try {
      final docRef = await _firestore.collection(_userProgramsCollection).add(userProgram.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to enroll in program: $e');
    }
  }

  // Get user's enrolled programs
  Future<List<UserProgramModel>> getUserPrograms(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_userProgramsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('lastActivity', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => UserProgramModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user programs: $e');
    }
  }

  // Get specific user program
  Future<UserProgramModel?> getUserProgram(String userId, String programId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_userProgramsCollection)
          .where('userId', isEqualTo: userId)
          .where('programId', isEqualTo: programId)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return UserProgramModel.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user program: $e');
    }
  }

  // Update user program points
  Future<void> updateUserProgramPoints(String userProgramId, int points) async {
    try {
      final doc = await _firestore.collection(_userProgramsCollection).doc(userProgramId).get();
      if (doc.exists) {
        final currentData = doc.data()!;
        final currentPoints = currentData['currentPoints'] as int? ?? 0;
        final totalPointsEarned = currentData['totalPointsEarned'] as int? ?? 0;
        
        await _firestore.collection(_userProgramsCollection).doc(userProgramId).update({
          'currentPoints': currentPoints + points,
          'totalPointsEarned': points > 0 ? totalPointsEarned + points : totalPointsEarned,
          'lastActivity': Timestamp.now(),
        });
      }
    } catch (e) {
      throw Exception('Failed to update user program points: $e');
    }
  }

  // Stream user programs
  Stream<List<UserProgramModel>> streamUserPrograms(String userId) {
    return _firestore
        .collection(_userProgramsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('lastActivity', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserProgramModel.fromFirestore(doc))
            .toList());
  }

  // ===== Rewards =====

  // Create a reward
  Future<String> createReward(RewardModel reward) async {
    try {
      final docRef = await _firestore.collection(_rewardsCollection).add(reward.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create reward: $e');
    }
  }

  // Get rewards by program
  Future<List<RewardModel>> getRewardsByProgram(String programId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_rewardsCollection)
          .where('programId', isEqualTo: programId)
          .where('isActive', isEqualTo: true)
          .orderBy('pointsRequired')
          .get();
      
      return querySnapshot.docs
          .map((doc) => RewardModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get rewards: $e');
    }
  }

  // Update reward
  Future<void> updateReward(RewardModel reward) async {
    try {
      await _firestore.collection(_rewardsCollection).doc(reward.id).update(reward.toMap());
    } catch (e) {
      throw Exception('Failed to update reward: $e');
    }
  }

  // Delete reward
  Future<void> deleteReward(String rewardId) async {
    try {
      await _firestore.collection(_rewardsCollection).doc(rewardId).update({
        'isActive': false,
      });
    } catch (e) {
      throw Exception('Failed to delete reward: $e');
    }
  }
}
