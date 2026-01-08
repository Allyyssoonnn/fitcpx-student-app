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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12, // Ajuste fino na fonte
              fontWeight: FontWeight.w500,
              color: CupertinoColors.label.resolveFrom(context),
            ),
            overflow: TextOverflow.ellipsis, // Evita quebra de linha feia
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 35,
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

        const SizedBox(height: 12),

        // Legenda que ocupa o espaço restante
        Wrap(
          spacing: 16.0, // Espaço horizontal entre itens
          runSpacing: 8.0, // Espaço vertical entre linhas
          children: [
            if (assessment.type == "completo")
              legendItem(
                Colors.blue,
                'Residual (${assessment.residualPercMass!.toStringAsFixed(2)}%)',
              ),
            legendItem(
              Colors.red,
              'Gordura (${assessment.bodyPercFat.toStringAsFixed(2)}%)',
            ),
            if (assessment.type == "completo")
              legendItem(
                Colors.green,
                'Muscular (${assessment.musclePerMass!.toStringAsFixed(2)}%)',
              ),
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
            const SizedBox(height: 8),
          ],
        ),
      ],
    );
  }
}
