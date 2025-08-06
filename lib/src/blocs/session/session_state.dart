import 'package:fitcpxaluno/src/models/session_model.dart';

abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionLoaded extends SessionState {
  final SessionModel session;

  SessionLoaded(this.session);
}

class SessionError extends SessionState {
  final String message;

  SessionError(this.message);
}
