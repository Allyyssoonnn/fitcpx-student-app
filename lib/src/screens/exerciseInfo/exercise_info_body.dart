import 'dart:async';

import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/models/exercise_model.dart';
import 'package:fitcpxaluno/src/models/sets_model.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final List<TextEditingController> _intervalControllers = [];
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
      for (var c in _intervalControllers) {
        c.dispose();
      }
      _cargaControllers.clear();
      _repControllers.clear();
      _intervalControllers.clear();
      _checkedList.clear();

      for (final set in sets) {
        _cargaControllers.add(
          TextEditingController(text: set.weight.toString()),
        );
        _repControllers.add(
          TextEditingController(text: set.repetition.toString()),
        );
        _intervalControllers.add(
          TextEditingController(
            text:
                exerciseSuperSet?.interval.toString() ??
                exercise.interval.toString(),
          ),
        );
        _checkedList.add(set.checked);
      }
    } else {
      for (int i = 0; i < sets.length; i++) {
        _cargaControllers[i].text = sets[i].weight.toString();
        _repControllers[i].text = sets[i].repetition.toString();
        _intervalControllers[i].text =
            exerciseSuperSet?.interval.toString() ??
            exercise.interval.toString();
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

  void _openEditModal(int index, SetsModel set) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permite que o modal ocupe o tamanho necessário
      backgroundColor:
          Colors.transparent, // Transparente para usar o estilo Cupertino
      builder: (context) {
        return _EditSessionSheet(
          initialRep: double.tryParse(_repControllers[index].text) ?? 0,
          initialLoad: double.tryParse(_cargaControllers[index].text) ?? 0,
          onSave: (newRep, newLoad) {
            // 1. Atualiza visualmente os controladores
            setState(() {
              _repControllers[index].text = newRep.toStringAsFixed(
                0,
              ); // Reps geralmente sem decimal
              _cargaControllers[index].text = newLoad.toInt().toString();
            });

            context.read<SessionBloc>().add(
              UpdateSetExercise(
                newRepetition: newRep.toInt(),
                newWeight: newLoad.toInt(),
                exerciseId: widget.exercise.cod_sessao_exercicio,
                setId: set.id,
                exerciseSuperSetId:
                    widget.exerciseSuperSet?.cod_sessao_exercicio,
              ),
            );
          },
        );
      },
    );
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
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    height: 0.5,
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                ),

                // Campos de entrada
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardNumber(
                      text: _repControllers[index].text,
                      prefix: " rep",
                    ),
                    CardNumber(
                      text: _cargaControllers[index].text,
                      prefix: " kg",
                    ),
                    CardNumber(
                      text: _intervalControllers[index].text,
                      prefix: " seg",
                    ),
                    // Text("${_repControllers[index].text} rep"),
                    // Text("${_cargaControllers[index].text} kg"),
                    // Text("${_intervalControllers[index].text} seg"),
                    CupertinoButton.tinted(
                      sizeStyle: CupertinoButtonSize.small,
                      // child: Icon(CupertinoIcons.pen),
                      // onPressed: () {},
                      padding: EdgeInsets.zero,
                      minSize: 30,
                      child: const Icon(CupertinoIcons.pen, size: 20),
                      onPressed: () => _openEditModal(index, set),
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

class CardNumber extends StatelessWidget {
  final String text;
  final String prefix;

  CardNumber({required this.text, this.prefix = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            // Cor de fundo cinza claro (adapta ao modo escuro)
            // color: CupertinoColors.activeGreen.withOpacity(0.2),
            color: CupertinoColors.systemGrey6.resolveFrom(context),
            // color: Colors.lightGreen.shade50,
            borderRadius: BorderRadius.circular(6), // Bordas arredondadas
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
        Text(
          prefix,
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ],
    );
  }
}

// --- WIDGET DO MODAL DE EDIÇÃO ---
class _EditSessionSheet extends StatefulWidget {
  final double initialRep;
  final double initialLoad;
  final Function(double reps, double load) onSave;

  const _EditSessionSheet({
    required this.initialRep,
    required this.initialLoad,
    required this.onSave,
  });

  @override
  State<_EditSessionSheet> createState() => _EditSessionSheetState();
}

class _EditSessionSheetState extends State<_EditSessionSheet> {
  late double _currentRep;
  late double _currentLoad;
  Timer? _timer; // Timer para controlar o incremento contínuo

  @override
  void initState() {
    super.initState();
    _currentRep = widget.initialRep;
    _currentLoad = widget.initialLoad;
  }

  @override
  void dispose() {
    _stopTimer(); // Garante que o timer pare se fechar o modal
    super.dispose();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Lógica unificada para Repetições
  void _updateRep(double delta) {
    setState(() {
      _currentRep += delta;
      if (_currentRep < 0) _currentRep = 0;
    });
  }

  // Lógica unificada para Carga
  void _updateLoad(double delta) {
    setState(() {
      _currentLoad += delta;
      if (_currentLoad < 0) _currentLoad = 0;
    });
  }

  // Inicia o loop de incremento/decremento de 10 em 10
  void _startRapidChange({required bool isRep, required double delta}) {
    _stopTimer(); // Garante que não tem outro rodando

    // Primeiro incremento imediato ao segurar
    if (isRep)
      _updateRep(delta);
    else
      _updateLoad(delta);

    // Repete a cada 200ms
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (isRep) {
        _updateRep(delta);
      } else {
        _updateLoad(delta);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey4,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(bottom: 20),
            ),

            const Text(
              "Editar Série",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Controle de Repetições (Segurar muda ±10)
            _buildControlRow(
              label: "Repetições",
              value: _currentRep.toStringAsFixed(0),
              onTapMinus: () => _updateRep(-1),
              onTapPlus: () => _updateRep(1),
              onHoldMinus: () => _startRapidChange(isRep: true, delta: -10),
              onHoldPlus: () => _startRapidChange(isRep: true, delta: 10),
            ),

            const Divider(height: 30),

            // Controle de Carga (Segurar muda ±10)
            _buildControlRow(
              label: "Carga (kg)",
              value: _currentLoad.toInt().toString(),
              onTapMinus: () => _updateLoad(-1),
              onTapPlus: () => _updateLoad(1),
              onHoldMinus: () => _startRapidChange(isRep: false, delta: -10),
              onHoldPlus: () => _startRapidChange(isRep: false, delta: 10),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                child: const Text("Salvar"),
                onPressed: () {
                  widget.onSave(_currentRep, _currentLoad);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildControlRow({
    required String label,
    required String value,
    required VoidCallback onTapMinus,
    required VoidCallback onTapPlus,
    required VoidCallback onHoldMinus,
    required VoidCallback onHoldPlus,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            _HoldableCircleButton(
              icon: CupertinoIcons.minus,
              onTap: onTapMinus,
              onHoldStart: onHoldMinus,
              onHoldEnd: _stopTimer,
            ),
            SizedBox(
              width: 60,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _HoldableCircleButton(
              icon: CupertinoIcons.add,
              onTap: onTapPlus,
              onHoldStart: onHoldPlus,
              onHoldEnd: _stopTimer,
            ),
          ],
        ),
      ],
    );
  }
}

// --- BOTÃO CUSTOMIZADO COM GESTURE DETECTOR ---
class _HoldableCircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onHoldStart;
  final VoidCallback onHoldEnd;

  const _HoldableCircleButton({
    required this.icon,
    required this.onTap,
    required this.onHoldStart,
    required this.onHoldEnd,
  });

  @override
  State<_HoldableCircleButton> createState() => _HoldableCircleButtonState();
}

class _HoldableCircleButtonState extends State<_HoldableCircleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPressStart: (_) {
        setState(() => _isPressed = true);
        widget.onHoldStart();
      },
      onLongPressEnd: (_) {
        setState(() => _isPressed = false);
        widget.onHoldEnd();
      },
      onLongPressCancel: () {
        // Caso o usuário arraste o dedo para fora do botão
        setState(() => _isPressed = false);
        widget.onHoldEnd();
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _isPressed ? 0.4 : 1.0, // Efeito visual de clique do iOS
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey5.resolveFrom(context),
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, color: CupertinoColors.activeGreen),
        ),
      ),
    );
  }
}
