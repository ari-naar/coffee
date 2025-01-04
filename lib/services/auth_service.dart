import 'package:firebase_auth/firebase_auth.dart';
import 'base_service.dart';

class AuthService extends BaseService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      logInfo('User signed in: ${credential.user?.email}');
      return credential;
    } catch (e) {
      logError('Failed to sign in', e);
      rethrow;
    }
  }

  // Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      logInfo('User created: ${credential.user?.email}');
      return credential;
    } catch (e) {
      logError('Failed to create user', e);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await auth.signOut();
      logInfo('User signed out');
    } catch (e) {
      logError('Failed to sign out', e);
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      logInfo('Password reset email sent to: $email');
    } catch (e) {
      logError('Failed to send password reset email', e);
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
      logInfo('User profile updated');
    } catch (e) {
      logError('Failed to update user profile', e);
      rethrow;
    }
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      await user.verifyBeforeUpdateEmail(newEmail);
      logInfo('Verification email sent to: $newEmail');
    } catch (e) {
      logError('Failed to update email', e);
      rethrow;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      await user.updatePassword(newPassword);
      logInfo('Password updated');
    } catch (e) {
      logError('Failed to update password', e);
      rethrow;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      await user.delete();
      logInfo('User account deleted');
    } catch (e) {
      logError('Failed to delete account', e);
      rethrow;
    }
  }

  // Stream of auth state changes
  Stream<User?> get authStateChanges => auth.authStateChanges();

  // Get current user's ID token
  Future<String> get idToken async {
    final user = currentUser;
    if (user == null) throw Exception('No user signed in');
    final token = await user.getIdToken();
    if (token == null) throw Exception('Failed to get ID token');
    return token;
  }

  // Reauthenticate user
  Future<UserCredential> reauthenticateWithCredential(
    String email,
    String password,
  ) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user signed in');

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      return await user.reauthenticateWithCredential(credential);
    } catch (e) {
      logError('Failed to reauthenticate user', e);
      rethrow;
    }
  }
}
