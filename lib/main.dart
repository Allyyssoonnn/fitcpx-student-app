import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxaluno/src/blocs/contract/contract_bloc.dart';
import 'package:fitcpxaluno/src/blocs/contract/contract_event.dart';
import 'package:fitcpxaluno/src/blocs/events/calendar_bloc.dart';
import 'package:fitcpxaluno/src/blocs/events/calendar_event.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_bloc.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_event.dart';
import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_bloc.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_event.dart';
import 'package:fitcpxaluno/src/core/dio_client.dart';
import 'package:fitcpxaluno/src/routes/app_routes2.dart';
import 'package:fitcpxaluno/src/services/calendar_service.dart';
import 'package:fitcpxaluno/src/services/contract_service.dart';
import 'package:fitcpxaluno/src/services/fitness_assessment_service.dart';
import 'package:fitcpxaluno/src/services/user_service.dart';
import 'package:fitcpxaluno/src/services/workout_service.dart';
import 'package:fitcpxaluno/src/utils/variables.dart';
import 'package:fitcpxaluno/src/widgets/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Mensagem recebida em background: ${message.messageId}");

  // Se quiser mostrar notificação local no background (Android cria auto para notification messages, mas para data messages precisa disso):
  await NotificationService().init();
  await NotificationService().showInstantNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await Variables.loadEnv(); // ← CARREGA ANTES DO DIO

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
    _initNotifications();

    // O Roteador é criado aqui, usando o AuthBloc
    appRouter = createRouter(authBloc);
  }

  void _initNotifications() async {
    await NotificationService().init();

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
      // _showNotification(message);

      if (message.notification != null) {
        NotificationService().showInstantNotification(message);
      }
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
          create: (_) => CalendarBloc(CalendarService())..add(LoadCalendar()),
        ),
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
        // Use BlocProvider.value para blocs que já foram instanciados fora do build (no initState)
        BlocProvider.value(value: authBloc),
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
