import 'package:fitcpxaluno/src/blocs/workout/workout_bloc.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_state.dart';
import 'package:fitcpxaluno/src/screens/sessions.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutsScreen extends StatelessWidget {
  WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Text('Meus treinos'),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 12),
            child: Container(height: 0.5, color: CupertinoColors.separator),
          ),
          BlocBuilder<WorkoutBloc, WorkoutState>(
            builder: (context, state) {
              if (state is WorkoutLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is WorkoutLoaded) {
                if (state.workouts.isEmpty) {
                  return const Center(child: Text('Nenhum treino encontrado'));
                }

                return Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.workouts.length,
                    itemBuilder: (context, index) {
                      final workout = state.workouts[index];
                      return CupertinoCard(
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                builder: (context) => SessionScreen(
                                  nameWorkout: workout.name,
                                  sessions: workout.sessions ?? [],
                                ),
                              ),
                            ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey4.withOpacity(
                                  0.3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                FontAwesomeIcons.dumbbell,
                                // size: 30,
                                size: 15,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    workout.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      // fontSize: 18,
                                      fontSize: 14,
                                      color: CupertinoColors.label.resolveFrom(
                                        context,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Nível: ${workout.level}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.label.resolveFrom(
                                        context,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${workout.qtdSessions} Sessões',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.label.resolveFrom(
                                        context,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(CupertinoIcons.chevron_right),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }

              return const Center(child: CupertinoActivityIndicator());
            },
          ),
        ],
      ),
    );
  }
}
