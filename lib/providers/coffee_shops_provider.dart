import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class CoffeeShop {
  final String id;
  final String name;
  final String address;
  final GeoPoint location;
  final double rating;
  final String imageUrl;
  final Map<String, dynamic> operatingHours;

  CoffeeShop({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.operatingHours,
  });

  factory CoffeeShop.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CoffeeShop(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      location: data['location'] as GeoPoint,
      rating: (data['rating'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      operatingHours: data['operatingHours'] ?? {},
    );
  }
}

class CoffeeShopsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CoffeeShop> _shops = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CoffeeShop> get shops => _shops;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch nearby coffee shops
  Future<void> fetchNearbyCoffeeShops(Position userLocation,
      {double radius = 5000}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Create a GeoPoint from user's location
      final center = GeoPoint(userLocation.latitude, userLocation.longitude);

      // Query Firestore for nearby shops
      final snapshot = await _firestore.collection('coffee_shops').get();

      _shops = snapshot.docs
          .map((doc) => CoffeeShop.fromFirestore(doc))
          .where((shop) {
        // Calculate distance and filter based on radius
        final distance = Geolocator.distanceBetween(
          center.latitude,
          center.longitude,
          shop.location.latitude,
          shop.location.longitude,
        );
        return distance <= radius;
      }).toList();

      // Sort by distance
      _shops.sort((a, b) {
        final distanceA = Geolocator.distanceBetween(
          center.latitude,
          center.longitude,
          a.location.latitude,
          a.location.longitude,
        );
        final distanceB = Geolocator.distanceBetween(
          center.latitude,
          center.longitude,
          b.location.latitude,
          b.location.longitude,
        );
        return distanceA.compareTo(distanceB);
      });
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search coffee shops by name
  Future<void> searchCoffeeShops(String query) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('coffee_shops')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      _shops =
          snapshot.docs.map((doc) => CoffeeShop.fromFirestore(doc)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get coffee shop by ID
  Future<CoffeeShop?> getCoffeeShopById(String id) async {
    try {
      final doc = await _firestore.collection('coffee_shops').doc(id).get();
      if (doc.exists) {
        return CoffeeShop.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }
}
