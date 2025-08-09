import 'dart:async';
import 'dart:convert';

import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/models/session_model.dart';
import 'package:fitcpxaluno/src/services/workout_service.dart';
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

  Future<void> _saveSessionPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session', jsonEncode(_session!.toJson()));
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

      emit(SessionLoaded(_session!));
    } catch (e) {
      emit(SessionInitial());
    }
  }

  Future<void> _startWorkout(
    StartWorkout event,
    Emitter<SessionState> emit,
  ) async {
    try {
      _session = event.session;

      await _saveSessionPrefs();
      emit(SessionLoaded(_session!));
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
      final savedTime = prefs.getInt('session_timer') ?? 0;
      final workoutService = WorkoutService();
      await workoutService.finishWorkout(
        session: _session,
        durationSeconds: savedTime,
      );

      await SharedPreferences.getInstance().then(
        (prefs) => prefs.remove('session'),
      );
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
          // Atualiza setsInfo do exercício principal
          final updatedSets = e.setsInfo
              ?.map((set) => set.copyWith(check: checked))
              .toList();

          // Se existir superSet, atualiza os setsInfo de cada exercício do superSet
          final updatedSuperSet = e.superSet.map((superExercise) {
            final updatedSuperSets = superExercise.setsInfo
                ?.map((set) => set.copyWith(check: checked))
                .toList();
            return superExercise.copyWith(setsInfo: updatedSuperSets);
          }).toList();

          return e.copyWith(
            checked: checked,
            setsInfo: updatedSets,
            superSet: updatedSuperSet,
          );
        }
        return e;
      }).toList();

      _session = _session!.copyWith(exercises: updatedExercises);

      await _saveSessionPrefs();

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
      final idExerciseSuperSet = event.exerciseSuperSetId;
      final checked = event.check;
      final exercises = _session!.exercises;
      final newWeight = event.newWeight;
      final newRepetition = event.newRepetition;

      if (exercises == null) {
        emit(SessionError('Sessão ou lista de exercícios não encontrada.'));
        return;
      }

      final updatedExercises = exercises.map((e) {
        if (e.cod_sessao_exercicio == idExercise) {
          if (idExerciseSuperSet != null) {
            // Caso seja SuperSet: atualiza o exercício dentro do superSet
            final updatedSuperSet = e.superSet.map((s) {
              if (s.cod_sessao_exercicio == idExerciseSuperSet) {
                final updatedSets = s.setsInfo?.map((set) {
                  if (set.id == event.setId) {
                    return set.copyWith(
                      check: checked,
                      neWeight: newWeight,
                      rep: newRepetition,
                    );
                  }
                  return set;
                }).toList();
                return s.copyWith(setsInfo: updatedSets);
              }
              return s;
            }).toList();

            return e.copyWith(checked: checked, superSet: updatedSuperSet);
          } else {
            // Exercício normal
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
        }
        return e;
      }).toList();

      _session = _session!.copyWith(exercises: updatedExercises);

      await _saveSessionPrefs();

      emit(SessionLoaded(_session!));
    } catch (e) {
      emit(SessionError('Error check exercise session $e'));
    }
  }
}
