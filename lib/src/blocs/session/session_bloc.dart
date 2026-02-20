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
    on<UpdateObservationExerciseSession>(_updateObservation);
    on<UpdateSetExercise>(_updateSetExercise);
    on<FinishWorkout>(_finishWorkout);
    on<CancelWorkout>(_cancelWorkout);
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
      // final savedTime = prefs.getInt('session_timer') ?? 0;
      final startTimeMillis = prefs.getInt('session_start_time');
      final _startTime = DateTime.fromMillisecondsSinceEpoch(
        startTimeMillis ?? 0,
      );
      final secondsElapsed = DateTime.now().difference(_startTime!).inSeconds;

      final workoutService = WorkoutService();
      await workoutService.finishWorkout(
        session: _session,
        durationSeconds: secondsElapsed,
      );

      await SharedPreferences.getInstance().then(
        (prefs) => prefs.remove('session'),
      );
      emit(SessionInitial());
    } catch (e) {
      emit(SessionError('Error finish workout $e'));
    }
  }

  Future<void> _cancelWorkout(
    CancelWorkout event,
    Emitter<SessionState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

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
      final setId = event.setId;

      if (exercises == null) {
        emit(SessionError('Sessão ou lista de exercícios não encontrada.'));
        return;
      }

      final updatedExercises = exercises.map((e) {
        if (e.cod_exercicio == idExercise) {
          if (setId != null) {
            // Aqui iteramos sobre os EXERCÍCIOS do super-set procurando pelo índice correto
            final updatedSuperSet = e.superSet.asMap().entries.map((entry) {
              final index = entry.key;
              final superExercise = entry.value;

              // Se este for o exercício do super-set que clicamos (pelo índice)
              if (index == setId) {
                // Marcamos TODAS as séries dele como true/false
                final updatedSets = superExercise.setsInfo
                    ?.map((s) => s.copyWith(check: checked))
                    .toList();

                return superExercise.copyWith(setsInfo: updatedSets);
              }

              // Se não for o índice clicado, retorna como estava
              return superExercise;
            }).toList();

            return e.copyWith(checked: checked, superSet: updatedSuperSet);
          }

          // Atualiza setsInfo do exercício principal
          final updatedSets = e.setsInfo
              ?.map((set) => set.copyWith(check: checked))
              .toList();

          // Se existir superSet, atualiza os setsInfo de cada exercício do superSet
          // final updatedSuperSet = e.superSet.map((superExercise) {
          //   final updatedSuperSets = superExercise.setsInfo
          //       ?.map((set) => set.copyWith(check: checked))
          //       .toList();
          //   return superExercise.copyWith(setsInfo: updatedSuperSets);
          // }).toList();

          return e.copyWith(
            checked: checked,
            setsInfo: updatedSets,
            // superSet: updatedSuperSet,
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

  Future<void> _updateObservation(
    UpdateObservationExerciseSession event,
    Emitter<SessionState> emit,
  ) async {
    try {
      final idExercise = event.exerciseId;
      final observation = event.observation;
      final exercises = _session!.exercises;
      final idSuperSetExercise = event.setId;

      if (exercises == null) {
        emit(SessionError('Sessão ou lista de exercícios não encontrada.'));
        return;
      }

      final updatedExercises = exercises.map((e) {
        // Verifica se é o exercício pai correto
        // RECOMENDAÇÃO: Use cod_sessao_exercicio se possível, é mais seguro que cod_exercicio
        if (e.cod_sessao_exercicio == idExercise) {
          if (idSuperSetExercise != null) {
            // Lógica para SuperSet
            final updatedSuperSet = e.superSet.map((superExercise) {
              // CORREÇÃO: Comparar ID com ID, não com Index
              if (superExercise.cod_sessao_exercicio == idSuperSetExercise) {
                // Certifique-se que seu copyWith atualiza a 'observacao_aluno'
                return superExercise.copyWith(observation: observation);
              }
              return superExercise;
            }).toList();

            return e.copyWith(superSet: updatedSuperSet);
          }

          // Lógica para exercício normal
          return e.copyWith(observation: observation);
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
