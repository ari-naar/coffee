import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _error = _getReadableError(e.code);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _error = _getReadableError(e.code);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithApple() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Request Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuthCredential
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Check if user exists
      try {
        final signInMethods = await _auth.fetchSignInMethodsForEmail(
          appleCredential.email ?? '',
        );

        if (signInMethods.isEmpty) {
          // User doesn't exist, create new account
          final userCredential =
              await _auth.signInWithCredential(oauthCredential);

          // Update user profile with Apple provided name if available
          if (appleCredential.givenName != null ||
              appleCredential.familyName != null) {
            await userCredential.user?.updateDisplayName(
              '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                  .trim(),
            );
          }
        } else {
          // User exists, just sign in
          await _auth.signInWithCredential(oauthCredential);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          // If email is not available from Apple, proceed with sign in
          await _auth.signInWithCredential(oauthCredential);
        } else {
          rethrow;
        }
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _auth.signOut();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getReadableError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email address';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'weak-password':
        return 'Please enter a stronger password';
      case 'operation-not-allowed':
        return 'This authentication method is not enabled';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'An error occurred. Please try again';
    }
  }
}
