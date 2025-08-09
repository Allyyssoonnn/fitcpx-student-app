import 'package:fitcpxaluno/src/widgets/welcome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Image.asset('assets/images/icon.png', height: 60),
                    Text('Bem-vindo de volta'),
                    Divider(),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    WelcomeButton(
                      icon: Icons.fitness_center,
                      buttonText: 'Meus treinos',
                      buttonDescription: 'Realizar treino de hoje',
                      onTap: () => context.go('/workouts'),
                    ),
                    WelcomeButton(
                      icon: Icons.add_chart,
                      buttonText: 'Minhas avaliações',
                      buttonDescription: 'Conferir sua evolução',
                      onTap: () => context.go('/fitness_assessments'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .slide(
          duration: 200.ms,
          curve: Curves.easeOut,
          begin: const Offset(0, 1),
          end: Offset.zero,
        )
        .fade(duration: 200.ms);
  }
}
