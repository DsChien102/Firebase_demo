import 'package:demo/models/app_user.dart';
import 'package:demo/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Login with email and password
  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      AppUser? user = AppUser(uid: userCredential.user!.uid, email: email);
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Delete account
  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) throw Exception('No user is currently signed in.');
      await user.delete();

      await logout();
    } catch (e) {
      throw Exception('Delete account failed: $e');
    }
  }

  // Get current user
  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) return null;

    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!);
  }

  // Logout
  @override
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {
      // Handle error if needed
    }
    await firebaseAuth.signOut();
  }

  // Send password reset email
  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset email sent";
    } catch (e) {
      throw Exception('Send password reset email failed: $e');
    }
  }

  // Register with email and password
  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      AppUser user = AppUser(uid: userCredential.user!.uid, email: email);
      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Sign in with Google
  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // user bấm cancel
      if (gUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // sign in with credential
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      // firebase user
      final firebaseUser = userCredential.user;

      // user cancel sign in
      if (firebaseUser == null) return null;
      final uid = firebaseUser.uid;
      final email = firebaseUser.email ?? '';

      AppUser appUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );
      return appUser;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
