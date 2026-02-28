import 'dart:async';

import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_state.dart';
import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/models/user_model.dart';
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
    final shellIndex = widget.navigationShell.currentIndex;

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
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    UserModel? user;
                    if (state is AuthAuthenticated) user = state.user;

                    final bool isBlocked = user?.status == "B";

                    return BlocBuilder<TimerBloc, TimerState>(
                      builder: (context, timerState) {
                        bool isRunning = timerState is RunningTimerState;
                        String timeText = isRunning
                            ? _formatDuration(timerState.secondsElapsed ?? 0)
                            : '';

                        // 🔥 Criação dinâmica das abas com base no status do usuário
                        List<Map<String, dynamic>> availableTabs = [
                          {
                            'route': '/home',
                            'shellIndex': 0,
                            'item': const BottomNavigationBarItem(
                              icon: Icon(FontAwesomeIcons.house, size: 20),
                              label: 'Início',
                            ),
                          },
                        ];

                        if (!isBlocked) {
                          availableTabs.add({
                            'route': '/fitness_assessments',
                            'shellIndex': 1,
                            'item': const BottomNavigationBarItem(
                              icon: Icon(FontAwesomeIcons.chartLine, size: 20),
                              label: 'Avaliações',
                            ),
                          });

                          availableTabs.add({
                            'route': '/workouts',
                            'shellIndex': 2,
                            'isWorkout': true,
                            'item': BottomNavigationBarItem(
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
                                  : const Icon(
                                      FontAwesomeIcons.dumbbell,
                                      size: 20,
                                    ),
                              label: isRunning ? 'Ativo' : 'Treinos',
                            ),
                          });
                        }

                        availableTabs.add({
                          'route': '/chat',
                          'shellIndex': 3,
                          'isChat': true,
                          'item': BottomNavigationBarItem(
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
                        });

                        availableTabs.add({
                          'route': '/settings',
                          'shellIndex': 4,
                          'item': const BottomNavigationBarItem(
                            icon: Icon(FontAwesomeIcons.user, size: 20),
                            label: 'Minha conta',
                          ),
                        });

                        // 🔹 Mapeia o índice do GoRouter para o índice da visualização atual
                        int currentUIIndex = availableTabs.indexWhere(
                          (tab) => tab['shellIndex'] == shellIndex,
                        );
                        if (currentUIIndex == -1)
                          currentUIIndex = 0; // Fallback de segurança

                        return CupertinoTabBar(
                          backgroundColor: CupertinoColors.systemBackground
                              .resolveFrom(context),
                          currentIndex: currentUIIndex,
                          onTap: (i) {
                            final tab = availableTabs[i];

                            if (tab['isWorkout'] == true && isRunning) {
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute(
                                  builder: (context) => SessionExerciseScreen(),
                                ),
                              );
                              return;
                            }

                            if (tab['isChat'] == true) {
                              setState(() => unreadCount = "0");
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute(
                                  builder: (context) => ChatScreen(),
                                ),
                              );
                              return;
                            }

                            if (shellIndex != tab['shellIndex']) {
                              context.go(tab['route']);
                            }
                          },
                          items: availableTabs
                              .map((t) => t['item'] as BottomNavigationBarItem)
                              .toList(),
                        );
                      },
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
