// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Get current user
//   User? get currentUser => _auth.currentUser;

//   // Create user with email and password
//   Future<UserCredential> createUserWithEmail(
//       String email, String password) async {
//     try {
//       // Create the user in Firebase Auth
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Create the user document in Firestore
//       await _createUserDocument(userCredential.user!);

//       return userCredential;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Create user document in Firestore
//   Future<void> _createUserDocument(User user) async {
//     await _firestore.collection('users').doc(user.uid).set({
//       'email': user.email,
//       'uid': user.uid,
//       'createdAt': FieldValue.serverTimestamp(),
//     });

//     // Initialize empty collections for reviews and bookmarks
//     // Note: In Firestore, you don't need to explicitly create empty collections
//     // They will be created automatically when the first document is added
//   }

//   // Delete user
//   Future<void> deleteUser() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         // Delete user document and all subcollections from Firestore
//         await _firestore.collection('users').doc(user.uid).delete();

//         // Delete the user authentication account
//         await user.delete();
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }
