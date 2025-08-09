import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/screens/session_exercises.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BadgeSession extends StatelessWidget {
  BadgeSession({super.key});

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is SessionLoaded) {
          final session = state.session;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => SessionExerciseScreen(),
                    ),
                  );
                },
                child: Text(session.name ?? 'sessionName'),
              ),
              // Icon(Icons.notifications, size: 36),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                    // shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                  child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      if (state is RunningTimerState) {
                        return Center(
                          child: Text(
                            _formatDuration(state.secondsElapsed ?? 0),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      return const Center();
                    },
                  ),
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
