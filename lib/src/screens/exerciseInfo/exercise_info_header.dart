import 'package:fitcpxaluno/src/models/exercise_model.dart';
import 'package:fitcpxaluno/src/screens/interval.dart';
import 'package:fitcpxaluno/src/screens/review_session.dart';
import 'package:fitcpxaluno/src/widgets/video_player.dart';
import 'package:flutter/cupertino.dart';
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
  // late final List<ExerciseModel> allExercises;

  @override
  // void initState() {
  // allExercises = [widget.exercise, ...widget.exercise.superSet];
  // super.initState();
  // }
  void showObservation() {
    // 1. Pega o exercício correto (mesma lógica do build)
    final exercise = (widget.exerciseSuperSet == null)
        ? widget.exercise
        : widget.exerciseSuperSet;

    // 2. Pega o texto da observação.
    // O botão só aparece se não for nulo, então podemos usar '!'
    final String observationText = exercise!.observacao_exercicio!;

    // 3. Exibe o modal
    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Observação'),
          content: SingleChildScrollView(child: Text(observationText)),
          actions: [
            CupertinoDialogAction(
              child: const Text('Fechar'),
              onPressed: () {
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
    final currentSetExercises = [widget.exercise, ...widget.exercise.superSet];

    final exercise = (widget.exerciseSuperSet == null)
        ? widget.exercise
        : widget.exerciseSuperSet;

    return Column(
      children: [
        YoutubeWebViewPlayer(
          key: ValueKey(exercise!.url_exercicio),
          videoUrl: exercise!.url_exercicio ?? '',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            exercise.nome_exercicio,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 12),
          child: Container(
            height: 0.5,
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton.tinted(
                color: CupertinoColors.activeGreen,
                onPressed: (widget.indexExerciseSelected > 0)
                    ? () => widget.changeExercise(
                        widget.indexExerciseSelected - 1,
                        widget.allExercises,
                        null,
                      )
                    : null,
                child: const Row(
                  spacing: 3,
                  children: [
                    Icon(CupertinoIcons.chevron_back),
                    Text(
                      'Anterior',
                      style: TextStyle(color: CupertinoColors.activeGreen),
                    ),
                  ],
                ),
              ),
              if (exercise?.observacao_exercicio != null)
                Badge(
                  label: Text("1"),
                  backgroundColor: CupertinoColors.activeGreen,
                  child: CupertinoButton.tinted(
                    color: CupertinoColors.activeGreen,
                    onPressed: showObservation,
                    child: const Icon(
                      Icons.message,
                      color: CupertinoColors.activeGreen,
                    ),
                  ),
                ),
              CupertinoButton.tinted(
                color: CupertinoColors.activeGreen,
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
                child: const Icon(
                  CupertinoIcons.alarm,
                  color: CupertinoColors.activeGreen,
                ),
              ),
              if (widget.indexExerciseSelected <
                  widget.sessionExerciseLength - 1)
                CupertinoButton.tinted(
                  color: CupertinoColors.activeGreen,
                  onPressed:
                      (widget.indexExerciseSelected <
                          widget.sessionExerciseLength - 1)
                      ? () => widget.changeExercise(
                          widget.indexExerciseSelected + 1,
                          widget.allExercises,
                          null,
                        )
                      : null,
                  child: Row(
                    spacing: 3,
                    children: [
                      const Text(
                        'Próximo',
                        style: TextStyle(color: CupertinoColors.activeGreen),
                      ),
                      const Icon(CupertinoIcons.chevron_forward),
                    ],
                  ),
                ),
              if (widget.indexExerciseSelected >=
                  widget.sessionExerciseLength - 1)
                CupertinoButton.tinted(
                  color: CupertinoColors.activeGreen,
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
                  child: Row(
                    children: [
                      const Text(
                        'Finalizar',
                        style: TextStyle(color: CupertinoColors.activeGreen),
                      ),
                      const Icon(CupertinoIcons.chart_bar),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 12),
          child: Container(
            height: 0.5,
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
        if (currentSetExercises.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // 1. Use o widget Wrap
            child: Wrap(
              spacing: 8.0, // Espaçamento horizontal entre os chips
              runSpacing: 4.0, // Espaçamento vertical entre as linhas
              children: List.generate(currentSetExercises.length + 1, (index) {
                if (index == 0) {
                  return FilterChip(
                    selected: false,
                    onSelected: null,
                    label: Text(
                      // Use a contagem de 'allExercises' para definir o texto
                      currentSetExercises.length == 2
                          ? "Bi-set"
                          : currentSetExercises.length == 3
                          ? "Tri-set"
                          : "Super-set",
                    ),
                  );
                }

                // 2. Gere a lista de chips
                final superSetExercise = currentSetExercises[index - 1];
                final isSelected =
                    superSetExercise.cod_exercicio == exercise.cod_exercicio;

                // 3. Retorne o FilterChip diretamente
                return FilterChip(
                  selected: isSelected,
                  onSelected: (_) {
                    widget.changeExercise(
                      widget.indexExerciseSelected,
                      currentSetExercises,
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
