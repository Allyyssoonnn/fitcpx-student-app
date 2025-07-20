import 'package:fitcpxapp/src/models/muscle_model.dart';

abstract class MuscleState {}

class MuscleInitial extends MuscleState {}

class MuscleLoading extends MuscleState {}

class MuscleLoaded extends MuscleState {
  final List<MuscleModel> muscles;

  MuscleLoaded(this.muscles);
}

class MuscleError extends MuscleState {
  final String message;

  MuscleError(this.message);
}
