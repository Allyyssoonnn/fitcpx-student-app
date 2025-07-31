import 'package:fitcpxaluno/src/models/fitness_assessment_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatelessWidget {
  final FitnessAssessmentModel assessment;

  const MyPieChart({super.key, required this.assessment});

  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: color),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 170,
          height: 170,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: assessment.residualPercMass,
                  title: '${assessment.residualPercMass}%',
                  color: Colors.blue,
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                PieChartSectionData(
                  value: assessment.bodyPercFat,
                  title: '${assessment.bodyPercFat}%',
                  color: Colors.red,
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                PieChartSectionData(
                  value: assessment.musclePerMass,
                  title: '${assessment.musclePerMass}%',
                  color: Colors.green,
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                PieChartSectionData(
                  value: assessment.bonePercMass,
                  title: '${assessment.bonePercMass}%',
                  color: Colors.grey,
                  radius: 60,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Legenda que ocupa o espaço restante
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              legendItem(
                Colors.blue,
                'Residual (${assessment.residualPercMass!.toStringAsFixed(2)}%)',
              ),
              const SizedBox(height: 8),
              legendItem(
                Colors.red,
                'Gordura (${assessment.bodyPercFat.toStringAsFixed(2)}%)',
              ),
              const SizedBox(height: 8),
              legendItem(
                Colors.green,
                'Muscular (${assessment.musclePerMass!.toStringAsFixed(2)}%)',
              ),
              const SizedBox(height: 8),
              legendItem(
                Colors.grey,
                'Óssea (${assessment.bonePercMass!.toStringAsFixed(2)}%)',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
