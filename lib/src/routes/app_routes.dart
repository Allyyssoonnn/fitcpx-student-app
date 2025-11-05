import 'package:fitcpxaluno/src/views/app/chat.dart';
import 'package:fitcpxaluno/src/views/app/fitness_assessments.dart';
import 'package:fitcpxaluno/src/views/app/home.dart';
import 'package:fitcpxaluno/src/views/app/settings.dart';
import 'package:fitcpxaluno/src/views/app/workouts.dart';
import 'package:fitcpxaluno/src/widgets/custom_scaffold_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppRoutes extends StatelessWidget {
  const AppRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (context, state, child) => CustomCupertinoScaffold(
            child: child,
            currentLocation: state.matchedLocation ?? '',
          ),
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/fitness_assessments',
              builder: (context, state) => FitnessAssessmentsScreen(),
            ),
            GoRoute(
              path: '/workouts',
              builder: (context, state) => WorkoutsScreen(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => SettingsScreen(),
            ),
            GoRoute(path: '/chat', builder: (context, state) => ChatScreen()),
          ],
        ),
      ],
    );

    return CupertinoApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'FitCpx Aluno',
      theme: const CupertinoThemeData(
        primaryColor: Color.fromRGBO(40, 167, 69, 1), // verde padrão FitCpx
        scaffoldBackgroundColor: Color.fromRGBO(242, 245, 237, 1), // fundo
        barBackgroundColor: Color.fromRGBO(40, 167, 69, 1),
      ),
    );
  }
}
