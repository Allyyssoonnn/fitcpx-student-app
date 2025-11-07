import 'dart:async';

import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/screens/session_exercises.dart';
import 'package:fitcpxaluno/src/services/chat_service.dart';
import 'package:fitcpxaluno/src/views/app/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CustomCupertinoScaffold extends StatefulWidget {
  const CustomCupertinoScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<CustomCupertinoScaffold> createState() =>
      _CustomCupertinoScaffoldState();
}

class _CustomCupertinoScaffoldState extends State<CustomCupertinoScaffold> {
  final chatService = ChatService();
  String unreadCount = "0";
  Timer? _timer;

  static const routes = [
    '/home',
    '/fitness_assessments',
    '/workouts',
    '/chat',
    '/settings',
  ];

  @override
  void initState() {
    super.initState();
    _loadUnreadMessages();

    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      _loadUnreadMessages();
    });
  }

  @override
  void dispose() {
    // 🔹 cancela o timer quando o widget é destruído
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadUnreadMessages() async {
    try {
      final count = await chatService.getUnreadMessages();
      if (!mounted) return;
      setState(() => unreadCount = count);
    } catch (e) {
      debugPrint('Erro ao buscar mensagens não lidas: $e');
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    // final index = routes.indexWhere((t) => currentLocation.startsWith(t));
    final index = widget.navigationShell.currentIndex;

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
              padding: const EdgeInsets.only(bottom: 50),
              child: widget.navigationShell,
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

                        if (i == 3) {
                          setState(() => unreadCount = "0");
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => ChatScreen(),
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

                        BottomNavigationBarItem(
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(FontAwesomeIcons.message, size: 20),
                              if (unreadCount != "0")
                                Positioned(
                                  right: -6,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.activeGreen,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 14,
                                      minHeight: 14,
                                    ),
                                    child: Text(
                                      unreadCount,
                                      style: const TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
