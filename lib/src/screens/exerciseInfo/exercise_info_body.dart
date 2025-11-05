import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/models/exercise_model.dart';
import 'package:fitcpxaluno/src/models/sets_model.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseInfoBody extends StatefulWidget {
  const ExerciseInfoBody({
    super.key,
    required this.sets,
    required this.exercise,
    this.exerciseSuperSet,
  });
  final ExerciseModel? exerciseSuperSet;
  final List<SetsModel> sets;
  final ExerciseModel exercise;

  @override
  State<ExerciseInfoBody> createState() => _ExerciseInfoBodyState();
}

class _ExerciseInfoBodyState extends State<ExerciseInfoBody> {
  final List<TextEditingController> _cargaControllers = [];
  final List<TextEditingController> _repControllers = [];
  List<bool> _checkedList = [];

  void _initializeControllers() {
    final exercise = widget.exercise;
    final exerciseSuperSet = widget.exerciseSuperSet;
    final sets = exerciseSuperSet?.setsInfo ?? exercise.setsInfo ?? [];

    if (_cargaControllers.length != sets.length) {
      for (var c in _cargaControllers) {
        c.dispose();
      }
      for (var c in _repControllers) {
        c.dispose();
      }
      _cargaControllers.clear();
      _repControllers.clear();
      _checkedList.clear();

      for (final set in sets) {
        _cargaControllers.add(
          TextEditingController(text: set.weight.toString()),
        );
        _repControllers.add(
          TextEditingController(text: set.repetition.toString()),
        );
        _checkedList.add(set.checked);
      }
    } else {
      for (int i = 0; i < sets.length; i++) {
        _cargaControllers[i].text = sets[i].weight.toString();
        _repControllers[i].text = sets[i].repetition.toString();
        _checkedList[i] = sets[i].checked;
      }
    }
  }

  @override
  void didUpdateWidget(covariant ExerciseInfoBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.cod_exercicio != widget.exercise.cod_exercicio ||
        oldWidget.exerciseSuperSet?.cod_exercicio !=
            widget.exerciseSuperSet?.cod_exercicio) {
      _initializeControllers();
    }
  }

  @override
  void initState() {
    _initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _cargaControllers) {
      controller.dispose();
    }
    for (var controller in _repControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.sets.length,
        itemBuilder: (context, index) {
          final set = widget.sets[index];

          return CupertinoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho da série
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${index + 1}ª Série',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                    ),
                    CupertinoSwitch(
                      key: ValueKey(set.id),
                      value: _checkedList[index],
                      onChanged: (value) {
                        setState(() => _checkedList[index] = value);
                        context.read<SessionBloc>().add(
                          UpdateSetExercise(
                            check: value,
                            exerciseId: widget.exercise.cod_sessao_exercicio,
                            setId: set.id,
                            exerciseSuperSetId:
                                widget.exerciseSuperSet?.cod_sessao_exercicio,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                  child: Container(
                    height: 0.5,
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                ),
                // Títulos dos campos
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Carga (kg)',
                        style: TextStyle(
                          fontSize: 11,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Repetição',
                        style: TextStyle(
                          fontSize: 11,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Campos de entrada
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _cargaControllers[index],
                        keyboardType: TextInputType.number,
                        placeholder: 'Ex: 40',
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          context.read<SessionBloc>().add(
                            UpdateSetExercise(
                              newWeight: int.tryParse(value) ?? 0,
                              exerciseId: widget.exercise.cod_sessao_exercicio,
                              setId: set.id,
                              exerciseSuperSetId:
                                  widget.exerciseSuperSet?.cod_sessao_exercicio,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CupertinoTextField(
                        controller: _repControllers[index],
                        keyboardType: TextInputType.number,
                        placeholder: 'Ex: 12',
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          context.read<SessionBloc>().add(
                            UpdateSetExercise(
                              newRepetition: int.tryParse(value) ?? 0,
                              exerciseId: widget.exercise.cod_sessao_exercicio,
                              setId: set.id,
                              exerciseSuperSetId:
                                  widget.exerciseSuperSet?.cod_sessao_exercicio,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
