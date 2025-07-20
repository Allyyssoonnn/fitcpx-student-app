import 'dart:async';

import 'package:fitcpxapp/src/blocs/exercise/exercise_bloc.dart';
import 'package:fitcpxapp/src/blocs/exercise/exercise_event.dart';
import 'package:fitcpxapp/src/blocs/exercise/exercise_state.dart';
import 'package:fitcpxapp/src/views/auth/exercise_info.dart';
import 'package:fitcpxapp/src/widgets/customScaffold.dart';
import 'package:fitcpxapp/src/widgets/exercises_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExercisesScreen extends StatefulWidget {
  @override
  State<ExercisesScreen> createState() => _ExercisesScreen();
}

class _ExercisesScreen extends State<ExercisesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  bool _isExisting = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: 200.ms, vsync: this);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  Future<void> _exitScreen() async {
    if (_isExisting) return;
    _isExisting = true;

    context.read<ExerciseBloc>().add(
      FilterExercises(query: '', musclesSelected: [], jointsSelected: []),
    );

    await _controller.reverse();
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          _exitScreen();
        }
      },
      child: CustomScaffold(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Pesquisar exercícios...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          onChanged: (value) {
                            if (_debounce?.isActive ?? false)
                              _debounce!.cancel();
                            _debounce = Timer(
                              const Duration(milliseconds: 300),
                              () {
                                context.read<ExerciseBloc>().add(
                                  FilterExercises(query: value),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          final filtersSelected = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return ExercisesFilter(
                                selectedJoints: context
                                    .read<ExerciseBloc>()
                                    .jointsSelected,
                                selectedMuscles: context
                                    .read<ExerciseBloc>()
                                    .musclesSelected,
                              );
                            },
                          );

                          if (filtersSelected != null) {
                            final muscles = filtersSelected['muscles'] ?? [];
                            final joints = filtersSelected['joints'] ?? [];

                            context.read<ExerciseBloc>().add(
                              FilterExercises(
                                musclesSelected: muscles,
                                jointsSelected: joints,
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Stack(
                            children: [
                              Icon(Icons.filter_list),
                              if (context
                                      .watch<ExerciseBloc>()
                                      .jointsSelected
                                      .isNotEmpty ||
                                  context
                                      .watch<ExerciseBloc>()
                                      .musclesSelected
                                      .isNotEmpty)
                                Positioned(
                                  right: 1,
                                  top: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<ExerciseBloc, ExerciseState>(
                      builder: (context, state) {
                        if (state is ExerciseLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is ExerciseLoaded) {
                          if (state.exercises.isEmpty) {
                            return const Center(
                              child: Text('Nenhum exercício encontrado'),
                            );
                          }

                          return Column(
                            children: [
                              Text(
                                '${state.exercises.length} exercícios encontrados',
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: state.exercises.length,
                                  itemBuilder: (context, index) {
                                    final exercise = state.exercises[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.black.withOpacity(
                                        0.1,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ExerciseInfoScreen(
                                                  key: UniqueKey(),
                                                  exercise: exercise,
                                                ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                child: Icon(
                                                  Icons.fitness_center,
                                                  size: 30,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      exercise.nome_exercicio,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.onSurface,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Código: ${exercise.cod_exercicio}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface
                                                            .withOpacity(0.6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Icon(
                                                Icons.chevron_right,
                                                color: Colors.grey,
                                                size: 28,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else if (state is ExerciseError) {
                          return Center(child: Text('Erro: ${state.message}'));
                        }

                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
