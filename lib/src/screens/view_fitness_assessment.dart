import 'package:fitcpxaluno/src/models/fitness_assessment_model.dart';
import 'package:fitcpxaluno/src/screens/view_images_fitness_assessment.dart';
import 'package:fitcpxaluno/src/services/fitness_assessment_service.dart';
import 'package:fitcpxaluno/src/utils/exportPDF.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:fitcpxaluno/src/widgets/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewFitnessAssessment extends StatefulWidget {
  final int? idAssessment;

  const ViewFitnessAssessment({super.key, this.idAssessment});

  @override
  State<ViewFitnessAssessment> createState() => _ViewFitnessAssessmentState();
}

class _ViewFitnessAssessmentState extends State<ViewFitnessAssessment>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final _fitnessAssessmentService = FitnessAssessmentService();

  // Armazena o Future para evitar múltiplas chamadas ao reconstruir a tela
  late Future<FitnessAssessmentModel> _assessmentFuture;

  bool _isExisting = false;

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

    // Inicializa a busca dos dados
    _assessmentFuture = _fitnessAssessmentService.getFitnessAssessmentResult(
      id_assessment: widget.idAssessment,
    );

    _controller.forward();
  }

  Future<void> _exitScreen() async {
    if (_isExisting) return;
    _isExisting = true;

    await _controller.reverse();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) _exitScreen();
      },
      // 1. O FutureBuilder agora envolve tudo, permitindo acesso aos dados na AppBar
      child: FutureBuilder<FitnessAssessmentModel>(
        future: _assessmentFuture,
        builder: (context, snapshot) {
          // Definimos o botão de ação (Share) apenas se os dados existirem
          Widget? trailingButton;

          if (snapshot.hasData) {
            final assessment = snapshot.data!;
            trailingButton = CupertinoButton(
              padding: EdgeInsets.zero,
              // 2. Agora o 'assessment' está acessível aqui!
              onPressed: () => exportFullContentAsPdf(assessment, context),
              child: const Icon(CupertinoIcons.share),
            );
          }

          return CustomScaffold(
            navigationBar: CupertinoNavigationBar(
              border: null,
              middle: const Text('Detalhes da Avaliação'),
              trailing: trailingButton, // Passamos o botão condicionalmente
            ),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: double.infinity,
                  height: mediaHeight,
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemBackground
                        .resolveFrom(context),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  // 3. Verificamos o estado do snapshot para renderizar o corpo
                  child: Builder(
                    builder: (context) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar os dados'),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text('Nenhum dado encontrado'),
                        );
                      }

                      final assessment = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Avaliação de ${assessment.date}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: CupertinoColors.label.resolveFrom(
                                      context,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).push(
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            ViewImagesFitnessAssessment(
                                              key: UniqueKey(),
                                              images: assessment.images,
                                            ),
                                      ),
                                    );
                                  },
                                  child: const Icon(FontAwesomeIcons.camera),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              height: 0.5,
                              color: CupertinoColors.separator.resolveFrom(
                                context,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: MyPieChart(
                                        assessment: assessment,
                                        context: context,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  CardItem('Geral', [
                                    'Avaliador: ${assessment.trainer}',
                                    'Altura: ${assessment.height} cm',
                                    'Peso: ${assessment.weight} kg',
                                  ], context),
                                  CardItem('Dobras', [
                                    'Tríceps: ${assessment.tricepsFold ?? "-"}',
                                    'Peitoral: ${assessment.chestFold ?? "-"}',
                                    'Subescapular: ${assessment.subscapularisFold ?? "-"}',
                                    'Axilar Média: ${assessment.armpitFold ?? "-"}',
                                    'Abdominal: ${assessment.abdominal ?? "-"}',
                                    'Coxa: ${assessment.thighFold ?? "-"}',
                                    'Suprailiaca: ${assessment.suprailiacFold ?? "-"}',
                                    'Supraespinhal: ${assessment.supraspinatusFold ?? "-"}',
                                    'Bíceps: ${assessment.bicepsFold ?? "-"}',
                                    'Panturrilha: ${assessment.calfFold ?? "-"}',
                                  ], context),
                                  CardItem('Geral - Perimetria', [
                                    'Pescoço: ${assessment.neck ?? "-"}',
                                    'Ombro: ${assessment.shoulder ?? "-"}',
                                    'Tórax Inspirado: ${assessment.chestInhaled ?? "-"}',
                                    'Tórax Expirado: ${assessment.chestExhaled ?? "-"}',
                                    'Cintura: ${assessment.waist ?? "-"}',
                                    'Abdômen: ${assessment.abdomen ?? "-"}',
                                    'Quadril: ${assessment.hips ?? "-"}',
                                  ], context),
                                  CardItem('Geral - Lado Direito', [
                                    'Braço Relaxado Direito: ${assessment.rightArmRelaxed ?? "-"}',
                                    'Braço Contraído Direito: ${assessment.rightArmContracted ?? "-"}',
                                    'Antebraço Direito: ${assessment.rightForearm ?? "-"}',
                                    'Coxa Direita: ${assessment.rightThigh ?? "-"}',
                                    'Panturrilha Direita: ${assessment.rightCalf ?? "-"}',
                                  ], context),
                                  CardItem('Geral - Lado Esquerdo', [
                                    'Braço Relaxado Direito: ${assessment.leftArmRelaxed ?? "-"}',
                                    'Braço Contraído Direito: ${assessment.leftArmContracted ?? "-"}',
                                    'Antebraço Direito: ${assessment.leftForearm ?? "-"}',
                                    'Coxa Direita: ${assessment.leftThigh ?? "-"}',
                                    'Panturrilha Direita: ${assessment.leftCalf ?? "-"}',
                                  ], context),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget CardItem(String title, List<String?> items, BuildContext context) {
  final chips = items
      .where((e) => e != null && e.isNotEmpty)
      .cast<String>()
      .toList();

  if (chips.isEmpty) return const SizedBox.shrink();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CupertinoCard(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(chips.length, (index) {
                final chip = chips[index];
                return Animate(
                  effects: [
                    FadeEffect(duration: 300.ms),
                    SlideEffect(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                      duration: 300.ms,
                    ),
                  ],
                  delay: Duration(milliseconds: 100 * index),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${chip.split(":").first}:",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                      ),
                      Text(
                        chip.contains(":") ? chip.split(":").last.trim() : '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: CupertinoColors.label.resolveFrom(context),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    ),
  );
}
