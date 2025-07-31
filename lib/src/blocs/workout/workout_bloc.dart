import 'package:fitcpxaluno/src/blocs/workout/workout_event.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_state.dart';
import 'package:fitcpxaluno/src/models/workout_model.dart';
import 'package:fitcpxaluno/src/services/workout_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutService workoutService;
  List<WorkoutModel> _allWorkouts = [];

  WorkoutBloc(this.workoutService) : super(WorkoutInitial()) {
    on<LoadWorkouts>(_onLoadWorkouts);
  }

  Future<void> _onLoadWorkouts(
    LoadWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id_client = prefs.getInt('id_client');

      if (id_client == null) {
        emit(WorkoutInitial());
        return;
      }

      final data = await workoutService.getWorkouts(id_client: id_client);

      _allWorkouts = data
          .map((e) => WorkoutModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(WorkoutLoaded(_allWorkouts));
    } catch (e) {
      emit(WorkoutError('Error load exercises $e'));
    }
  }
}
