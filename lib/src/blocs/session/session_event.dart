import 'package:fitcpxaluno/src/models/session_model.dart';

abstract class SessionEvent {}

class TickTimer extends SessionEvent {}

class StartWorkout extends SessionEvent {
  final SessionModel session;

  StartWorkout(this.session);
}

class FinishWorkout extends SessionEvent {}

class LoadSession extends SessionEvent {}

class CheckExerciseSession extends SessionEvent {
  final bool check;
  final int exerciseId;

  CheckExerciseSession(this.check, this.exerciseId);
}

class UpdateSetExercise extends SessionEvent {
  final bool? check;
  final int exerciseId;
  final int? exerciseSuperSetId;
  final int setId;
  final int? newWeight;
  final int? newRepetition;

  UpdateSetExercise({
    this.check,
    required this.setId,
    required this.exerciseId,
    this.exerciseSuperSetId,
    this.newWeight,
    this.newRepetition,
  });
}
