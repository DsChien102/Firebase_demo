import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { user, admin }

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime? createdAt;
  final UserRole role;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.createdAt,
    this.role = UserRole.user,
  });

  //  check if user is admin
  bool get isAdmin => role == UserRole.admin;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt?.toIso8601String(),
      'role': role.name,
    };
  }

  /// Create AppUser from Firestore document
  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      role: _parseRole(data['role']),
    );
  }

  // parse role from dynamic data
  static UserRole _parseRole(dynamic roleData) {
    if (roleData == null) return UserRole.user;

    if (roleData is String) {
      switch (roleData.toLowerCase()) {
        case 'admin':
          return UserRole.admin;
        case 'user':
        default:
          return UserRole.user;
      }
    }
    return UserRole.user;
  }
}
