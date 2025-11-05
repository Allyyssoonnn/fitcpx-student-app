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
  final int? idClient;

  const ViewFitnessAssessment({super.key, this.idAssessment, this.idClient});

  @override
  State<ViewFitnessAssessment> createState() => _ViewFitnessAssessmentState();
}

class _ViewFitnessAssessmentState extends State<ViewFitnessAssessment>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final _fitnessAssessmentService = FitnessAssessmentService();

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

    _controller.forward();
  }

  Future<FitnessAssessmentModel> _loadFitnessAssessment() async {
    return await _fitnessAssessmentService.getFitnessAssessmentResult(
      id_assessment: widget.idAssessment,
      id_client: widget.idClient,
    );
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
      child: CustomScaffold(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              height: mediaHeight,
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemBackground.resolveFrom(
                  context,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: FutureBuilder<FitnessAssessmentModel>(
                future: _loadFitnessAssessment(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar os dados'));
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
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: CupertinoColors.label.resolveFrom(
                                  context,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  exportFullContentAsPdf(assessment, context),
                              child: Icon(FontAwesomeIcons.share),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                        child: Container(
                          height: 0.5,
                          color: CupertinoColors.separator,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              CupertinoButton.tinted(
                                color: CupertinoColors.activeGreen,
                                onPressed: () {
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
                                child: Text(
                                  'Imagens',
                                  style: TextStyle(
                                    color: CupertinoColors.activeGreen,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1.3,
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
                                'Tríceps: ${assessment.tricepsFold}',
                                'Peitoral: ${assessment.chestFold}',
                                'Subescapular: ${assessment.subscapularisFold}',
                                'Axilar Média: ${assessment.armpitFold}',
                                'Abdominal: ${assessment.abdominal}',
                                'Coxa: ${assessment.thighFold}',
                                'Suprailiaca: ${assessment.suprailiacFold}',
                                'Supraespinhal: ${assessment.supraspinatusFold}',
                                'Bíceps: ${assessment.bicepsFold}',
                                'Panturrilha: ${assessment.calfFold}',
                              ], context),
                              CardItem('Geral - Perimetria', [
                                'Pescoço: ${assessment.neck}',
                                'Ombro: ${assessment.shoulder}',
                                'Tórax Inspirado: ${assessment.chestInhaled}',
                                'Tórax Expirado: ${assessment.chestExhaled}',
                                'Abdomên: ${assessment.waist}',
                                'Abdômen: ${assessment.abdomen}',
                                'Quadril: ${assessment.hips}',
                              ], context),
                              CardItem('Geral - Lado Direito', [
                                'Braço Relaxado Direito: ${assessment.rightArmRelaxed}',
                                'Braço Contraído Direito: ${assessment.rightArmContracted}',
                                'Antebraço Direito: ${assessment.rightForearm}',
                                'Coxa Direita: ${assessment.rightThigh}',
                                'Panturrilha Direita: ${assessment.rightCalf}',
                              ], context),
                              CardItem('Geral - Lado Esquerdo', [
                                'Braço Relaxado Direito: ${assessment.leftArmRelaxed}',
                                'Braço Contraído Direito: ${assessment.leftArmContracted}',
                                'Antebraço Direito: ${assessment.leftForearm}',
                                'Coxa Direita: ${assessment.leftThigh}',
                                'Panturrilha Direita: ${assessment.leftCalf}',
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
      // crossAxisAlignment: CrossAxisAlignment.start,
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
                  // child: Text(chip),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chip.split(":").first + ":",
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
