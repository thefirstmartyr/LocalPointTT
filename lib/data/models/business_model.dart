import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String address;
  final String phone;
  final String? logo;
  final String ownerId;
  final bool isActive;
  final DateTime createdAt;

  BusinessModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    required this.phone,
    this.logo,
    required this.ownerId,
    required this.isActive,
    required this.createdAt,
  });

  // Convert BusinessModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'address': address,
      'phone': phone,
      'logo': logo,
      'ownerId': ownerId,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create BusinessModel from Firestore document
  factory BusinessModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BusinessModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      logo: data['logo'],
      ownerId: data['ownerId'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create BusinessModel from Map (for JSON/local storage)
  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      logo: map['logo'],
      ownerId: map['ownerId'] ?? '',
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
      'name': name,
      'description': description,
      'category': category,
      'address': address,
      'phone': phone,
      'logo': logo,
      'ownerId': ownerId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  BusinessModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? address,
    String? phone,
    String? logo,
    String? ownerId,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      logo: logo ?? this.logo,
      ownerId: ownerId ?? this.ownerId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
