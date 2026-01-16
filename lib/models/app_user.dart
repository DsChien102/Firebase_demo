import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt,
    };
  }

  /// Create AppUser from Firestore document
  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
