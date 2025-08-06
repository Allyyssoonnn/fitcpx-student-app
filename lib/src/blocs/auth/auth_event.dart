import 'package:flutter/material.dart';

abstract class AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;
  final BuildContext context;

  AuthLoggedIn({
    required this.email,
    required this.password,
    required this.context,
  });
}

class AuthLoggedOut extends AuthEvent {}
