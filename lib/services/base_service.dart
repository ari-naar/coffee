import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

abstract class BaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Logger _logger = Logger();

  // Protected getters for Firebase instances
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  Logger get logger => _logger;

  // Current user getter
  User? get currentUser => _auth.currentUser;

  // Helper method to get user ID safely
  String get userId {
    final user = currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }
    return user.uid;
  }

  // Helper method to check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Helper method to get a document reference
  DocumentReference documentRef(String collection, String documentId) {
    return _firestore.collection(collection).doc(documentId);
  }

  // Helper method to get a collection reference
  CollectionReference collectionRef(String collection) {
    return _firestore.collection(collection);
  }

  // Helper method to get a storage reference
  Reference storageRef(String path) {
    return _storage.ref(path);
  }

  // Helper method to handle Firestore timestamps
  DateTime? timestampToDateTime(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return null;
  }

  // Helper method to create a Firestore timestamp
  Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  // Helper method to log errors
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  // Helper method to log info
  void logInfo(String message) {
    _logger.i(message);
  }

  // Helper method to log debug messages
  void logDebug(String message) {
    _logger.d(message);
  }

  // Helper method to handle errors
  Never throwError(String message, [dynamic error]) {
    logError(message, error);
    throw Exception(message);
  }
}
