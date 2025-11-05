import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
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
import 'package:fitcpxaluno/src/routes/app_routes2.dart';
import 'package:fitcpxaluno/src/services/contract_service.dart';
import 'package:fitcpxaluno/src/services/fitness_assessment_service.dart';
import 'package:fitcpxaluno/src/services/user_service.dart';
import 'package:fitcpxaluno/src/services/workout_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

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
  late GoRouter appRouter;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(UserService());
    DioClient.getInstance(authBloc);
    authBloc.checkLoginStatus();
    _initNotifications();

    // O Roteador é criado aqui, usando o AuthBloc
    appRouter = createRouter(authBloc);
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
        BlocProvider(create: (_) => TimerBloc()..add(StopTimer())),
        BlocProvider(create: (_) => authBloc),
      ],
      child: CupertinoApp.router(
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'FitCpx Aluno',
        theme: cupertinoThemeData,
        routerConfig: appRouter,
      ),
    );
  }
}

// Defina seu ThemeData Material para reutilização
final materialTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  // Mantenha seu override Cupertino aqui, caso algum widget Material
  // queira buscar um tema Cupertino (embora o CupertinoApp resolva melhor)
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: Color.fromRGBO(40, 167, 69, 1),
    barBackgroundColor: Color.fromRGBO(40, 167, 69, 1),
    scaffoldBackgroundColor: Color.fromRGBO(242, 245, 237, 1),
  ),
);

// Defina seu CupertinoThemeData para reutilização (se for diferente)
const cupertinoThemeData = CupertinoThemeData(
  // brightness: Brightness.light,
  primaryColor: Color.fromRGBO(40, 167, 69, 1),
  // barBackgroundColor: Color.fromRGBO(40, 167, 69, 1),
  // scaffoldBackgroundColor: CupertinoColors.systemBackground,
);
