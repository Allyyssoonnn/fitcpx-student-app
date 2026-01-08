import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fitcpxaluno/src/widgets/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Importe o seu serviço de notificação criado acima
// import 'path/to/notification_service.dart';

class IntervalScreen extends StatefulWidget {
  final int maxSeconds;

  const IntervalScreen({super.key, this.maxSeconds = 60});

  @override
  State<IntervalScreen> createState() => _IntervalScreenState();
}

class _IntervalScreenState extends State<IntervalScreen>
    with WidgetsBindingObserver {
  late int _remainingSeconds;
  late DateTime _endTime; // Chave para funcionar em background
  Timer? _timer; // Timer pode ser nulo
  bool _timeIsUp = false;
  bool _blink = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observa ciclo de vida do app

    // Configura o AudioPlayer para não respeitar modo silencioso do sistema (opcional)
    _audioPlayer.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.alarm, // Trata como alarme
          audioFocus: AndroidAudioFocus.gainTransient,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      ),
    );

    _remainingSeconds = widget.maxSeconds;

    // Define a hora exata que vai acabar
    _endTime = DateTime.now().add(Duration(seconds: widget.maxSeconds));

    // 1. Agenda a notificação do sistema para o futuro
    _scheduleSystemNotification();

    // 2. Inicia o timer visual
    _startVisualTimer();
  }

  void _scheduleSystemNotification() {
    _notificationService.scheduleNotification(
      widget.maxSeconds,
      "Tempo Esgotado!",
      "Seu intervalo de descanso acabou. Volte ao treino!",
    );
  }

  void _startVisualTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final now = DateTime.now();

      // Calcula quanto falta baseado na hora final, não em decremento simples
      final remaining = _endTime.difference(now).inSeconds;

      if (remaining >= 0) {
        // Só atualiza a tela se o segundo mudou para evitar rebuilds desnecessários
        if (remaining != _remainingSeconds) {
          setState(() {
            _remainingSeconds = remaining;
          });
        }
      } else {
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() async {
    _timer?.cancel();
    // Cancela notificação agendada para não duplicar se o app estiver aberto
    // _notificationService.cancelAll();

    if (!mounted) return;

    // Se o usuário estiver com a tela aberta (app em foreground), tocamos o audio player
    // e cancelamos a notificação para não virar bagunça.
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      _notificationService
          .cancelAll(); // Cancela notificação pois já estamos vendo
      playAlarm(); // Toca som via Flutter
      triggerMultipleHaptics();
    }
    // Se estiver em background, a notificação agendada vai explodir com som nativo.

    setState(() => _timeIsUp = true);

    // Timer do Pisca-Pisca (Visual)
    Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted || !_timeIsUp) {
        t.cancel();
      } else {
        setState(() => _blink = !_blink);
      }
    });

    triggerMultipleHaptics();
    playAlarm();
  }

  void playAlarm() async {
    try {
      // Configura para tocar mesmo se o app for para segundo plano neste momento
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      // Nota: O Android pode restringir áudio em background se não for um serviço de mídia.
      // A notificação local garantirá o som se o app estiver fechado.
      await _audioPlayer.play(AssetSource('audios/alarm.mp3'));
    } catch (e) {
      debugPrint('Erro ao tocar áudio: $e');
    }
  }

  void triggerMultipleHaptics() async {
    for (int i = 0; i < 3; i++) {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Sincronização extra caso o sistema mate o timer visual
    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      if (now.isAfter(_endTime) && !_timeIsUp) {
        _onTimeUp();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _audioPlayer.dispose();
    _notificationService.cancelAll(); // Cancela se o usuário sair antes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... Seu código de UI permanece idêntico ...
    final bgColor = _timeIsUp
        ? (_blink ? Colors.green : Colors.yellow)
        : const Color.fromRGBO(40, 167, 69, 1);

    final timeStr =
        '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: bgColor,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            bottom: false,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeStr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _audioPlayer.stop();
                      await _notificationService.cancelAll(); // Importante
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.stop, color: Colors.redAccent),
                    label: const Text(
                      'Parar',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
