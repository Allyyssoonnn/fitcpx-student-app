import 'package:fitcpxaluno/src/models/workout_history_model.dart';
import 'package:fitcpxaluno/src/screens/view_workout_history.dart';
import 'package:fitcpxaluno/src/services/workout_service.dart';
import 'package:fitcpxaluno/src/widgets/backgroundAlert.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutHistory extends StatelessWidget {
  final workoutService = WorkoutService();

  WorkoutHistory({super.key});

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

  Widget build(BuildContext context) {
    return CustomScaffold(
      navigationBar: const CupertinoNavigationBar(
        border: null,
        middle: Text('Histórico de treinos'),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Text(
              'Treinos',
              style: TextStyle(
                color: CupertinoColors.label.resolveFrom(context),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                height: 0.5,
                color: CupertinoColors.separator.resolveFrom(context),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<WorkoutHistoryModel>>(
                initialData: [],
                future: workoutService.getWorkoutHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar os dados'));
                  }

                  final workouts = snapshot.data!;

                  if (workouts.isEmpty) {
                    return BackgroundAlert(
                      text: "Nenhum treino encontrado",
                      icon: FontAwesomeIcons.dumbbell,
                    );
                  }

                  return ListView.builder(
                    itemCount: workouts.length,
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 40),
                    itemBuilder: (context, index) {
                      final workout = workouts[index];

                      return CupertinoCard(
                        onTap: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ViewWorkoutHistory(
                              key: UniqueKey(),
                              workout: workout,
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
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  // children: [
                                  Text(
                                    workout.date,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      // fontSize: 16,
                                      fontSize: 14,
                                      color: CupertinoColors.label.resolveFrom(
                                        context,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    workout.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.label.resolveFrom(
                                        context,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    workout.timeRange,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.systemGreen,
                                    ),
                                  ),
                                  // ],
                                  // ),
                                  // Text(
                                  //   workout.date,
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.w600,
                                  //     // fontSize: 18,
                                  //     fontSize: 14,
                                  //     color: CupertinoColors.label.resolveFrom(
                                  //       context,
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Duração: ${_formatDuration(workout.duration)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.label.resolveFrom(
                                        context,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(height: 4),
                                  // Text(
                                  //   "ID: ${workout.id}",
                                  //   style: TextStyle(
                                  //     fontSize: 14,
                                  //     color: CupertinoColors.label.resolveFrom(
                                  //       context,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Icon(CupertinoIcons.chevron_right),
                          ],
                        ),
                      );
                    },
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
