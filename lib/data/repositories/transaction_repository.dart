import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../services/firebase_service.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final String _collection = 'transactions';

  // Create a transaction
  Future<String> createTransaction(TransactionModel transaction) async {
    try {
      final docRef = await _firestore.collection(_collection).add(transaction.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Get transaction by ID
  Future<TransactionModel?> getTransactionById(String transactionId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(transactionId).get();
      if (doc.exists) {
        return TransactionModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }

  // Get user transactions
  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user transactions: $e');
    }
  }

  // Get user transactions by business
  Future<List<TransactionModel>> getUserTransactionsByBusiness(
    String userId,
    String businessId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('businessId', isEqualTo: businessId)
          .orderBy('timestamp', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user transactions by business: $e');
    }
  }

  // Get user transactions by program
  Future<List<TransactionModel>> getUserTransactionsByProgram(
    String userId,
    String programId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('programId', isEqualTo: programId)
          .orderBy('timestamp', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user transactions by program: $e');
    }
  }

  // Get user transactions by type
  Future<List<TransactionModel>> getUserTransactionsByType(
    String userId,
    TransactionType type,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type.name)
          .orderBy('timestamp', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user transactions by type: $e');
    }
  }

  // Get business transactions
  Future<List<TransactionModel>> getBusinessTransactions(String businessId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('businessId', isEqualTo: businessId)
          .orderBy('timestamp', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get business transactions: $e');
    }
  }

  // Stream user transactions
  Stream<List<TransactionModel>> streamUserTransactions(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList());
  }

  // Get user total points earned
  Future<int> getUserTotalPointsEarned(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: TransactionType.earn.name)
          .get();
      
      int totalPoints = 0;
      for (var doc in querySnapshot.docs) {
        final transaction = TransactionModel.fromFirestore(doc);
        totalPoints += transaction.points;
      }
      
      return totalPoints;
    } catch (e) {
      throw Exception('Failed to get user total points: $e');
    }
  }

  // Get user total points redeemed
  Future<int> getUserTotalPointsRedeemed(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: TransactionType.redeem.name)
          .get();
      
      int totalPoints = 0;
      for (var doc in querySnapshot.docs) {
        final transaction = TransactionModel.fromFirestore(doc);
        totalPoints += transaction.points;
      }
      
      return totalPoints;
    } catch (e) {
      throw Exception('Failed to get user total points redeemed: $e');
    }
  }
}
