import 'package:fitcpxapp/src/blocs/muscle/muscle_event.dart';
import 'package:fitcpxapp/src/blocs/muscle/muscle_state.dart';
import 'package:fitcpxapp/src/models/muscle_model.dart';
import 'package:fitcpxapp/src/services/muscle_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MuscleBloc extends Bloc<MuscleEvent, MuscleState> {
  final MusclesService muscleService;
  List<MuscleModel> _allMuscles = [];

  MuscleBloc(this.muscleService) : super(MuscleInitial()) {
    on<LoadMuscle>(_onLoadMuscles);
  }

  Future<void> _onLoadMuscles(
    LoadMuscle event,
    Emitter<MuscleState> emit,
  ) async {
    try {
      final data = await muscleService.getMuscles();
      _allMuscles = data
          .map((e) => MuscleModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(MuscleLoaded(_allMuscles));
    } catch (e) {
      emit(MuscleError('Error load exercises $e'));
    }
  }
}
