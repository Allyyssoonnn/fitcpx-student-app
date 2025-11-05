import 'package:fitcpxaluno/src/screens/my_contracts.dart';
import 'package:fitcpxaluno/src/widgets/welcome_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          decoration: BoxDecoration(
            color: CupertinoColors.secondarySystemBackground.resolveFrom(
              context,
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  children: [
                    Text('Bem-vindo de volta'),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                      child: Container(
                        height: 0.5,
                        color: CupertinoColors.separator.resolveFrom(context),
                      ),
                    ),
                    Column(
                      children: [
                        WelcomeButton(
                          icon: FontAwesomeIcons.dumbbell,
                          buttonText: 'Meus treinos',
                          buttonDescription: 'Realizar treino de hoje',
                          onTap: () => context.go('/workouts'),
                        ),
                        WelcomeButton(
                          icon: FontAwesomeIcons.chartLine,
                          buttonText: 'Minhas avaliações',
                          buttonDescription: 'Conferir sua evolução',
                          onTap: () => context.go('/fitness_assessments'),
                        ),
                        WelcomeButton(
                          icon: FontAwesomeIcons.moneyBillWave,
                          buttonText: 'Pagamentos',
                          buttonDescription: 'Conferir seus pagamentos',
                          onTap: () => {
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                builder: (context) => MyContracts(),
                              ),
                            ),
                          },
                        ),
                      ],
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
