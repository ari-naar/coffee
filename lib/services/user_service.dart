import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_service.dart';

class UserService extends BaseService {
  // Singleton instance
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Collection reference
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  // Create user profile
  Future<void> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _users.doc(uid).set({
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'createdAt': dateTimeToTimestamp(DateTime.now()),
        'updatedAt': dateTimeToTimestamp(DateTime.now()),
      });
      logInfo('User profile created for: $email');
    } catch (e) {
      logError('Failed to create user profile', e);
      rethrow;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      logInfo('User profile retrieved for: ${data['email']}');
      return data;
    } catch (e) {
      logError('Failed to get user profile', e);
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      data['updatedAt'] = dateTimeToTimestamp(DateTime.now());
      await _users.doc(uid).update(data);
      logInfo('User profile updated for: $uid');
    } catch (e) {
      logError('Failed to update user profile', e);
      rethrow;
    }
  }

  // Delete user profile
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _users.doc(uid).delete();
      logInfo('User profile deleted: $uid');
    } catch (e) {
      logError('Failed to delete user profile', e);
      rethrow;
    }
  }

  // Get user preferences
  Future<Map<String, dynamic>?> getUserPreferences(String uid) async {
    try {
      final doc =
          await _users.doc(uid).collection('preferences').doc('settings').get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      logInfo('User preferences retrieved for: $uid');
      return data;
    } catch (e) {
      logError('Failed to get user preferences', e);
      rethrow;
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences(
    String uid,
    Map<String, dynamic> preferences,
  ) async {
    try {
      await _users
          .doc(uid)
          .collection('preferences')
          .doc('settings')
          .set(preferences, SetOptions(merge: true));
      logInfo('User preferences updated for: $uid');
    } catch (e) {
      logError('Failed to update user preferences', e);
      rethrow;
    }
  }

  // Get user statistics
  Future<Map<String, dynamic>?> getUserStatistics(String uid) async {
    try {
      final doc =
          await _users.doc(uid).collection('statistics').doc('overview').get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      logInfo('User statistics retrieved for: $uid');
      return data;
    } catch (e) {
      logError('Failed to get user statistics', e);
      rethrow;
    }
  }

  // Update user statistics
  Future<void> updateUserStatistics(
    String uid,
    Map<String, dynamic> statistics,
  ) async {
    try {
      await _users
          .doc(uid)
          .collection('statistics')
          .doc('overview')
          .set(statistics, SetOptions(merge: true));
      logInfo('User statistics updated for: $uid');
    } catch (e) {
      logError('Failed to update user statistics', e);
      rethrow;
    }
  }

  // Stream user profile changes
  Stream<DocumentSnapshot> userProfileStream(String uid) {
    return _users.doc(uid).snapshots();
  }

  // Stream user preferences changes
  Stream<DocumentSnapshot> userPreferencesStream(String uid) {
    return _users
        .doc(uid)
        .collection('preferences')
        .doc('settings')
        .snapshots();
  }

  // Stream user statistics changes
  Stream<DocumentSnapshot> userStatisticsStream(String uid) {
    return _users.doc(uid).collection('statistics').doc('overview').snapshots();
  }
}
