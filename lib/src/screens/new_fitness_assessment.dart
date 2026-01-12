import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_bloc.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_event.dart';
import 'package:fitcpxaluno/src/services/fitness_assessment_service.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewFitnessAssessment extends StatefulWidget {
  const NewFitnessAssessment({super.key});

  @override
  State<NewFitnessAssessment> createState() => _NewFitnessAssessmentState();
}

class _NewFitnessAssessmentState extends State<NewFitnessAssessment> {
  late final _weightController = TextEditingController();
  late final _heightController = TextEditingController();
  late final _neckController = TextEditingController();
  late final _waistController = TextEditingController();
  late final _hipController = TextEditingController();

  void submit(BuildContext context) async {
    final weightText = _weightController.text.replaceAll(',', '.');
    final heightText = _heightController.text.replaceAll(',', '.');
    final neckText = _neckController.text.replaceAll(',', '.');
    final waistText = _waistController.text.replaceAll(',', '.');
    final hipText = _hipController.text.replaceAll(',', '.');

    if (neckText.isEmpty || waistText.isEmpty || hipText.isEmpty) {
      _showErrorDialog(context, "Preencha todos os campos");
      return;
    }

    final neckValue = double.tryParse(neckText);
    final waistValue = double.tryParse(waistText);
    final hipValue = double.tryParse(hipText);
    final weightValue = double.tryParse(weightText);
    final heightValue = double.tryParse(heightText);

    if (neckValue == null ||
        waistValue == null ||
        hipValue == null ||
        weightValue == null ||
        heightValue == null) {
      _showErrorDialog(context, "Insira valores numéricos válidos");
      return;
    }

    try {
      // 4. Call Service with Named Parameters
      await FitnessAssessmentService().sendFitnessAssessment(
        neck: neckValue,
        waist: waistValue,
        hip: hipValue,
        weight: weightValue,
        height: heightValue,
      );

      // 5. Check if widget is still mounted before using context
      if (!context.mounted) return;

      context.read<FitnessAssessmentBloc>().add(LoadFitnessAssessment());
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      _showErrorDialog(context, "Erro ao enviar avaliação: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Atenção"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CustomScaffold(
        navigationBar: const CupertinoNavigationBar(
          border: null,
          middle: Text('Avaliação física rápida'),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: CupertinoColors.secondarySystemBackground.resolveFrom(
                context,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Nova avaliação física',
                  style: TextStyle(
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    height: 0.5,
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text(
                    'Essa é uma avaliação física rápida para consultoria, para gerar sua avaliação precisaremos de 3 medidas de perímetros básicas: Braço, Abdômen e Panturrilha',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.systemGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     CupertinoButton.tinted(
                //       sizeStyle: CupertinoButtonSize.medium,
                //       onPressed: () {},
                //       child: Text("Como funciona?"),
                //     ),
                //   ],
                // ),
                FieldText(
                  label: "Peso",
                  placeHolder: "Ex: 73,20",
                  controller: _weightController,
                ),
                FieldText(
                  label: "Altura",
                  placeHolder: "Ex: 1,75",
                  controller: _heightController,
                ),
                FieldText(
                  label: "Perímetro do Pescoço",
                  placeHolder: "Ex: 36,90",
                  controller: _neckController,
                ),
                FieldText(
                  label: "Perímetro do Cintura",
                  placeHolder: "Ex: 83,70",
                  controller: _waistController,
                ),
                FieldText(
                  label: "Perímetro do Quadril",
                  placeHolder: "Ex: 101,70",
                  controller: _hipController,
                ),

                const SizedBox(height: 24),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton.filled(
                      sizeStyle: CupertinoButtonSize.medium,
                      onPressed: () => submit(context),
                      child: const Text("Confirmar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FieldText extends StatelessWidget {
  final String label;
  final String placeHolder;
  final TextEditingController controller;

  const FieldText({
    super.key,
    required this.label,
    required this.placeHolder,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // FIXED: Use EdgeInsets, not EdgeInsets
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns label to the left
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: controller,
            placeholder: placeHolder,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              border: Border.all(color: CupertinoColors.systemGrey4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
