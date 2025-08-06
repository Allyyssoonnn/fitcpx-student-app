import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_bloc.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_state.dart';
import 'package:fitcpxaluno/src/screens/view_fitness_assessment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FitnessAssessmentsScreen extends StatelessWidget {
  FitnessAssessmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Text('Minhas avaliações'),
          Divider(),
          BlocBuilder<FitnessAssessmentBloc, FitnessAssessmentState>(
            builder: (context, state) {
              if (state is FitnessAssessmentLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FitnessAssessmentError) {
                return Center(child: Text(state.message));
              } else if (state is FitnessAssessmentLoaded) {
                if (state.fitnessAssessments.isEmpty) {
                  return const Center(child: Text('Nenhum treino encontrado'));
                }

                return Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.fitnessAssessments.length,
                    itemBuilder: (context, index) {
                      final assessment = state.fitnessAssessments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () =>
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewFitnessAssessment(
                                    key: UniqueKey(),
                                    idAssessment: assessment.id,
                                    idClient: assessment.idClient,
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.add_chart_outlined,
                                    // size: 30,
                                    size: 15,
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
                                        assessment.date,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          // fontSize: 18,
                                          fontSize: 14,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Peso: ${assessment.weight} kg',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Altura: ${assessment.height} m',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Gordura: ${assessment.bodyPercFat} %',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Avaliador: ${assessment.trainer}',
                                        style: TextStyle(
                                          fontSize: 12,
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
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
