import 'package:fitcpxaluno/src/blocs/exercise/exercise_event.dart';
import 'package:fitcpxaluno/src/blocs/exercise/exercise_state.dart';
import 'package:fitcpxaluno/src/models/exercise_model.dart';
import 'package:fitcpxaluno/src/services/exercises_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExercisesService exercisesService;
  List<ExerciseModel> _allExercises = [];

  String _query = '';
  List<int> _musclesSelected = [];
  List<int> _jointsSelected = [];

  String get queryFilter => _query;
  List<int> get musclesSelected => _musclesSelected;
  List<int> get jointsSelected => _jointsSelected;

  ExerciseBloc(this.exercisesService) : super(ExerciseInitial()) {
    on<LoadExercises>(_onLoadExercises);
  }

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      final data = await exercisesService.getExercises();
      _allExercises = data
          .map((e) => ExerciseModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(ExerciseLoaded(_allExercises));
    } catch (e) {
      emit(ExerciseError('Error load exercises $e'));
    }
  }
}
