import 'package:fitcpxaluno/src/models/exercise_model.dart';
import 'package:fitcpxaluno/src/screens/interval.dart';
import 'package:fitcpxaluno/src/screens/review_session.dart';
import 'package:fitcpxaluno/src/widgets/video_player.dart';
import 'package:flutter/material.dart';

class ExerciseInfoHeader extends StatefulWidget {
  const ExerciseInfoHeader({
    super.key,
    required this.exercise,
    this.exerciseSuperSet,
    required this.sessionExerciseLength,
    required this.indexExerciseSelected,
    required this.allExercises,
    required this.allSuperSets,
    required this.changeExercise,
  });

  final ExerciseModel? exerciseSuperSet;
  final ExerciseModel exercise;
  final int sessionExerciseLength;
  final int indexExerciseSelected;
  final List<ExerciseModel> allExercises;
  final List<ExerciseModel> allSuperSets;
  final Function(
    int newIndex,
    List<ExerciseModel> exercises,
    int? indexExerciseSuperSet,
  )
  changeExercise;

  @override
  State<ExerciseInfoHeader> createState() => _ExerciseInfoHeaderState();
}

class _ExerciseInfoHeaderState extends State<ExerciseInfoHeader> {
  late final List<ExerciseModel> allExercises;

  @override
  void initState() {
    allExercises = [widget.exercise, ...widget.exercise.superSet];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = (widget.exerciseSuperSet == null)
        ? widget.exercise
        : widget.exerciseSuperSet;

    return Column(
      children: [
        YoutubeWebViewPlayer(videoUrl: exercise!.url_exercicio ?? ''),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            exercise.nome_exercicio,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: (widget.indexExerciseSelected > 0)
                    ? () => widget.changeExercise(
                        widget.indexExerciseSelected - 1,
                        widget.allExercises,
                        null,
                      )
                    : null,
                icon: const Icon(Icons.arrow_back_ios),
                label: const Text('Anterior'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntervalScreen(
                        key: UniqueKey(),
                        maxSeconds: exercise.interval,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.alarm),
                label: const Text('Intervalo'),
              ),
              if (widget.indexExerciseSelected <
                  widget.sessionExerciseLength - 1)
                OutlinedButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed:
                      (widget.indexExerciseSelected <
                          widget.sessionExerciseLength - 1)
                      ? () => widget.changeExercise(
                          widget.indexExerciseSelected + 1,
                          widget.allExercises,
                          null,
                        )
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                  label: const Text('Próximo'),
                ),
              if (widget.indexExerciseSelected >=
                  widget.sessionExerciseLength - 1)
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReviewSessionScreen(key: UniqueKey()),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_chart_outlined),
                  label: const Text('Finalizar'),
                ),
            ],
          ),
        ),
        if (widget.allSuperSets.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: allExercises.length * 56,
              child: ListView.builder(
                itemCount: allExercises.length,
                itemBuilder: (context, index) {
                  final superSetExercise = allExercises[index];
                  final isSelected =
                      superSetExercise.cod_exercicio == exercise.cod_exercicio;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: FilterChip(
                        selected: isSelected,
                        onSelected: (_) {
                          widget.changeExercise(
                            widget.indexExerciseSelected,
                            allExercises,
                            index,
                          );
                        },
                        label: SizedBox(
                          width: double.infinity,
                          child: Text(
                            superSetExercise.nome_exercicio,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        const Divider(),
      ],
    );
  }
}
