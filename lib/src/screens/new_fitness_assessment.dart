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

  // Adicione o dispose para evitar vazamento de memória!
  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _neckController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CustomScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Avaliação Física'), // Título mais curto
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => submit(context),
            child: const Text(
              "Salvar",
            ), // Texto as vezes é melhor que ícone para ação principal
          ),
        ),
        child: SafeArea(
          // Garante que não corte em telas com notch
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Bloco de Instrução Visual
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemFill.resolveFrom(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.info,
                        color: CupertinoColors.systemGrey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Para maior precisão, utilize uma fita métrica flexível e mantenha-a justa à pele, sem apertar.',
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // Fundo branco (ou preto no dark mode) para destacar a imagem
                      color: CupertinoColors.systemBackground.resolveFrom(
                        context,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CupertinoColors.systemGrey5.resolveFrom(context),
                        width: 1,
                      ),
                    ),
                    // ClipRRect garante que a imagem respeite as bordas arredondadas do Container
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          // A IMAGEM AQUI
                          Image.asset(
                            'assets/images/example_physical.png', // <--- VERIFIQUE O NOME DO ARQUIVO
                            fit: BoxFit.contain, // Ajusta a imagem sem cortar
                          ),
                          // Uma legenda opcional
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Guia de referência para as medidas",
                              style: TextStyle(
                                fontSize: 11,
                                color: CupertinoColors.label.resolveFrom(
                                  context,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Peso e Altura lado a lado
                Row(
                  children: [
                    Expanded(
                      child: FieldText(
                        label: "Peso",
                        placeHolder: "00,0",
                        suffix: "kg", // Novo parâmetro sugerido
                        controller: _weightController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FieldText(
                        label: "Altura",
                        placeHolder: "0,00",
                        suffix: "m", // Novo parâmetro sugerido
                        controller: _heightController,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 3. Demais campos
                FieldText(
                  label: "Pescoço",
                  placeHolder: "00,0",
                  suffix: "cm",
                  controller: _neckController,
                ),
                FieldText(
                  label: "Cintura",
                  placeHolder: "00,0",
                  suffix: "cm",
                  controller: _waistController,
                ),
                FieldText(
                  label: "Quadril",
                  placeHolder: "00,0",
                  suffix: "cm",
                  controller: _hipController,
                ),

                const SizedBox(height: 30),

                // 4. Botão Secundário (Opcional, mas melhora UX)
                // CupertinoButton.filled(
                //   child: const Text("Enviar Avaliação"),
                //   onPressed: () => submit(context),
                // ),
                // const SizedBox(height: 20),
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
  final String? suffix; // Adicionado
  final TextEditingController controller;

  const FieldText({
    super.key,
    required this.label,
    required this.placeHolder,
    this.suffix,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ), // Reduzi um pouco o vertical
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 6),
          CupertinoTextField(
            controller: controller,
            placeholder: placeHolder,
            suffix: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      suffix!,
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                  )
                : null,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.tertiarySystemFill.resolveFrom(
                context,
              ), // Fundo estilo iOS forms moderno
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
