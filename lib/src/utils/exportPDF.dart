import 'package:fitcpxaluno/src/models/fitness_assessment_model.dart';
import 'package:fitcpxaluno/src/utils/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> carregarHtmlDoServidor() async {
  final response = await http.get(
    Uri.parse('${Variables.url}/physicalAssessments/fitnessassessmentpdf'),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Falha ao carregar template HTML');
  }
}

Future<void> exportFullContentAsPdf(
  FitnessAssessmentModel assessment,
  BuildContext context,
) async {
  final prefs = await SharedPreferences.getInstance();
  try {
    final String? company = prefs.getString('company');
    final String? companyImg = prefs.getString('companyImg');

    // 1. Carregar o template HTML do asset
    // String htmlTemplate = await rootBundle.loadString(
    //   'assets/utils/templatePDF.html',
    // );
    String htmlTemplate = await carregarHtmlDoServidor();

    // 2. Substituir placeholders pelo conteúdo real do assessment
    String htmlContent = htmlTemplate
        .replaceAll('{{companyImg}}', companyImg ?? '')
        .replaceAll('<!-- {{trainer}} -->', assessment.trainer ?? '')
        .replaceAll('<!-- {{client}} -->', assessment.client ?? '')
        .replaceAll('<!-- {{height}} -->', assessment.height?.toString() ?? '')
        .replaceAll('<!-- {{weight}} -->', assessment.weight?.toString() ?? '')
        .replaceAll(
          '<!-- {{bodyFat}} -->',
          assessment.bodyFat?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{bodyFatPercentage}} -->',
          assessment.bodyPercFat?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{muscleMass}} -->',
          assessment.muscleMass?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{musclePerMass}} -->',
          assessment.musclePerMass?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{leanMass}} -->',
          assessment.leanMass?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{leanPercMass}} -->',
          assessment.leanPercMass?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{boneMass}} -->',
          assessment.boneMass?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{bonePercMass}} -->',
          assessment.bonePercMass?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{residualMass}} -->',
          assessment.residualMass?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{residualPercMass}} -->',
          assessment.residualPercMass?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{tricepsFold}} -->',
          assessment.tricepsFold?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{chestFold}} -->',
          assessment.chestFold?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{subscapularisFold}} -->',
          assessment.subscapularisFold?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{armpitFold}} -->',
          assessment.armpitFold?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{abdominal}} -->',
          assessment.abdominal?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{thighFold}} -->',
          assessment.thighFold?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{suprailiacFold}} -->',
          assessment.suprailiacFold?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{supraspinatusFold}} -->',
          assessment.supraspinatusFold?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{bicepsFold}} -->',
          assessment.bicepsFold?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{calfFold}} -->',
          assessment.calfFold?.toString() ?? '',
        )
        .replaceAll('<!-- {{neck}} -->', assessment.neck?.toString() ?? '')
        .replaceAll(
          '<!-- {{shoulder}} -->',
          assessment.shoulder?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{chestInhaled}} -->',
          assessment.chestInhaled?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{chestExhaled}} -->',
          assessment.chestExhaled?.toString() ?? '',
        )
        .replaceAll('<!-- {{waist}} -->', assessment.waist?.toString() ?? '')
        .replaceAll(
          '<!-- {{abdomen}} -->',
          assessment.abdomen?.toString() ?? '',
        )
        .replaceAll('<!-- {{hips}} -->', assessment.hips?.toString() ?? '')
        .replaceAll(
          '<!-- {{rightArmRelaxed}} -->',
          assessment.rightArmRelaxed?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{rightArmContracted}} -->',
          assessment.rightArmContracted?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{rightForearm}} -->',
          assessment.rightForearm?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{rightThigh}} -->',
          assessment.rightThigh?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{rightCalf}} -->',
          assessment.rightCalf?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{leftArmRelaxed}} -->',
          assessment.leftArmRelaxed?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{leftArmContracted}} -->',
          assessment.leftArmContracted?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{leftForearm}} -->',
          assessment.leftForearm?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{leftThigh}} -->',
          assessment.leftThigh?.toString() ?? '',
        )
        .replaceAll(
          '<!-- {{leftCalf}} -->',
          assessment.leftCalf?.toString() ?? '',
        );

    // 3. Gerar o PDF a partir do HTML atualizado
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return await Printing.convertHtml(format: format, html: htmlContent);
      },
    );
  } catch (e) {
    print('Erro ao exportar PDF: $e');
  }
}
