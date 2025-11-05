// lib/src/routes/app_routes.dart

import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_state.dart';
import 'package:fitcpxaluno/src/screens/session_exercises.dart';
import 'package:fitcpxaluno/src/screens/view_fitness_assessment.dart';
import 'package:fitcpxaluno/src/views/app/chat.dart';
import 'package:fitcpxaluno/src/views/app/fitness_assessments.dart';
import 'package:fitcpxaluno/src/views/app/home.dart';
import 'package:fitcpxaluno/src/views/app/settings.dart';
import 'package:fitcpxaluno/src/views/app/workouts.dart';
import 'package:fitcpxaluno/src/views/auth/login.dart';
import 'package:fitcpxaluno/src/widgets/custom_scaffold_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

// 1️⃣ Chaves de Navegação
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'ShellHome',
);
final _shellNavigatorAvaliacoesKey = GlobalKey<NavigatorState>(
  debugLabel: 'ShellAvaliacoes',
);
final _shellNavigatorTreinosKey = GlobalKey<NavigatorState>(
  debugLabel: 'ShellTreinos',
);
final _shellNavigatorChatKey = GlobalKey<NavigatorState>(
  debugLabel: 'ShellChat',
);
final _shellNavigatorContaKey = GlobalKey<NavigatorState>(
  debugLabel: 'ShellConta',
);

// 2️⃣ Função que cria o GoRouter
GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',

    // Autenticação
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final bool isLoggedIn = authBloc.state is AuthAuthenticated;
      final bool isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/home';
      return null;
    },

    // Rotas
    routes: [
      // --- Login ---
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),

      // --- Sessão de Exercício ---
      GoRoute(
        path: '/session-exercise',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => SessionExerciseScreen(),
      ),

      // 💡 NOVO: Rota de Visualização de Avaliação (Nível Superior)
      GoRoute(
        // Use o caminho absoluto completo
        path: '/fitness_assessments/view/:id',
        // 🔑 ESSENCIAL: Usa o navegador raiz. Isso esconde a barra de abas.
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ViewFitnessAssessment(idAssessment: id);
        },
      ),

      // --- Shell com Abas ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return CustomCupertinoScaffold(navigationShell: navigationShell);
        },
        branches: [
          // ABA 1: Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // ABA 2: Avaliações
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAvaliacoesKey,
            routes: [
              GoRoute(
                path: '/fitness_assessments',
                builder: (context, state) => FitnessAssessmentsScreen(),
                routes: [
                  // GoRoute(
                  //   path: 'view/:id', // relativo: /fitness_assessments/view/123
                  //   builder: (context, state) {
                  //     final id = int.parse(state.pathParameters['id']!);
                  //     return ViewFitnessAssessment(idAssessment: id);
                  //   },
                  // ),
                ],
              ),
            ],
          ),

          // ABA 3: Treinos
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTreinosKey,
            routes: [
              GoRoute(
                path: '/workouts',
                builder: (context, state) => WorkoutsScreen(),
                routes: [
                  GoRoute(
                    path: 'detalhes/:id', // relativo: /workouts/detalhes/456
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return Text(
                        'Detalhes do Treino $id',
                      ); // Substitua pelo DetalhesTreinoScreen
                    },
                  ),
                ],
              ),
            ],
          ),

          // ABA 4: Chat
          StatefulShellBranch(
            navigatorKey: _shellNavigatorChatKey,
            routes: [
              GoRoute(path: '/chat', builder: (context, state) => ChatScreen()),
            ],
          ),

          // ABA 5: Minha Conta
          StatefulShellBranch(
            navigatorKey: _shellNavigatorContaKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Classe auxiliar para refreshListenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}
