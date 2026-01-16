// lib/repositories/firebase_auth_repo.dart
import 'package:demo/models/app_user.dart';
import 'package:demo/repositories/auth_repo.dart';
import 'package:demo/services/firebase_auth_service.dart';
import 'package:demo/services/firestore_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Repository layer: Chuyển đổi dữ liệu từ Service sang Model
class FirebaseAuthRepo implements AuthRepo {
  FirebaseAuthRepo({
    required FirebaseAuthService authService,
    required FirestoreUserService userService,
  }) : _authService = authService,
       _userService = userService;

  final FirebaseAuthService _authService;
  final FirestoreUserService _userService;

  /// Convert Firebase User to AppUser
  AppUser? _mapToAppUser(User? firebaseUser) {
    if (firebaseUser == null) return null;
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      createdAt: (firebaseUser.metadata.creationTime),
    );
  }

  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapToAppUser(userCredential.user);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        // Update display name
        await _authService.updateDisplayName(name);
      }

      //  get updated user
      final updatedUser = _authService.getCurrentUser();

      return _mapToAppUser(updatedUser);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      return _mapToAppUser(userCredential?.user);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _authService.getCurrentUser();
    return _mapToAppUser(firebaseUser);
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      return "Password reset email sent";
    } catch (e) {
      throw Exception('Send password reset email failed: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _authService.deleteCurrentUser();
      await logout();
    } catch (e) {
      throw Exception('Delete account failed: $e');
    }
  }

  /// Stream of auth state changes (bonus feature for real-time auth state)
  Stream<AppUser?> authStateChanges() {
    return _authService.authStateChanges().map(_mapToAppUser);
  }
}
