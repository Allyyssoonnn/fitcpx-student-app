import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntervalScreen extends StatefulWidget {
  final int maxSeconds;

  const IntervalScreen({super.key, this.maxSeconds = 60});

  @override
  State<IntervalScreen> createState() => _IntervalScreenState();
}

class _IntervalScreenState extends State<IntervalScreen> {
  late int _remainingSeconds;
  late Timer _timer;
  bool _timeIsUp = false;
  bool _blink = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.maxSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() async {
    _timer.cancel();

    setState(() => _timeIsUp = true);

    Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!_timeIsUp) {
        t.cancel();
      } else {
        setState(() => _blink = !_blink);
      }
    });

    triggerMultipleHaptics();
    playAlarm();
  }

  void playAlarm() async {
    // await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // await _audioPlayer.play(AssetSource('audios/alarm.mp3'));
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('audios/alarm.mp3'));
    } catch (e) {
      print('Erro ao tocar áudio: $e');
    }
    // await _audioPlayer.play(AssetSource('audio/alarm.mp3'));
  }

  void triggerMultipleHaptics() async {
    for (int i = 0; i < 3; i++) {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    _timeIsUp = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.stop, color: Colors.redAccent),
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
