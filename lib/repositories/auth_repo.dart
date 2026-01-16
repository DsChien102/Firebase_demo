import 'package:demo/models/app_user.dart';

abstract class AuthRepo {
  // Authentication with email and password
  Future<AppUser?> loginWithEmailAndPassword(String username, String password);

  // Registration with email and password
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  // Logout
  Future<void> logout();

  // Get current user
  Future<AppUser?> getCurrentUser();

  // Send password reset email
  Future<String> sendPasswordResetEmail(String email);

  // Delete user account
  Future<void> deleteAccount();

  // Sign in with Google
  Future<AppUser?> signInWithGoogle();
}
