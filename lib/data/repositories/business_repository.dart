import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/business_model.dart';
import '../services/firebase_service.dart';

class BusinessRepository {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final String _collection = 'businesses';

  // Create a new business
  Future<String> createBusiness(BusinessModel business) async {
    try {
      final docRef = await _firestore.collection(_collection).add(business.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create business: $e');
    }
  }

  // Get business by ID
  Future<BusinessModel?> getBusinessById(String businessId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(businessId).get();
      if (doc.exists) {
        return BusinessModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get business: $e');
    }
  }

  // Get all businesses
  Future<List<BusinessModel>> getAllBusinesses() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();
      
      return querySnapshot.docs
          .map((doc) => BusinessModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get businesses: $e');
    }
  }

  // Get businesses by category
  Future<List<BusinessModel>> getBusinessesByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();
      
      return querySnapshot.docs
          .map((doc) => BusinessModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get businesses by category: $e');
    }
  }

  // Get businesses by owner
  Future<List<BusinessModel>> getBusinessesByOwner(String ownerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('name')
          .get();
      
      return querySnapshot.docs
          .map((doc) => BusinessModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get businesses by owner: $e');
    }
  }

  // Update business
  Future<void> updateBusiness(BusinessModel business) async {
    try {
      await _firestore.collection(_collection).doc(business.id).update(business.toMap());
    } catch (e) {
      throw Exception('Failed to update business: $e');
    }
  }

  // Delete business (soft delete - set isActive to false)
  Future<void> deleteBusiness(String businessId) async {
    try {
      await _firestore.collection(_collection).doc(businessId).update({
        'isActive': false,
      });
    } catch (e) {
      throw Exception('Failed to delete business: $e');
    }
  }

  // Stream businesses
  Stream<List<BusinessModel>> streamBusinesses() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BusinessModel.fromFirestore(doc))
            .toList());
  }

  // Search businesses by name
  Future<List<BusinessModel>> searchBusinesses(String searchTerm) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();
      
      // Filter results by search term (case-insensitive)
      final results = querySnapshot.docs
          .map((doc) => BusinessModel.fromFirestore(doc))
          .where((business) => 
              business.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
              business.description.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
      
      return results;
    } catch (e) {
      throw Exception('Failed to search businesses: $e');
    }
  }
}
