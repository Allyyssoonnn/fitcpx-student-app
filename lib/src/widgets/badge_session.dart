import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/screens/session_exercises.dart';
import 'package:flutter/cupertino.dart';
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
              CupertinoButton.filled(
                color: Color.fromRGBO(242, 245, 237, 1),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                      builder: (context) => SessionExerciseScreen(),
                    ),
                  );
                },
                child: Text(
                  session.name ?? 'sessionName',
                  style: TextStyle(color: CupertinoColors.darkBackgroundGray),
                ),
              ),
              // Icon(Icons.notifications, size: 36),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: CupertinoColors.destructiveRed,
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
                              color: CupertinoColors.white,
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
