import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_state.dart';
import 'package:fitcpxaluno/src/blocs/exercise/exercise_bloc.dart';
import 'package:fitcpxaluno/src/blocs/exercise/exercise_event.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_bloc.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_event.dart';
import 'package:fitcpxaluno/src/blocs/joint/joint_bloc.dart';
import 'package:fitcpxaluno/src/blocs/joint/joint_event.dart';
import 'package:fitcpxaluno/src/blocs/muscle/muscle_bloc.dart';
import 'package:fitcpxaluno/src/blocs/muscle/muscle_event.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_bloc.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_event.dart';
import 'package:fitcpxaluno/src/routes/app_routes.dart';
import 'package:fitcpxaluno/src/services/exercises_service.dart';
import 'package:fitcpxaluno/src/services/fitness_assessment_service.dart';
import 'package:fitcpxaluno/src/services/joints_service.dart';
import 'package:fitcpxaluno/src/services/muscle_service.dart';
import 'package:fitcpxaluno/src/services/user_service.dart';
import 'package:fitcpxaluno/src/services/workout_service.dart';
import 'package:fitcpxaluno/src/views/auth/login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // debugPaintSizeEnabled = true;
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
        BlocProvider(
          create: (_) => WorkoutBloc(WorkoutService())..add(LoadWorkouts()),
        ),
        BlocProvider(
          create: (_) =>
              FitnessAssessmentBloc(FitnessAssessmentService())
                ..add(LoadFitnessAssessment()),
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
              context.read<WorkoutBloc>().add(LoadWorkouts());
              return const AppRoutes();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
