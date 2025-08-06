import 'dart:convert';

import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/models/session_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionModel? _session;

  SessionBloc() : super(SessionInitial()) {
    on<StartWorkout>(_startWorkout);
    on<LoadSession>(_onLoadSessions);
    on<CheckExerciseSession>(_checkExerciseSession);
    on<UpdateSetExercise>(_updateSetExercise);
    on<FinishWorkout>(_finishWorkout);
  }

  Future<void> _onLoadSessions(
    LoadSession event,
    Emitter<SessionState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('session');
      if (jsonString == null) return emit(SessionInitial());
      final session = SessionModel.fromJson(jsonDecode(jsonString));
      _session = session;
      emit(SessionLoaded(session));
    } catch (e) {
      emit(SessionInitial());
    }
  }

  Future<void> _startWorkout(
    StartWorkout event,
    Emitter<SessionState> emit,
  ) async {
    try {
      //Save session
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(event.session.toJson());
      await prefs.setString('session', jsonString);
      _session = event.session;
      //Dispatch event
      emit(SessionLoaded(event.session));
    } catch (e) {
      emit(SessionError('Error start workout $e'));
    }
  }

  Future<void> _finishWorkout(
    FinishWorkout event,
    Emitter<SessionState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('session');
      emit(SessionInitial());
    } catch (e) {
      emit(SessionError('Error finish workout $e'));
    }
  }

  Future<void> _checkExerciseSession(
    CheckExerciseSession event,
    Emitter<SessionState> emit,
  ) async {
    try {
      final idExercise = event.exerciseId;
      final checked = event.check;
      final exercises = _session!.exercises;

      if (exercises == null) {
        emit(SessionError('Sessão ou lista de exercícios não encontrada.'));
        return;
      }

      final updatedExercises = exercises.map((e) {
        if (e.cod_exercicio == idExercise) {
          final updatedSets = e.setsInfo
              ?.map((set) => set.copyWith(check: checked))
              .toList();
          return e.copyWith(checked: checked, setsInfo: updatedSets);
        }
        return e;
      }).toList();

      _session = _session!.copyWith(exercises: updatedExercises);

      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_session!.toJson());
      await prefs.setString('session', jsonString);

      emit(SessionLoaded(_session!));
    } catch (e) {
      emit(SessionError('Error check exercise session $e'));
    }
  }

  Future<void> _updateSetExercise(
    UpdateSetExercise event,
    Emitter<SessionState> emit,
  ) async {
    try {
      final idExercise = event.exerciseId;
      final checked = event.check;
      final exercises = _session!.exercises;
      final newWeight = event.newWeight;
      final newRepetition = event.newRepetition;

      if (exercises == null) {
        emit(SessionError('Sessão ou lista de exercícios não encontrada.'));
        return;
      }

      final updatedExercises = exercises.map((e) {
        if (e.cod_exercicio == idExercise) {
          final updatedSets = e.setsInfo?.map((set) {
            if (set.id == event.setId) {
              return set.copyWith(
                check: checked,
                neWeight: newWeight,
                rep: newRepetition,
              );
            }
            return set;
          }).toList();
          return e.copyWith(checked: checked, setsInfo: updatedSets);
        }
        return e;
      }).toList();

      _session = _session!.copyWith(exercises: updatedExercises);

      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_session!.toJson());
      await prefs.setString('session', jsonString);

      emit(SessionLoaded(_session!));
    } catch (e) {
      emit(SessionError('Error check exercise session $e'));
    }
  }
}
