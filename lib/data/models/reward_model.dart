import 'package:cloud_firestore/cloud_firestore.dart';

class RewardModel {
  final String id;
  final String programId;
  final String name;
  final String description;
  final int pointsRequired;
  final bool isActive;
  final DateTime createdAt;

  RewardModel({
    required this.id,
    required this.programId,
    required this.name,
    required this.description,
    required this.pointsRequired,
    required this.isActive,
    required this.createdAt,
  });

  // Convert RewardModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'programId': programId,
      'name': name,
      'description': description,
      'pointsRequired': pointsRequired,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create RewardModel from Firestore document
  factory RewardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RewardModel(
      id: doc.id,
      programId: data['programId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      pointsRequired: data['pointsRequired'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create RewardModel from Map (for JSON/local storage)
  factory RewardModel.fromMap(Map<String, dynamic> map) {
    return RewardModel(
      id: map['id'] ?? '',
      programId: map['programId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      pointsRequired: map['pointsRequired'] ?? 0,
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] is DateTime 
          ? map['createdAt'] 
          : DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'programId': programId,
      'name': name,
      'description': description,
      'pointsRequired': pointsRequired,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  RewardModel copyWith({
    String? id,
    String? programId,
    String? name,
    String? description,
    int? pointsRequired,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return RewardModel(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      name: name ?? this.name,
      description: description ?? this.description,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
