import 'package:fitcpxapp/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxapp/src/blocs/auth/auth_state.dart';
import 'package:fitcpxapp/src/blocs/exercise/exercise_bloc.dart';
import 'package:fitcpxapp/src/blocs/exercise/exercise_event.dart';
import 'package:fitcpxapp/src/blocs/joint/joint_bloc.dart';
import 'package:fitcpxapp/src/blocs/joint/joint_event.dart';
import 'package:fitcpxapp/src/blocs/muscle/muscle_bloc.dart';
import 'package:fitcpxapp/src/blocs/muscle/muscle_event.dart';
import 'package:fitcpxapp/src/routes/app_routes.dart';
import 'package:fitcpxapp/src/services/exercises_service.dart';
import 'package:fitcpxapp/src/services/joints_service.dart';
import 'package:fitcpxapp/src/services/muscle_service.dart';
import 'package:fitcpxapp/src/services/user_service.dart';
import 'package:fitcpxapp/src/views/auth/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc = AuthBloc(UserService());

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExerciseBloc(ExercisesService())..add(LoadExercises()),
        ),
        BlocProvider(
          create: (_) => JointBloc(JointsService())..add(LoadJoint()),
        ),
        BlocProvider(
          create: (_) => MuscleBloc(MusclesService())..add(LoadMuscle()),
        ),
        BlocProvider(create: (_) => authBloc..checkLoginStatus()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FitCpx Aluno',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const AppRoutes();
            } else {
              return const WelcomeScreen();
            }
          },
        ),
      ),
    );
  }
}
