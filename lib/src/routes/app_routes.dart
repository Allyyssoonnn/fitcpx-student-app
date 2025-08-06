import 'package:fitcpxaluno/src/views/app/fitness_assessments.dart';
import 'package:fitcpxaluno/src/views/app/home.dart';
import 'package:fitcpxaluno/src/views/app/settings.dart';
import 'package:fitcpxaluno/src/views/app/workouts.dart';
import 'package:fitcpxaluno/src/widgets/custom_scaffold_app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes extends StatelessWidget {
  const AppRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (context, state, child) => CustomScaffoldApp(
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
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'FitCpx App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
    );
  }
}
