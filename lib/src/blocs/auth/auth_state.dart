abstract class AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
