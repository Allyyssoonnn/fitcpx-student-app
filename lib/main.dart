import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_state.dart';
import 'package:fitcpxaluno/src/blocs/contract/contract_bloc.dart';
import 'package:fitcpxaluno/src/blocs/contract/contract_event.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_bloc.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_event.dart';
import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_bloc.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_event.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/routes/app_routes.dart';
import 'package:fitcpxaluno/src/services/contract_service.dart';
import 'package:fitcpxaluno/src/services/fitness_assessment_service.dart';
import 'package:fitcpxaluno/src/services/user_service.dart';
import 'package:fitcpxaluno/src/services/workout_service.dart';
import 'package:fitcpxaluno/src/views/auth/login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void _showNotification(RemoteMessage message) {
  final notification = message.notification;
  if (notification == null) return;

  flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel',
        'Default',
        importance: Importance.max,
        priority: Priority.high,
        icon: 'ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Mensagem recebida em background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthBloc authBloc;
  Key appKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(UserService());
    DioClient.getInstance(authBloc);
    authBloc.checkLoginStatus();
    _initNotifications();
  }

  void _initNotifications() async {
    // Solicitar permissão no iOS
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);
    print('Permissão: ${settings.authorizationStatus}');

    // Obter token FCM do dispositivo
    // String? token = await FirebaseMessaging.instance.getToken();
    // print("Token FCM: $token");

    // Quando app está em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Mensagem recebida em foreground: ${message.notification?.title}");
      // aqui você pode usar flutter_local_notifications para exibir
      _showNotification(message);
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("Token FCM atualizado: $newToken");
    });

    // Quando usuário clica na notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Usuário clicou na notificação: ${message.data}");
    });
  }

  void resetApp() {
    setState(() {
      // Troca a key para reinicializar o MultiBlocProvider e fechar os blocos antigos
      appKey = UniqueKey();

      // Cria um novo AuthBloc para a nova árvore
      authBloc = AuthBloc(UserService());
      DioClient.getInstance(authBloc);
      authBloc.checkLoginStatus();
    });
  }

  @override
  void dispose() {
    authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: appKey,
      providers: [
        BlocProvider(
          create: (_) => WorkoutBloc(WorkoutService())..add(LoadWorkouts()),
        ),
        BlocProvider(
          create: (_) =>
              FitnessAssessmentBloc(FitnessAssessmentService())
                ..add(LoadFitnessAssessment()),
        ),
        BlocProvider(
          create: (_) => ContractBloc(ContractService())..add(LoadContract()),
        ),
        BlocProvider(create: (_) => SessionBloc()..add(LoadSession())),
        BlocProvider(create: (_) => TimerBloc()..add(LoadTimer())),
        BlocProvider(create: (_) => authBloc),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FitCpx Aluno',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, state) {
            if (state is AuthUnAuthenticated) {
              resetApp();
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: authBloc,
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                // Pode disparar os eventos para recarregar dados aqui
                context.read<WorkoutBloc>().add(LoadWorkouts());
                context.read<FitnessAssessmentBloc>().add(
                  LoadFitnessAssessment(),
                );
                context.read<ContractBloc>().add(LoadContract());
                return const AppRoutes();
              } else {
                return const LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
