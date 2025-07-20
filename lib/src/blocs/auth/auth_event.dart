abstract class AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;

  AuthLoggedIn({required this.email, required this.password});
}

class AuthLoggedOut extends AuthEvent {}
