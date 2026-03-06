import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgramModel {
  final String id;
  final String userId;
  final String programId;
  final String businessId;
  final int currentPoints;
  final int totalPointsEarned;
  final DateTime enrolledAt;
  final DateTime lastActivity;

  UserProgramModel({
    required this.id,
    required this.userId,
    required this.programId,
    required this.businessId,
    required this.currentPoints,
    required this.totalPointsEarned,
    required this.enrolledAt,
    required this.lastActivity,
  });

  // Convert UserProgramModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'programId': programId,
      'businessId': businessId,
      'currentPoints': currentPoints,
      'totalPointsEarned': totalPointsEarned,
      'enrolledAt': Timestamp.fromDate(enrolledAt),
      'lastActivity': Timestamp.fromDate(lastActivity),
    };
  }

  // Create UserProgramModel from Firestore document
  factory UserProgramModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProgramModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      programId: data['programId'] ?? '',
      businessId: data['businessId'] ?? '',
      currentPoints: data['currentPoints'] ?? 0,
      totalPointsEarned: data['totalPointsEarned'] ?? 0,
      enrolledAt: (data['enrolledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActivity: (data['lastActivity'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create UserProgramModel from Map (for JSON/local storage)
  factory UserProgramModel.fromMap(Map<String, dynamic> map) {
    return UserProgramModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      programId: map['programId'] ?? '',
      businessId: map['businessId'] ?? '',
      currentPoints: map['currentPoints'] ?? 0,
      totalPointsEarned: map['totalPointsEarned'] ?? 0,
      enrolledAt: map['enrolledAt'] is DateTime 
          ? map['enrolledAt'] 
          : DateTime.parse(map['enrolledAt'] ?? DateTime.now().toIso8601String()),
      lastActivity: map['lastActivity'] is DateTime 
          ? map['lastActivity'] 
          : DateTime.parse(map['lastActivity'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'programId': programId,
      'businessId': businessId,
      'currentPoints': currentPoints,
      'totalPointsEarned': totalPointsEarned,
      'enrolledAt': enrolledAt.toIso8601String(),
      'lastActivity': lastActivity.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  UserProgramModel copyWith({
    String? id,
    String? userId,
    String? programId,
    String? businessId,
    int? currentPoints,
    int? totalPointsEarned,
    DateTime? enrolledAt,
    DateTime? lastActivity,
  }) {
    return UserProgramModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      programId: programId ?? this.programId,
      businessId: businessId ?? this.businessId,
      currentPoints: currentPoints ?? this.currentPoints,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}
