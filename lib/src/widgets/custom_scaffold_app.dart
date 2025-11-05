import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/screens/session_exercises.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CustomCupertinoScaffold extends StatelessWidget {
  const CustomCupertinoScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const routes = [
    '/home',
    '/fitness_assessments',
    '/workouts',
    '/chat',
    '/settings',
  ];

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    // final index = routes.indexWhere((t) => currentLocation.startsWith(t));
    final index = navigationShell.currentIndex;

    return CupertinoPageScaffold(
      backgroundColor: const Color.fromRGBO(40, 167, 69, 1),
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color.fromRGBO(40, 167, 69, 1),
        border: null,
        middle: Text(
          'FitCpx Aluno',
          style: TextStyle(color: CupertinoColors.white),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: navigationShell ?? const SizedBox(),
            ),
          ),

          // Bottom + Badge
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ⬇️ BlocBuilder apenas na TabBar
                BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) {
                    bool isRunning = state is RunningTimerState;
                    String timeText = '';
                    if (isRunning) {
                      timeText = _formatDuration(state.secondsElapsed ?? 0);
                    }

                    return CupertinoTabBar(
                      backgroundColor: CupertinoColors.systemBackground
                          .resolveFrom(context),
                      currentIndex: index >= 0 ? index : 0,
                      onTap: (i) {
                        if (i == 2 && isRunning) {
                          // 👇 se treino está rolando, abre direto a tela do treino
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => SessionExerciseScreen(),
                            ),
                          );
                          return;
                        }

                        if (index != i) context.go(routes[i]);
                      },
                      items: [
                        const BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.house, size: 20),
                          label: 'Início',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.chartLine, size: 20),
                          label: 'Avaliações',
                        ),

                        // 🔥 Aqui o item muda dinamicamente
                        BottomNavigationBarItem(
                          icon: isRunning
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    timeText,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.activeGreen,
                                    ),
                                  ),
                                )
                              : const Icon(FontAwesomeIcons.dumbbell, size: 20),
                          label: isRunning ? 'Ativo' : 'Treinos',
                        ),

                        const BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.message, size: 20),
                          label: 'Chat',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.user, size: 20),
                          label: 'Minha conta',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
