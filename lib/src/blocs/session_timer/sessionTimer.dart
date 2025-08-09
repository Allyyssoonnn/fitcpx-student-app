import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Event
abstract class TimerEvent {}

class StartTimer extends TimerEvent {}

class StopTimer extends TimerEvent {}

class LoadTimer extends TimerEvent {}

class TickTimer extends TimerEvent {}

//State
abstract class TimerState {}

class RunningTimerState extends TimerState {
  final int secondsElapsed;

  RunningTimerState(this.secondsElapsed);
}

class StoppedTimerState extends TimerState {}

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;
  int _secondsElapsed = 0;

  TimerBloc() : super(StoppedTimerState()) {
    on<StartTimer>(_startTimer);
    on<LoadTimer>(_onLoadSessionTimer);
    on<StopTimer>(_stopTimer);
    on<TickTimer>(_onTickTimer);
  }

  void _onTickTimer(TickTimer event, Emitter<TimerState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('session_timer', _secondsElapsed);
    emit(RunningTimerState(_secondsElapsed));
  }

  void _onLoadSessionTimer(LoadTimer event, Emitter<TimerState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final savedTime = prefs.getInt('session_timer') ?? 0;
    _secondsElapsed = savedTime;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _secondsElapsed++;
      add(TickTimer());
    });

    emit(RunningTimerState(_secondsElapsed));
  }

  void _startTimer(StartTimer event, Emitter<TimerState> emit) async {
    _secondsElapsed = 0;

    // Inicia o timer
    _timer?.cancel(); // limpa se já tiver rodando
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _secondsElapsed++;
      add(TickTimer());
    });

    //Não salva em Prefs pois o Tick faz isso a cada segundo
    emit(RunningTimerState(_secondsElapsed));
  }

  void _stopTimer(StopTimer event, Emitter<TimerState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('session_timer');

    _timer?.cancel();
    _timer = null;

    emit(StoppedTimerState());
  }
}
