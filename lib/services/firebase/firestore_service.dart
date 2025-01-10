// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Get user document reference
//   DocumentReference<Map<String, dynamic>> get _userDoc {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No authenticated user found');
//     return _firestore.collection('users').doc(user.uid);
//   }

//   // Get user data
//   Future<Map<String, dynamic>?> getUserData() async {
//     final snapshot = await _userDoc.get();
//     return snapshot.data();
//   }

//   // Add a review
//   Future<void> addReview(Map<String, dynamic> reviewData) async {
//     await _userDoc.collection('reviews').add({
//       ...reviewData,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // Get user's reviews
//   Future<List<Map<String, dynamic>>> getUserReviews() async {
//     final snapshot = await _userDoc.collection('reviews').get();
//     return snapshot.docs.map((doc) => doc.data()).toList();
//   }

//   // Add a bookmark
//   Future<void> addBookmark(Map<String, dynamic> bookmarkData) async {
//     final String cafeId = bookmarkData['cafeId'];
//     await _userDoc.collection('bookmarks').doc(cafeId).set({
//       ...bookmarkData,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // Remove a bookmark
//   Future<void> removeBookmark(String cafeId) async {
//     await _userDoc.collection('bookmarks').doc(cafeId).delete();
//   }

//   // Get user's bookmarks
//   Future<List<Map<String, dynamic>>> getUserBookmarks() async {
//     final snapshot = await _userDoc.collection('bookmarks').get();
//     return snapshot.docs.map((doc) => doc.data()).toList();
//   }

//   // Check if a cafe is bookmarked
//   Future<bool> isBookmarked(String cafeId) async {
//     final doc = await _userDoc.collection('bookmarks').doc(cafeId).get();
//     return doc.exists;
//   }
// }
