abstract class ExerciseEvent {}

class LoadExercises extends ExerciseEvent {}

class FilterExercises extends ExerciseEvent {
  final String? query;
  final List<int>? musclesSelected;
  final List<int>? jointsSelected;

  FilterExercises({this.query, this.musclesSelected, this.jointsSelected});
}
