import 'package:fitcpxapp/src/blocs/joint/joint_bloc.dart';
import 'package:fitcpxapp/src/blocs/joint/joint_state.dart';
import 'package:fitcpxapp/src/blocs/muscle/muscle_bloc.dart';
import 'package:fitcpxapp/src/blocs/muscle/muscle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExercisesFilter extends StatefulWidget {
  final List<int> selectedJoints;
  final List<int> selectedMuscles;

  const ExercisesFilter({
    super.key,
    required this.selectedMuscles,
    required this.selectedJoints,
  });

  @override
  State<ExercisesFilter> createState() => _ExercisesFilterState();
}

class _ExercisesFilterState extends State<ExercisesFilter> {
  late List<int> _selectedJoints;
  late List<int> _selectedMuscles;

  @override
  void initState() {
    super.initState();
    _selectedMuscles = [...widget.selectedMuscles];
    _selectedJoints = [...widget.selectedJoints];
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grupos Musculares',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                BlocBuilder<MuscleBloc, MuscleState>(
                  builder: (context, state) {
                    if (state is MuscleLoaded) {
                      if (state.muscles.isEmpty) {
                        return const Text('Nenhuma articulação encontrada');
                      }

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.muscles.map((joint) {
                          final isSelected = _selectedMuscles.contains(
                            joint.cod_grupo_exercicio,
                          );
                          return FilterChip(
                            label: Text(joint.nome_grupo_exercicio),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedMuscles.add(
                                    joint.cod_grupo_exercicio,
                                  );
                                } else {
                                  _selectedMuscles.remove(
                                    joint.cod_grupo_exercicio,
                                  );
                                }
                              });
                            },
                          );
                        }).toList(),
                      );
                    }

                    if (state is JointLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Articulação',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                BlocBuilder<JointBloc, JointState>(
                  builder: (context, state) {
                    if (state is JointLoaded) {
                      if (state.joints.isEmpty) {
                        return const Text('Nenhuma articulação encontrada');
                      }

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.joints.map((joint) {
                          final isSelected = _selectedJoints.contains(
                            joint.cod_articulacao,
                          );
                          return FilterChip(
                            label: Text(joint.nome_articulacao),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedJoints.add(joint.cod_articulacao);
                                } else {
                                  _selectedJoints.remove(joint.cod_articulacao);
                                }
                              });
                            },
                          );
                        }).toList(),
                      );
                    }

                    if (state is JointLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                const SizedBox(height: 24),
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedJoints.clear();
                          _selectedMuscles.clear();
                        });
                      },
                      child: Text('Limpar Filtros'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.black87,
                      ),
                      onPressed: () {
                        Navigator.pop(context, {
                          'muscles': _selectedMuscles.toList(),
                          'joints': _selectedJoints.toList(),
                        });
                      },
                      child: const Text(
                        'Aplicar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
