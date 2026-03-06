import 'package:cloud_firestore/cloud_firestore.dart';

class LoyaltyProgramModel {
  final String id;
  final String businessId;
  final String name;
  final String description;
  final int pointsPerVisit;
  final double pointsPerDollar;
  final bool isActive;
  final DateTime createdAt;
  
  LoyaltyProgramModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.pointsPerVisit,
    required this.pointsPerDollar,
    required this.isActive,
    required this.createdAt,
  });

  // Convert LoyaltyProgramModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'businessId': businessId,
      'name': name,
      'description': description,
      'pointsPerVisit': pointsPerVisit,
      'pointsPerDollar': pointsPerDollar,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create LoyaltyProgramModel from Firestore document
  factory LoyaltyProgramModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LoyaltyProgramModel(
      id: doc.id,
      businessId: data['businessId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      pointsPerVisit: data['pointsPerVisit'] ?? 0,
      pointsPerDollar: (data['pointsPerDollar'] ?? 0).toDouble(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  
  // Create LoyaltyProgramModel from Map (for JSON/local storage)
  factory LoyaltyProgramModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyProgramModel(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pointsPerVisit: json['pointsPerVisit'] as int,
      pointsPerDollar: (json['pointsPerDollar'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] is DateTime 
          ? json['createdAt'] 
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessId': businessId,
      'name': name,
      'description': description,
      'pointsPerVisit': pointsPerVisit,
      'pointsPerDollar': pointsPerDollar,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  LoyaltyProgramModel copyWith({
    String? id,
    String? businessId,
    String? name,
    String? description,
    int? pointsPerVisit,
    double? pointsPerDollar,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return LoyaltyProgramModel(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      description: description ?? this.description,
      pointsPerVisit: pointsPerVisit ?? this.pointsPerVisit,
      pointsPerDollar: pointsPerDollar ?? this.pointsPerDollar,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
