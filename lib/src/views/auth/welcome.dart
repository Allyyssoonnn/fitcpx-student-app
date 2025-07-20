import 'package:fitcpxapp/src/views/auth/exercises.dart';
import 'package:fitcpxapp/src/views/auth/login.dart';
import 'package:fitcpxapp/src/widgets/customScaffold.dart';
import 'package:fitcpxapp/src/widgets/welcome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Olá, visitante\n',
                        style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '\nComo deseja usar o app?',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fade(duration: 600.ms, curve: Curves.easeOut),
          Flexible(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          WelcomeButton(
                            icon: Icons.account_circle,
                            buttonText: 'Sou aluno',
                            buttonDescription:
                                'Meu professor/Academia usa FitCpx e quero usar meu acesso de aluno.',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            ),
                          ),
                          WelcomeButton(
                            showBadge: true,
                            icon: Icons.list_alt,
                            buttonText: 'Exercícios',
                            buttonDescription:
                                'Lista gratuita com 693 exercícios com informações e vídeos autorais.',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExercisesScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Developed by Lab Complex Dev LTDA - 59.820.051/0001-02',
                        style: TextStyle(fontSize: 10, color: Colors.black38),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .slide(
                duration: 600.ms,
                begin: const Offset(0, 1),
                end: Offset.zero,
              )
              .fade(duration: 600.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
