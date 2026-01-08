import 'package:fitcpxaluno/src/models/fitness_assessment_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatelessWidget {
  final FitnessAssessmentModel assessment;
  final BuildContext context;

  const MyPieChart({
    super.key,
    required this.assessment,
    required this.context,
  });

  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
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
                if (assessment.type == "completo")
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
                if (assessment.type != "completo")
                  PieChartSectionData(
                    value: assessment.leanPercMass,
                    title: '${assessment.leanPercMass}%',
                    color: Colors.green,
                    radius: 60,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                if (assessment.type == "completo")
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
                if (assessment.type == "completo")
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
              if (assessment.type == "completo")
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
              if (assessment.type == "completo")
                legendItem(
                  Colors.green,
                  'Muscular (${assessment.musclePerMass!.toStringAsFixed(2)}%)',
                ),
              const SizedBox(height: 8),
              if (assessment.type == "completo")
                legendItem(
                  Colors.grey,
                  'Óssea (${assessment.bonePercMass!.toStringAsFixed(2)}%)',
                ),
              if (assessment.type != "completo")
                legendItem(
                  Colors.green,
                  'Massa Magra (${assessment.leanPercMass!.toStringAsFixed(2)}%)',
                ),
            ],
          ),
        ),
      ],
    );
  }
}
