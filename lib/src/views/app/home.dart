import 'package:fitcpxaluno/src/blocs/auth/auth_bloc.dart';
import 'package:fitcpxaluno/src/blocs/auth/auth_state.dart';
import 'package:fitcpxaluno/src/blocs/events/calendar_bloc.dart';
import 'package:fitcpxaluno/src/blocs/events/calendar_state.dart';
import 'package:fitcpxaluno/src/screens/events.dart';
import 'package:fitcpxaluno/src/screens/my_contracts.dart';
import 'package:fitcpxaluno/src/widgets/userBlocked.dart';
import 'package:fitcpxaluno/src/widgets/welcome_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        height: 0.5,
                        color: CupertinoColors.separator.resolveFrom(context),
                      ),
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthAuthenticated) {
                          final user = state.user;
                          final bool isBlocked = user.status == "B";

                          return Column(
                            children: [
                              if (isBlocked)
                                UserBlockedWarning(
                                  message: user.status_description,
                                ),
                              if (!isBlocked) ...[
                                WelcomeButton(
                                  color: Colors.green,
                                  labelColor: Colors.black,
                                  icon: FontAwesomeIcons.dumbbell,
                                  buttonText: 'Treinar agora',
                                  buttonDescription: 'Realizar treino de hoje',
                                  onTap: () => context.go('/workouts'),
                                ),
                                WelcomeButton(
                                  icon: FontAwesomeIcons.chartLine,
                                  buttonText: 'Minhas avaliações',
                                  buttonDescription: 'Conferir sua evolução',
                                  onTap: () =>
                                      context.go('/fitness_assessments'),
                                ),
                              ],
                              WelcomeButton(
                                icon: FontAwesomeIcons.moneyBillWave,
                                buttonText: 'Pagamentos',
                                buttonDescription: 'Conferir seus pagamentos',
                                onTap: () => {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    CupertinoPageRoute(
                                      builder: (context) => MyContracts(),
                                    ),
                                  ),
                                },
                              ),
                              if (!isBlocked) ...[
                                BlocBuilder<CalendarBloc, CalendarState>(
                                  builder: (context, state) {
                                    final avaliableEventsToShow =
                                        (state is CalendarLoaded &&
                                            state.avaliableEvents.isNotEmpty)
                                        ? true
                                        : false;

                                    return WelcomeButton(
                                      disable: user.status == "B",
                                      messageBadge: avaliableEventsToShow
                                          ? "Eventos disponíveis"
                                          : null,
                                      icon: FontAwesomeIcons.calendar,
                                      buttonText: 'Agenda',
                                      buttonDescription: 'Conferir eventos',
                                      onTap: () => {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).push(
                                          CupertinoPageRoute(
                                            builder: (context) => Events(),
                                          ),
                                        ),
                                      },
                                    );
                                  },
                                ),
                              ],
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
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
