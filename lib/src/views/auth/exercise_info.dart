import 'package:fitcpxaluno/src/blocs/session/session_bloc.dart';
import 'package:fitcpxaluno/src/blocs/session/session_event.dart';
import 'package:fitcpxaluno/src/blocs/session/session_state.dart';
import 'package:fitcpxaluno/src/models/sets_model.dart';
import 'package:fitcpxaluno/src/screens/interval.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:fitcpxaluno/src/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseInfoScreen extends StatefulWidget {
  const ExerciseInfoScreen({super.key, required this.exerciseIndex});

  final int exerciseIndex;

  @override
  State<ExerciseInfoScreen> createState() => _ExerciseInfoState();
}

class _ExerciseInfoState extends State<ExerciseInfoScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _cargaControllers = [];
  final List<TextEditingController> _repControllers = [];

  late int _exerciseIndex;

  @override
  void initState() {
    super.initState();
    _exerciseIndex = widget.exerciseIndex;
  }

  void _initializeControllers(SessionLoaded state) {
    final exercise = state.session.exercises![_exerciseIndex];
    final sets = exercise.setsInfo ?? [];

    // Se o número de controladores é diferente do número de sets, reinicializa
    if (_cargaControllers.length != sets.length) {
      for (var c in _cargaControllers) c.dispose();
      for (var c in _repControllers) c.dispose();
      _cargaControllers.clear();
      _repControllers.clear();

      for (final set in sets) {
        _cargaControllers.add(
          TextEditingController(text: set.weight.toString()),
        );
        _repControllers.add(
          TextEditingController(text: set.repetition.toString()),
        );
      }
    }
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

  void _changeExercise(int newIndex, SessionLoaded state) {
    setState(() {
      _exerciseIndex = newIndex;
      _cargaControllers.clear();
      _repControllers.clear();
    });

    _initializeControllers(state);
  }

  Widget _buildExerciseContent(SessionLoaded state) {
    final exercise = state.session.exercises![_exerciseIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YoutubeWebViewPlayer(videoUrl: exercise.url_exercicio ?? ''),
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
                onPressed: (_exerciseIndex > 0)
                    ? () => _changeExercise(_exerciseIndex - 1, state)
                    : null,
                icon: const Icon(Icons.arrow_back_ios),
                label: const Text('Anterior'),
              ),
              // Chip(
              //   avatar: exercise.setsInfo!.every((s) => s.checked)
              //       ? Icon(Icons.check_circle, color: Colors.green, size: 18)
              //       : Icon(Icons.close, color: Colors.redAccent, size: 18),
              //   label: Text(
              //     exercise.setsInfo!.every((s) => s.checked)
              //         ? "Concluído"
              //         : "Pendente",
              //     style: TextStyle(
              //       color: exercise.setsInfo!.every((s) => s.checked)
              //           ? Colors.green
              //           : Colors.redAccent,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntervalScreen(key: UniqueKey()),
                    ),
                  );
                },
                icon: const Icon(Icons.alarm),
                label: Text('Intervalo'),
              ),
              if (_exerciseIndex < state.session.exercises!.length - 1)
                OutlinedButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed:
                      (_exerciseIndex < state.session.exercises!.length - 1)
                      ? () => _changeExercise(_exerciseIndex + 1, state)
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                  label: const Text('Próximo'),
                ),
              if (_exerciseIndex >= state.session.exercises!.length - 1)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_chart_outlined),
                  label: const Text('Finalizar'),
                ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: BlocBuilder<SessionBloc, SessionState>(
            builder: (context, state) {
              if (state is SessionError) {
                return Center(child: Text('Erro ${state.message}'));
              } else if (state is SessionInitial) {
                return const Center(child: Text('Sessão não carregada'));
              } else if (state is SessionLoaded) {
                List<SetsModel> sets = exercise.setsInfo!;

                if (sets.isEmpty) {
                  return Center(child: Text('Não carregou os sets'));
                }

                return ListView.builder(
                  itemCount: sets.length,
                  itemBuilder: (context, index) {
                    SetsModel set = sets[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${index + 1}ª Série',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Text('Carga', style: TextStyle(fontSize: 10)),
                                Text(
                                  'Repetição',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _cargaControllers[index],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                      hintText: 'Carga',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      context.read<SessionBloc>().add(
                                        UpdateSetExercise(
                                          newWeight: int.tryParse(value) ?? 0,
                                          exerciseId: exercise.cod_exercicio,
                                          setId: set.id,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: _repControllers[index],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                      hintText: 'Rep.',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      context.read<SessionBloc>().add(
                                        UpdateSetExercise(
                                          newRepetition:
                                              int.tryParse(value) ?? 0,
                                          exerciseId: exercise.cod_exercicio,
                                          setId: set.id,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Switch(
                                  value: set.checked,
                                  onChanged: (value) {
                                    context.read<SessionBloc>().add(
                                      UpdateSetExercise(
                                        check: value,
                                        exerciseId: exercise.cod_exercicio,
                                        setId: set.id,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;

    return CustomScaffold(
      child: Container(
        width: double.infinity,
        height: mediaHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
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
              _initializeControllers(state);

              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: _buildExerciseContent(state),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
