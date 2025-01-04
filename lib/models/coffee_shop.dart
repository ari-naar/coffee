import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeShop {
  final String? id;
  final String name;
  final String address;
  final GeoPoint location;
  final String? description;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic>? operatingHours;
  final List<String>? amenities;
  final DateTime createdAt;
  final DateTime updatedAt;

  CoffeeShop({
    this.id,
    required this.name,
    required this.address,
    required this.location,
    this.description,
    this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.operatingHours,
    this.amenities,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory CoffeeShop.fromMap(Map<String, dynamic> map, String? id) {
    return CoffeeShop(
      id: id,
      name: map['name'] as String,
      address: map['address'] as String,
      location: map['location'] as GeoPoint,
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
      operatingHours: map['operatingHours'] as Map<String, dynamic>?,
      amenities: (map['amenities'] as List<dynamic>?)?.cast<String>(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'operatingHours': operatingHours,
      'amenities': amenities,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  CoffeeShop copyWith({
    String? id,
    String? name,
    String? address,
    GeoPoint? location,
    String? description,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    Map<String, dynamic>? operatingHours,
    List<String>? amenities,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoffeeShop(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      operatingHours: operatingHours ?? this.operatingHours,
      amenities: amenities ?? this.amenities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
