import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Eventos
abstract class TimerEvent {}

class StartTimer extends TimerEvent {}

class StopTimer extends TimerEvent {}

class LoadTimer extends TimerEvent {}

class TickTimer extends TimerEvent {}

// Estados
abstract class TimerState {}

class RunningTimerState extends TimerState {
  final int secondsElapsed;

  RunningTimerState(this.secondsElapsed);
}

class StoppedTimerState extends TimerState {}

// Bloc
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;
  DateTime? _startTime; // Guardamos a referência do início na memória

  TimerBloc() : super(StoppedTimerState()) {
    on<StartTimer>(_startTimer);
    on<LoadTimer>(_onLoadSessionTimer);
    on<StopTimer>(_stopTimer);
    on<TickTimer>(_onTickTimer);
  }

  // O Tick agora não precisa ser async, ele apenas calcula a diferença na memória!
  void _onTickTimer(TickTimer event, Emitter<TimerState> emit) {
    if (_startTime != null) {
      final now = DateTime.now();
      final secondsElapsed = now.difference(_startTime!).inSeconds;
      emit(RunningTimerState(secondsElapsed));
    }
  }

  void _onLoadSessionTimer(LoadTimer event, Emitter<TimerState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString('session');
    final hasActiveWorkout = sessionJson != null;
    final startTimeMillis = prefs.getInt('session_start_time');

    // Correção: Se não houver treino ou tempo salvo, paramos e encerramos a função.
    if (!hasActiveWorkout || startTimeMillis == null) {
      add(StopTimer());
      return;
    }

    _startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);

    // Calcula os segundos exatos que passaram desde que o timer foi criado
    final secondsElapsed = DateTime.now().difference(_startTime!).inSeconds;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TickTimer());
    });

    emit(RunningTimerState(secondsElapsed));
  }

  void _startTimer(StartTimer event, Emitter<TimerState> emit) async {
    final prefs = await SharedPreferences.getInstance();

    // Registra o momento exato do início
    _startTime = DateTime.now();
    await prefs.setInt(
      'session_start_time',
      _startTime!.millisecondsSinceEpoch,
    );

    // Inicia o timer em loop
    _timer?.cancel(); // Limpa se já estiver rodando
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TickTimer());
    });

    emit(RunningTimerState(0));
  }

  void _stopTimer(StopTimer event, Emitter<TimerState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_start_time');

    _startTime = null;
    _timer?.cancel();
    _timer = null;

    emit(StoppedTimerState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
