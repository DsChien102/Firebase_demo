import 'package:demo/models/app_user.dart';
import 'package:demo/repositories/auth_repo.dart';
import 'package:demo/services/firebase_auth_service.dart';
import 'package:demo/services/firestore_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Repository layer: Chuyển đổi dữ liệu từ Service sang Model
class FirebaseAuthRepo implements AuthRepo {
  FirebaseAuthRepo({
    required FirebaseAuthService authService,
    required FirestoreUserService userService,
  }) : _authService = authService,
       _userService = userService;

  final FirebaseAuthService _authService;
  final FirestoreUserService _userService;

  /// Convert Firebase User to AppUser
  Future<AppUser?> _mapToAppUserWithRole(User? firebaseUser) async {
    if (firebaseUser == null) return null;

    // lay role tu firestore user profile
    try {
      final doc = await _userService.getUserProfile(firebaseUser.uid);
      final data = doc.data();
      if (data != null) {
        return AppUser.fromFirestore(data);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }

    // fallback neu khong co profile
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      createdAt: firebaseUser.metadata.creationTime,
      role: UserRole.user,
    );
  }

  @override
  // Authentication with email and password
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _mapToAppUserWithRole(userCredential.user);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  // Registration with email and password
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
      final user = userCredential.user;
      if (user == null) {
        throw Exception('User registration failed');
      }
      await _authService.updateDisplayName(name);

      // create user profile voi rule mac dinh
      await _userService.createUserProfile(
        uid: user.uid,
        email: email,
        displayName: name,
        role: 'user',
      );

      //  get updated user
      final updatedUser = _authService.getCurrentUser();

      return await _mapToAppUserWithRole(updatedUser);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  // Sign in with Google
  Future<AppUser?> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential == null) return null;

      final user = userCredential.user;
      if (user == null) return null;

      final exists = await _userService.userProfileExists(user.uid);

      if (!exists) {
        await _userService.createUserProfile(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          role: 'user', // ← Mặc định là user
        );
      }

      // ✅ Lấy role từ Firestore
      return await _mapToAppUserWithRole(user);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  @override
  // Logout
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  // Get current user
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _authService.getCurrentUser();
    return await _mapToAppUserWithRole(firebaseUser);
  }

  @override
  // Send password reset email
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      return "Password reset email sent";
    } catch (e) {
      throw Exception('Send password reset email failed: $e');
    }
  }

  // Delete user account
  @override
  Future<void> deleteAccount() async {
    try {
      await _authService.deleteCurrentUser();
      await logout();
    } catch (e) {
      throw Exception('Delete account failed: $e');
    }
  }

  /// Stream of auth state changes with AppUser
  Stream<AppUser?> authStateChanges() {
    return _authService.authStateChanges().asyncMap(_mapToAppUserWithRole);
  }
}
