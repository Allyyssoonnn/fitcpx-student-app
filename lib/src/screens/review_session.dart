import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_bloc.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_event.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewSessionScreen extends StatelessWidget {
  const ReviewSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        middle: Text('Revisar treino'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            context.read<SessionBloc>().add(FinishWorkout());
            context.read<TimerBloc>().add(StopTimer());
            context.read<WorkoutBloc>().add(LoadWorkouts());
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text(
            "Confirmar",
          ), // Texto as vezes é melhor que ícone para ação principal
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            if (state is SessionError) {
              return Center(child: Text('Erro ${state.message}'));
            } else if (state is SessionInitial) {
              return const Center(child: Text('Sessão não carregada'));
            } else if (state is SessionLoaded) {
              final session = state.session;
              final exercises = session.exercises;

              return Column(
                children: [
                  Text(
                    session.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      height: 0.5,
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: exercises!.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return CupertinoCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise.nome_exercicio,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: CupertinoColors.label
                                            .resolveFrom(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Container(
                                        height: 0.5,
                                        color:
                                            exercise.setsInfo!.every(
                                              (s) => s.checked,
                                            )
                                            ? CupertinoColors.activeGreen
                                            : CupertinoColors.destructiveRed,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: exercise.setsInfo!.length,
                                      itemBuilder: (context, index) {
                                        final set = exercise.setsInfo![index];
                                        return Row(
                                          children: [
                                            Icon(
                                              set.checked
                                                  ? CupertinoIcons.check_mark
                                                  : CupertinoIcons.xmark,
                                              color: set.checked
                                                  ? CupertinoColors.activeGreen
                                                  : CupertinoColors
                                                        .destructiveRed,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${set.id}ª Série',
                                              style: TextStyle(
                                                color: CupertinoColors.label
                                                    .resolveFrom(context),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${set.repetition}x -',
                                              style: TextStyle(
                                                color: CupertinoColors.label
                                                    .resolveFrom(context),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${set.weight}kg',
                                              style: TextStyle(
                                                color: CupertinoColors.label
                                                    .resolveFrom(context),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: exercise.superSet.length,
                                      itemBuilder: (context, index) {
                                        final superSet =
                                            exercise.superSet[index];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              child: Container(
                                                height: 0.5,
                                                color: CupertinoColors.separator
                                                    .resolveFrom(context),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              '${index + 2} - ${superSet.nome_exercicio}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: CupertinoColors.label
                                                    .resolveFrom(context),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              child: Container(
                                                height: 0.5,
                                                color:
                                                    exercise.setsInfo!.every(
                                                      (s) => s.checked,
                                                    )
                                                    ? CupertinoColors
                                                          .activeGreen
                                                    : CupertinoColors
                                                          .destructiveRed,
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  superSet.setsInfo!.length,
                                              itemBuilder: (context, index) {
                                                final set =
                                                    superSet.setsInfo![index];
                                                return Row(
                                                  children: [
                                                    Icon(
                                                      set.checked
                                                          ? CupertinoIcons
                                                                .check_mark
                                                          : CupertinoIcons
                                                                .xmark,
                                                      color: set.checked
                                                          ? CupertinoColors
                                                                .activeGreen
                                                          : CupertinoColors
                                                                .destructiveRed,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      '${set.id}ª Série',
                                                      style: TextStyle(
                                                        color: CupertinoColors
                                                            .label
                                                            .resolveFrom(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      '${set.repetition}x -',
                                                      style: TextStyle(
                                                        color: CupertinoColors
                                                            .label
                                                            .resolveFrom(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      '${set.weight}kg',
                                                      style: TextStyle(
                                                        color: CupertinoColors
                                                            .label
                                                            .resolveFrom(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // CupertinoButton.tinted(
                  //   color: CupertinoColors.activeGreen,
                  //   onPressed: () {
                  //     context.read<SessionBloc>().add(FinishWorkout());
                  //     context.read<TimerBloc>().add(StopTimer());
                  //     context.read<WorkoutBloc>().add(LoadWorkouts());
                  //     Navigator.pop(context);
                  //     Navigator.pop(context);
                  //   },
                  //   child: const Text(
                  //     'Confirmar',
                  //     style: TextStyle(color: CupertinoColors.activeGreen),
                  //   ),
                  // ),
                ],
              );
            }

            return const Center(child: CupertinoActivityIndicator());
          },
        ),
      ),
    );
  }
}
