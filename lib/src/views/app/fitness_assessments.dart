import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_bloc.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_state.dart';
import 'package:fitcpxaluno/src/screens/new_fitness_assessment.dart';
import 'package:fitcpxaluno/src/widgets/backgroundAlert.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class FitnessAssessmentsScreen extends StatelessWidget {
  FitnessAssessmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Text('Minhas avaliações'),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  height: 0.5,
                  color: CupertinoColors.separator.resolveFrom(context),
                ),
              ),
              BlocBuilder<FitnessAssessmentBloc, FitnessAssessmentState>(
                builder: (context, state) {
                  if (state is FitnessAssessmentLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (state is FitnessAssessmentError) {
                    return Center(child: Text(state.message));
                  } else if (state is FitnessAssessmentLoaded) {
                    if (state.fitnessAssessments.isEmpty) {
                      return BackgroundAlert(
                        text: "Nenhum avaliação encontrada",
                        icon: FontAwesomeIcons.chartLine,
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: state.fitnessAssessments.length,
                        itemBuilder: (context, index) {
                          final assessment = state.fitnessAssessments[index];
                          return CupertinoCard(
                            onTap: () => {
                              context.push(
                                "/fitness_assessments/view/${assessment.id}",
                              ),
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey4
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    FontAwesomeIcons.chartLine,
                                    // size: 30,
                                    size: 15,
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
                                          color: CupertinoColors.label
                                              .resolveFrom(context),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Peso: ${assessment.weight} kg',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.label
                                              .resolveFrom(context),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Altura: ${assessment.height} m',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.label
                                              .resolveFrom(context),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Gordura: ${assessment.bodyPercFat} %',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.label
                                              .resolveFrom(context),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Avaliador: ${assessment.trainer}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: CupertinoColors.label
                                              .resolveFrom(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(CupertinoIcons.chevron_right),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const Center(child: CupertinoActivityIndicator());
                },
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: CupertinoButton.filled(
              sizeStyle: CupertinoButtonSize.small,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(30),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) => NewFitnessAssessment(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesomeIcons.plus),
                    SizedBox(width: 8),
                    Text(
                      "Adicionar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
