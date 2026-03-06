import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType {
  earn,
  redeem,
}

class TransactionModel {
  final String id;
  final String userId;
  final String businessId;
  final String programId;
  final TransactionType type;
  final int points;
  final String description;
  final DateTime timestamp;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.programId,
    required this.type,
    required this.points,
    required this.description,
    required this.timestamp,
  });

  // Convert TransactionModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'businessId': businessId,
      'programId': programId,
      'type': type.name,
      'points': points,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create TransactionModel from Firestore document
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      businessId: data['businessId'] ?? '',
      programId: data['programId'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => TransactionType.earn,
      ),
      points: data['points'] ?? 0,
      description: data['description'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create TransactionModel from Map (for JSON/local storage)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      businessId: map['businessId'] ?? '',
      programId: map['programId'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.earn,
      ),
      points: map['points'] ?? 0,
      description: map['description'] ?? '',
      timestamp: map['timestamp'] is DateTime 
          ? map['timestamp'] 
          : DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessId': businessId,
      'programId': programId,
      'type': type.name,
      'points': points,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Helper method to check if transaction is earning points
  bool get isEarning => type == TransactionType.earn;

  // Helper method to check if transaction is redeeming points
  bool get isRedeeming => type == TransactionType.redeem;

  // Create a copy with updated fields
  TransactionModel copyWith({
    String? id,
    String? userId,
    String? businessId,
    String? programId,
    TransactionType? type,
    int? points,
    String? description,
    DateTime? timestamp,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      programId: programId ?? this.programId,
      type: type ?? this.type,
      points: points ?? this.points,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
