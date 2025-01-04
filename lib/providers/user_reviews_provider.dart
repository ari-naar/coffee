import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeReview {
  final String id;
  final String userId;
  final String shopId;
  final String coffeeType;
  final double rating;
  final String review;
  final List<String> flavorNotes;
  final DateTime createdAt;
  final String? imageUrl;

  CoffeeReview({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.coffeeType,
    required this.rating,
    required this.review,
    required this.flavorNotes,
    required this.createdAt,
    this.imageUrl,
  });

  factory CoffeeReview.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CoffeeReview(
      id: doc.id,
      userId: data['userId'] ?? '',
      shopId: data['shopId'] ?? '',
      coffeeType: data['coffeeType'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      review: data['review'] ?? '',
      flavorNotes: List<String>.from(data['flavorNotes'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'shopId': shopId,
      'coffeeType': coffeeType,
      'rating': rating,
      'review': review,
      'flavorNotes': flavorNotes,
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrl': imageUrl,
    };
  }
}

class UserReviewsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CoffeeReview> _reviews = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CoffeeReview> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch user's reviews
  Future<void> fetchUserReviews(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _reviews =
          snapshot.docs.map((doc) => CoffeeReview.fromFirestore(doc)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch reviews for a coffee shop
  Future<List<CoffeeReview>> fetchShopReviews(String shopId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('shopId', isEqualTo: shopId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CoffeeReview.fromFirestore(doc))
          .toList();
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  // Add a new review
  Future<void> addReview(CoffeeReview review) async {
    try {
      await _firestore.collection('reviews').add(review.toFirestore());

      // Refresh the reviews list if it's the current user's review
      if (_reviews.isNotEmpty && _reviews.first.userId == review.userId) {
        await fetchUserReviews(review.userId);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  // Update a review
  Future<void> updateReview(
      String reviewId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).update(updates);

      // Refresh the reviews list if it contains the updated review
      if (_reviews.any((r) => r.id == reviewId)) {
        await fetchUserReviews(_reviews.first.userId);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  // Delete a review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).delete();

      // Remove the review from the local list
      _reviews.removeWhere((review) => review.id == reviewId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }
}
