import 'package:demo/models/app_user.dart';

abstract class AuthState {}

// underlying states for authentication
class AuthInitial extends AuthState {}

// loading state
class AuthLoading extends AuthState {}

// authenticated state with user data
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

// unauthenticated state
class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
