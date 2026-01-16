import 'package:cloud_firestore/cloud_firestore.dart';

// Giao tiep voi Firestore de quan ly thong tin nguoi dung
class FirestoreUserService {
  FirestoreUserService(this._db);

  // khoi tao Firestore instance
  final FirebaseFirestore _db;

  // tra ve tham chieu den collection 'users'
  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _db.collection("users");

  // Create user profile in Firestore
  Future<void> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
    String role = 'user',
  }) {
    return _usersRef.doc(uid).set({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user profile from document
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) {
    return _usersRef.doc(uid).get();
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? email,
    String? displayName,
    String? role,
  }) {
    final data = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};

    if (email != null) data['email'] = email;
    if (displayName != null) data['displayName'] = displayName;
    if (role != null) data['role'] = role;

    return _usersRef.doc(uid).update(data);
  }

  // Delete user profile
  Future<void> deleteUserProfile(String uid) {
    return _usersRef.doc(uid).delete();
  }

  // Check if user profile exists
  Future<bool> userProfileExists(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    return doc.exists;
  }
}
