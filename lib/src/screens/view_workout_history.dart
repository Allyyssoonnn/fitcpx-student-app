import 'package:fitcpxaluno/src/models/workout_history_model.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:fitcpxaluno/src/widgets/workout_share_sheet.dart';
import 'package:flutter/cupertino.dart';

class ViewWorkoutHistory extends StatefulWidget {
  final WorkoutHistoryModel workout;

  const ViewWorkoutHistory({super.key, required this.workout});

  @override
  State<ViewWorkoutHistory> createState() => _viewWorkoutHistory();
}

class _viewWorkoutHistory extends State<ViewWorkoutHistory> {
  String _formatDuration(int totalSeconds) {
    if (totalSeconds == 0) return "0 min";

    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    // Caso queira mostrar segundos também:
    // final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return "${hours}h ${minutes.toString().padLeft(2, '0')}min";
    } else {
      return "${minutes}min"; // ou "${minutes}min ${seconds}s"
    }
  }

  void _onShareTap() {
    // Exemplo de tempo: você deve pegar o tempo real do seu model se tiver
    // Se o WorkoutHistoryModel não tiver duração em segundos, você pode passar uma string pronta
    final durationString = _formatDuration(3600);

    WorkoutShareSheet.show(context, widget.workout, durationString);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        middle: Text('Resumo de treino'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _onShareTap, // <--- CHAMADA AQUI
          child: const Icon(CupertinoIcons.share),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.workout.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      // fontSize: 16,
                      fontSize: 14,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.workout.date,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      // fontSize: 16,
                      fontSize: 14,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.workout.timeRange,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.systemGreen,
                    ),
                  ),
                ],
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
                physics: BouncingScrollPhysics(),
                itemCount: widget.workout.exercises?.length,
                itemBuilder: (context, index) {
                  final exercise = widget.workout.exercises![index];

                  return CupertinoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: CupertinoColors.label.resolveFrom(
                                    context,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Container(
                                  height: 0.5,
                                  color: exercise.sets!.every((s) => s.done)
                                      ? CupertinoColors.activeGreen
                                      : CupertinoColors.destructiveRed,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: exercise.sets!.length,
                                itemBuilder: (context, index) {
                                  final set = exercise.sets![index];
                                  return Row(
                                    children: [
                                      Icon(
                                        set.done
                                            ? CupertinoIcons.check_mark
                                            : CupertinoIcons.xmark,
                                        color: set.done
                                            ? CupertinoColors.activeGreen
                                            : CupertinoColors.destructiveRed,
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: exercise.superSets.length,
                                itemBuilder: (context, index) {
                                  final superSet = exercise.superSets[index];
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
                                        '${index + 2} - ${superSet.name}',
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
                                              superSet.sets!.every(
                                                (s) => s.done,
                                              )
                                              ? CupertinoColors.activeGreen
                                              : CupertinoColors.destructiveRed,
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: superSet.sets!.length,
                                        itemBuilder: (context, index) {
                                          final set = superSet.sets![index];
                                          return Row(
                                            children: [
                                              Icon(
                                                set.done
                                                    ? CupertinoIcons.check_mark
                                                    : CupertinoIcons.xmark,
                                                color: set.done
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
                                    ],
                                  );
                                },
                              ),

                              // Text(
                              //   'ID: ${exercise.id}',
                              //   style: TextStyle(
                              //     fontSize: 10,
                              //     color: CupertinoColors.label.resolveFrom(
                              //       context,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
