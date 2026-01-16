// lib/services/firebase_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service layer: Giao tiếp trực tiếp với Firebase Auth và Google Sign-In
class FirebaseAuthService {
  FirebaseAuthService(this._firebaseAuth, this._googleSignIn);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

    // User cancelled
    if (gUser == null) return null;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in with credential
    return _firebaseAuth.signInWithCredential(credential);
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Sign out from both Firebase and Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  /// Delete current user
  Future<void> deleteCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    return user.delete();
  }

  /// Get current Firebase user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Stream of auth state changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  /// Update display name
  Future<void> updateDisplayName(String displayName) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload();
    }
  }
}
