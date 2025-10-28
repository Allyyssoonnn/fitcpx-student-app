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

  void showObservation() {
    // 1. Pega o exercício correto (mesma lógica do build)
    final exercise = (widget.exerciseSuperSet == null)
        ? widget.exercise
        : widget.exerciseSuperSet;

    // 2. Pega o texto da observação.
    // O botão só aparece se não for nulo, então podemos usar '!'
    final String observationText = exercise!.observacao_exercicio!;

    // 3. Exibe o modal
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Observação'),
          content: SingleChildScrollView(
            // 4. SingleChildScrollView para evitar overflow se o texto for longo
            child: Text(observationText),
          ),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                // 5. Fecha o modal
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
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
        const Divider(),
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
              if (exercise?.observacao_exercicio != null)
                Badge(
                  label: Text("1"),
                  backgroundColor: Colors.green,
                  child: IconButton.outlined(
                    onPressed: showObservation,
                    icon: const Icon(Icons.message),
                  ),
                ),
              IconButton.outlined(
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
        const Divider(),
        if (widget.allSuperSets.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // 1. Use o widget Wrap
            child: Wrap(
              spacing: 8.0, // Espaçamento horizontal entre os chips
              runSpacing: 4.0, // Espaçamento vertical entre as linhas
              children: List.generate(allExercises.length + 1, (index) {
                if (index == 0) {
                  return FilterChip(
                    selected: false,
                    onSelected: null,
                    label: Text(
                      // Use a contagem de 'allExercises' para definir o texto
                      allExercises.length == 2
                          ? "Bi-set"
                          : allExercises.length == 3
                          ? "Tri-set"
                          : "Super-set",
                    ),
                  );
                }

                // 2. Gere a lista de chips
                final superSetExercise = allExercises[index - 1];
                final isSelected =
                    superSetExercise.cod_exercicio == exercise.cod_exercicio;

                // 3. Retorne o FilterChip diretamente
                return FilterChip(
                  selected: isSelected,
                  onSelected: (_) {
                    widget.changeExercise(
                      widget.indexExerciseSelected,
                      allExercises,
                      index - 1,
                    );
                  },
                  label: Text(
                    // superSetExercise.nome_exercicio,
                    (index).toString(),
                  ),
                );
              }),
            ),
          ),
        // const Divider(),
      ],
    );
  }
}
