import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    // Configuração do Android (ícone deve existir em android/app/src/main/res/drawable)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuração do iOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestAlertPermission: true,
          requestBadgePermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    // Solicita permissões específicas do Android 13+
    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Lógica ao clicar na notificação (opcional)
        print("Notificação clicada: ${details.payload}");
      },
    );
  }

  // --- MÉTODO NOVO: Usado pelo Firebase no main.dart ---
  Future<void> showInstantNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel', // ID do canal geral
            'Avisos Gerais', // Nome
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }

  // --- MÉTODO DO TIMER: Usado no IntervalScreen ---
  // --- Agendar Timer (Local) compatível com v19.5.0 ---
  Future<void> scheduleNotification(
    int seconds,
    String title,
    String body,
  ) async {
    final scheduledTime = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(seconds: seconds > 0 ? seconds : 1));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      12345,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_timer_channel_v2',
          'Timer de Treino',
          channelDescription: 'Avisa quando o intervalo de descanso acabou',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          fullScreenIntent: true, // Tenta abrir a tela mesmo bloqueada
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      // Na v19+, usamos apenas o modo de agendamento:
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
