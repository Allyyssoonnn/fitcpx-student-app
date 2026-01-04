import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/blocs/session_timer/sessionTimer.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_bloc.dart';
import 'package:fitcpxaluno/src/blocs/workout/workout_event.dart';
import 'package:fitcpxaluno/src/models/exercise_model.dart';
import 'package:fitcpxaluno/src/screens/exerciseInfo/exercise_info.dart';
import 'package:fitcpxaluno/src/screens/review_session.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionExerciseScreen extends StatelessWidget {
  SessionExerciseScreen({super.key});

  Future<void> _onCancelWorkout(BuildContext context) async {
    try {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Deseja Abandonar o treino?'),
          content: Text("Todos dados da sessão serão perdidos"),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              isDestructiveAction: true,
              child: const Text('Cancelar'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                context.read<SessionBloc>().add(CancelWorkout());
                context.read<TimerBloc>().add(StopTimer());
                context.read<WorkoutBloc>().add(LoadWorkouts());
                Navigator.pop(context);
                Navigator.pop(context);
              },
              isDefaultAction: true,
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      navigationBar: const CupertinoNavigationBar(
        border: null,
        middle: Text('Lista de exercícios'),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            if (state is SessionError) {
              return Center(
                child: Text('Erro ao carregar sessão ${state.message}'),
              );
            } else if (state is SessionInitial) {
              return Center(child: Text('Sessão não carregada'));
            } else if (state is SessionLoaded) {
              final session = state.session;

              return Column(
                children: [
                  Text(
                    session.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Exercícios',
                    style: TextStyle(
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                    child: Container(
                      height: 0.5,
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                  ),
                  if (session.exercises is List<ExerciseModel>)
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: session.exercises!.length,
                        itemBuilder: (context, index) {
                          final exercise = session.exercises![index];

                          return Column(
                            children: [
                              CupertinoCard(
                                border: exercise.superSet.isNotEmpty
                                    ? BoxBorder.fromLTRB(
                                        left: BorderSide(
                                          color: index % 2 == 0
                                              ? CupertinoColors.activeGreen
                                              : CupertinoColors.activeBlue,
                                        ),
                                      )
                                    : null,
                                onTap: !exercise.superSet.isNotEmpty
                                    ? () => Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              ExerciseInfoScreen(
                                                key: UniqueKey(),
                                                exerciseIndex: index,
                                                allExercises:
                                                    session!.exercises ?? [],
                                              ),
                                        ),
                                      )
                                    : null,
                                child: Column(
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () => Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              ExerciseInfoScreen(
                                                key: UniqueKey(),
                                                exerciseIndex: index,
                                                allExercises:
                                                    session!.exercises ?? [],
                                              ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${exercise.sequence} - ${exercise.nome_exercicio}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    // fontSize: 18,
                                                    fontSize: 14,
                                                    color: CupertinoColors.label
                                                        .resolveFrom(context),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${exercise.nSets}x${exercise.repetition} - ${exercise.weight}kg',
                                                  style: TextStyle(
                                                    color: CupertinoColors.label
                                                        .resolveFrom(context),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                if (exercise
                                                    .superSet
                                                    .isNotEmpty)
                                                  Text(
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: index % 2 == 0
                                                          ? CupertinoColors
                                                                .activeGreen
                                                          : CupertinoColors
                                                                .activeBlue,
                                                    ),
                                                    exercise.superSet.length ==
                                                            1
                                                        ? "Bi-set"
                                                        : exercise
                                                                  .superSet
                                                                  .length ==
                                                              2
                                                        ? "Tri-set"
                                                        : "Super-set",
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          CupertinoSwitch(
                                            value: exercise.setsInfo!.every(
                                              (s) => s.checked,
                                            ),
                                            onChanged: (bool value) {
                                              context.read<SessionBloc>().add(
                                                CheckExerciseSession(
                                                  value,
                                                  exercise.cod_exercicio,
                                                  null,
                                                ),
                                              );
                                            },
                                          ),
                                          const Icon(
                                            CupertinoIcons.chevron_right,
                                          ),
                                        ],
                                      ),
                                    ),

                                    if (exercise.superSet.isNotEmpty)
                                      ListView.builder(
                                        itemCount: exercise.superSet.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, indexSet) {
                                          final superSet =
                                              exercise.superSet[indexSet];

                                          return Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                child: Container(
                                                  height: 0.5,
                                                  color: CupertinoColors
                                                      .separator
                                                      .resolveFrom(context),
                                                ),
                                              ),
                                              CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () => Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        ExerciseInfoScreen(
                                                          key: UniqueKey(),
                                                          exerciseIndex: index,
                                                          allExercises:
                                                              session!
                                                                  .exercises ??
                                                              [],
                                                          setIndex:
                                                              indexSet + 1,
                                                        ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${exercise.sequence}.${indexSet + 2} - ${superSet.nome_exercicio}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              // fontSize: 18,
                                                              fontSize: 14,
                                                              color: CupertinoColors
                                                                  .label
                                                                  .resolveFrom(
                                                                    context,
                                                                  ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            '${superSet.nSets}x${superSet.repetition} - ${superSet.weight}kg',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: CupertinoColors
                                                                  .label
                                                                  .resolveFrom(
                                                                    context,
                                                                  ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    CupertinoSwitch(
                                                      value: superSet.setsInfo!
                                                          .every(
                                                            (s) => s.checked,
                                                          ),
                                                      onChanged: (bool value) {
                                                        context
                                                            .read<SessionBloc>()
                                                            .add(
                                                              CheckExerciseSession(
                                                                value,
                                                                exercise
                                                                    .cod_exercicio,
                                                                indexSet,
                                                              ),
                                                            );
                                                      },
                                                    ),
                                                    const Icon(
                                                      CupertinoIcons
                                                          .chevron_right,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton.tinted(
                        color: CupertinoColors.destructiveRed,
                        onPressed: () => _onCancelWorkout(context),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: CupertinoColors.destructiveRed,
                          ),
                        ),
                      ),
                      CupertinoButton.tinted(
                        color: CupertinoColors.activeGreen,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  ReviewSessionScreen(key: UniqueKey()),
                            ),
                          );
                        },
                        child: const Text(
                          'Finalizar',
                          style: TextStyle(color: CupertinoColors.activeGreen),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return Center(child: CupertinoActivityIndicator());
          },
        ),
      ),
    );
  }
}
