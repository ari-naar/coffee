import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_service.dart';

class CoffeeService extends BaseService {
  // Singleton instance
  static final CoffeeService _instance = CoffeeService._internal();
  factory CoffeeService() => _instance;
  CoffeeService._internal();

  // Collection references
  final CollectionReference _coffees =
      FirebaseFirestore.instance.collection('coffees');
  final CollectionReference _reviews =
      FirebaseFirestore.instance.collection('reviews');
  final CollectionReference _favorites =
      FirebaseFirestore.instance.collection('favorites');

  // Add a new coffee
  Future<String> addCoffee(Map<String, dynamic> coffeeData) async {
    try {
      coffeeData['createdAt'] = dateTimeToTimestamp(DateTime.now());
      coffeeData['updatedAt'] = dateTimeToTimestamp(DateTime.now());

      final docRef = await _coffees.add(coffeeData);
      logInfo('Coffee added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      logError('Failed to add coffee', e);
      rethrow;
    }
  }

  // Get coffee by ID
  Future<Map<String, dynamic>?> getCoffee(String coffeeId) async {
    try {
      final doc = await _coffees.doc(coffeeId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      logInfo('Coffee retrieved: $coffeeId');
      return data;
    } catch (e) {
      logError('Failed to get coffee', e);
      rethrow;
    }
  }

  // Update coffee
  Future<void> updateCoffee(
    String coffeeId,
    Map<String, dynamic> data,
  ) async {
    try {
      data['updatedAt'] = dateTimeToTimestamp(DateTime.now());
      await _coffees.doc(coffeeId).update(data);
      logInfo('Coffee updated: $coffeeId');
    } catch (e) {
      logError('Failed to update coffee', e);
      rethrow;
    }
  }

  // Delete coffee
  Future<void> deleteCoffee(String coffeeId) async {
    try {
      // Delete associated reviews
      final reviewsQuery = _reviews.where('coffeeId', isEqualTo: coffeeId);
      final reviewDocs = await reviewsQuery.get();
      for (var doc in reviewDocs.docs) {
        await doc.reference.delete();
      }

      // Delete associated favorites
      final favoritesQuery = _favorites.where('coffeeId', isEqualTo: coffeeId);
      final favoriteDocs = await favoritesQuery.get();
      for (var doc in favoriteDocs.docs) {
        await doc.reference.delete();
      }

      // Delete the coffee document
      await _coffees.doc(coffeeId).delete();
      logInfo('Coffee and associated data deleted: $coffeeId');
    } catch (e) {
      logError('Failed to delete coffee', e);
      rethrow;
    }
  }

  // Add review
  Future<String> addReview(Map<String, dynamic> reviewData) async {
    try {
      reviewData['createdAt'] = dateTimeToTimestamp(DateTime.now());
      reviewData['updatedAt'] = dateTimeToTimestamp(DateTime.now());

      final docRef = await _reviews.add(reviewData);

      // Update coffee rating
      await _updateCoffeeRating(reviewData['coffeeId']);

      logInfo('Review added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      logError('Failed to add review', e);
      rethrow;
    }
  }

  // Get reviews for coffee
  Future<List<Map<String, dynamic>>> getCoffeeReviews(String coffeeId) async {
    try {
      final querySnapshot = await _reviews
          .where('coffeeId', isEqualTo: coffeeId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      logError('Failed to get coffee reviews', e);
      rethrow;
    }
  }

  // Update review
  Future<void> updateReview(
    String reviewId,
    Map<String, dynamic> data,
  ) async {
    try {
      data['updatedAt'] = dateTimeToTimestamp(DateTime.now());
      await _reviews.doc(reviewId).update(data);

      // Get the review to get the coffeeId
      final review = await _reviews.doc(reviewId).get();
      final coffeeId = (review.data() as Map<String, dynamic>)['coffeeId'];

      // Update coffee rating
      await _updateCoffeeRating(coffeeId);

      logInfo('Review updated: $reviewId');
    } catch (e) {
      logError('Failed to update review', e);
      rethrow;
    }
  }

  // Delete review
  Future<void> deleteReview(String reviewId) async {
    try {
      // Get the review to get the coffeeId
      final review = await _reviews.doc(reviewId).get();
      final coffeeId = (review.data() as Map<String, dynamic>)['coffeeId'];

      await _reviews.doc(reviewId).delete();

      // Update coffee rating
      await _updateCoffeeRating(coffeeId);

      logInfo('Review deleted: $reviewId');
    } catch (e) {
      logError('Failed to delete review', e);
      rethrow;
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String userId, String coffeeId) async {
    try {
      final favoriteDoc = _favorites.doc('$userId-$coffeeId');
      final doc = await favoriteDoc.get();

      if (doc.exists) {
        await favoriteDoc.delete();
        logInfo('Favorite removed: $coffeeId for user $userId');
      } else {
        await favoriteDoc.set({
          'userId': userId,
          'coffeeId': coffeeId,
          'createdAt': dateTimeToTimestamp(DateTime.now()),
        });
        logInfo('Favorite added: $coffeeId for user $userId');
      }
    } catch (e) {
      logError('Failed to toggle favorite', e);
      rethrow;
    }
  }

  // Get user favorites
  Future<List<String>> getUserFavorites(String userId) async {
    try {
      final querySnapshot =
          await _favorites.where('userId', isEqualTo: userId).get();

      return querySnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['coffeeId'] as String)
          .toList();
    } catch (e) {
      logError('Failed to get user favorites', e);
      rethrow;
    }
  }

  // Check if coffee is favorited
  Future<bool> isCoffeeFavorited(String userId, String coffeeId) async {
    try {
      final doc = await _favorites.doc('$userId-$coffeeId').get();
      return doc.exists;
    } catch (e) {
      logError('Failed to check if coffee is favorited', e);
      rethrow;
    }
  }

  // Search coffees
  Future<List<Map<String, dynamic>>> searchCoffees({
    String? query,
    String? roastLevel,
    String? origin,
    double? minRating,
    int limit = 20,
  }) async {
    try {
      var coffeeQuery = _coffees.limit(limit);

      if (query != null && query.isNotEmpty) {
        coffeeQuery = coffeeQuery.where('searchTerms',
            arrayContains: query.toLowerCase());
      }

      if (roastLevel != null) {
        coffeeQuery = coffeeQuery.where('roastLevel', isEqualTo: roastLevel);
      }

      if (origin != null) {
        coffeeQuery = coffeeQuery.where('origin', isEqualTo: origin);
      }

      if (minRating != null) {
        coffeeQuery = coffeeQuery.where('averageRating',
            isGreaterThanOrEqualTo: minRating);
      }

      final querySnapshot = await coffeeQuery.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      logError('Failed to search coffees', e);
      rethrow;
    }
  }

  // Get recent coffees
  Future<List<Map<String, dynamic>>> getRecentCoffees({int limit = 10}) async {
    try {
      final querySnapshot = await _coffees
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      logError('Failed to get recent coffees', e);
      rethrow;
    }
  }

  // Get top rated coffees
  Future<List<Map<String, dynamic>>> getTopRatedCoffees(
      {int limit = 10}) async {
    try {
      final querySnapshot = await _coffees
          .orderBy('averageRating', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      logError('Failed to get top rated coffees', e);
      rethrow;
    }
  }

  // Private method to update coffee rating
  Future<void> _updateCoffeeRating(String coffeeId) async {
    try {
      final reviews = await getCoffeeReviews(coffeeId);
      if (reviews.isEmpty) {
        await _coffees.doc(coffeeId).update({
          'averageRating': 0,
          'numberOfReviews': 0,
        });
        return;
      }

      final totalRating = reviews.fold<double>(
        0,
        (sum, review) => sum + (review['rating'] as num).toDouble(),
      );
      final averageRating = totalRating / reviews.length;

      await _coffees.doc(coffeeId).update({
        'averageRating': averageRating,
        'numberOfReviews': reviews.length,
      });
    } catch (e) {
      logError('Failed to update coffee rating', e);
      rethrow;
    }
  }

  // Stream coffee changes
  Stream<DocumentSnapshot> coffeeStream(String coffeeId) {
    return _coffees.doc(coffeeId).snapshots();
  }

  // Stream coffee reviews
  Stream<QuerySnapshot> coffeeReviewsStream(String coffeeId) {
    return _reviews
        .where('coffeeId', isEqualTo: coffeeId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Stream user favorites
  Stream<QuerySnapshot> userFavoritesStream(String userId) {
    return _favorites.where('userId', isEqualTo: userId).snapshots();
  }
}
