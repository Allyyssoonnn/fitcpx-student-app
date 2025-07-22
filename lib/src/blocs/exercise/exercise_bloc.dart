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
    on<FilterExercises>(_onFilterExercises);
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

  void _onFilterExercises(FilterExercises event, Emitter<ExerciseState> emit) {
    if (event.query != null) _query = event.query!;
    if (event.musclesSelected != null)
      _musclesSelected = event.musclesSelected!;
    if (event.jointsSelected != null) _jointsSelected = event.jointsSelected!;

    bool matchesAnyGroup(List<int?> groups, List<int> selected) {
      return selected.isEmpty ||
          groups.any((g) => g != null && selected.contains(g));
    }

    final filtered = _allExercises.where((ex) {
      final matchesQuery = ex.nome_exercicio.toLowerCase().contains(
        _query.toLowerCase(),
      );

      final matchesMuscles = matchesAnyGroup([
        ex.cod_grupo_exercicio_1,
        ex.cod_grupo_exercicio_2,
        ex.cod_grupo_exercicio_3,
        // ex.cod_grupo_exercicio_4,
        // ...
      ], _musclesSelected);

      final matchesJoints =
          _jointsSelected.isEmpty ||
          [
            ex.cod_articulacao_1,
            ex.cod_articulacao_2,
            ex.cod_articulacao_3,
          ].any((j) => j != null && _jointsSelected.contains(j));

      return matchesQuery && matchesMuscles && matchesJoints;
    }).toList();

    emit(ExerciseLoaded(filtered));
  }
}
