import 'package:fitcpxaluno/src/models/fitness_assessment_model.dart';
import 'package:fitcpxaluno/src/screens/view_images_fitness_assessment.dart';
import 'package:fitcpxaluno/src/services/fitness_assessment_service.dart';
import 'package:fitcpxaluno/src/utils/exportPDF.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:fitcpxaluno/src/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
              decoration: const BoxDecoration(
                color: Colors.white,
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
                    return const Center(child: CircularProgressIndicator());
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
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  exportFullContentAsPdf(assessment, context),
                              child: Icon(Icons.ios_share_outlined),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewImagesFitnessAssessment(
                                            key: UniqueKey(),
                                            images: assessment.images,
                                          ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.camera_alt),
                                label: Text('Imagens'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1.3,
                                  child: MyPieChart(assessment: assessment),
                                ),
                              ),
                              const SizedBox(height: 12),
                              CardItem('Geral', [
                                'Avaliador: ${assessment.trainer}',
                                'Altura: ${assessment.height} cm',
                                'Peso: ${assessment.weight} kg',
                              ]),
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
                              ]),
                              CardItem('Geral - Perimetria', [
                                'Pescoço: ${assessment.neck}',
                                'Ombro: ${assessment.shoulder}',
                                'Tórax Inspirado: ${assessment.chestInhaled}',
                                'Tórax Expirado: ${assessment.chestExhaled}',
                                'Abdomên: ${assessment.waist}',
                                'Abdômen: ${assessment.abdomen}',
                                'Quadril: ${assessment.hips}',
                              ]),
                              CardItem('Geral - Lado Direito', [
                                'Braço Relaxado Direito: ${assessment.rightArmRelaxed}',
                                'Braço Contraído Direito: ${assessment.rightArmContracted}',
                                'Antebraço Direito: ${assessment.rightForearm}',
                                'Coxa Direita: ${assessment.rightThigh}',
                                'Panturrilha Direita: ${assessment.rightCalf}',
                              ]),
                              CardItem('Geral - Lado Esquerdo', [
                                'Braço Relaxado Direito: ${assessment.leftArmRelaxed}',
                                'Braço Contraído Direito: ${assessment.leftArmContracted}',
                                'Antebraço Direito: ${assessment.leftForearm}',
                                'Coxa Direita: ${assessment.leftThigh}',
                                'Panturrilha Direita: ${assessment.leftCalf}',
                              ]),
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

Widget CardItem(String title, List<String?> items) {
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
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
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
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        chip.contains(":") ? chip.split(":").last.trim() : '',
                        textAlign: TextAlign.right,
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
