import 'package:fitcpxapp/src/models/exercise_model.dart';
import 'package:fitcpxapp/src/widgets/customScaffold.dart';
import 'package:fitcpxapp/src/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExerciseInfoScreen extends StatefulWidget {
  const ExerciseInfoScreen({super.key, required this.exercise});

  final ExerciseModel exercise;

  @override
  State<ExerciseInfoScreen> createState() => _ExerciseInfoState();
}

class _ExerciseInfoState extends State<ExerciseInfoScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

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

  Future<void> _exitScreen() async {
    if (_isExisting) return;
    _isExisting = true;

    await _controller.reverse();
    if (mounted) Navigator.pop(context);
  }

  Widget sectionChips(String title, List<String?> items) {
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
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
                child: FilterChip(onSelected: (_) {}, label: Text(chip)),
              );
            }),
          ),
        ],
      ),
    );
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  YoutubeWebViewPlayer(
                    videoUrl: widget.exercise.url_exercicio ?? '',
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.exercise.nome_exercicio,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          sectionChips('Grupos Musculares Principais', [
                            widget.exercise.nome_grupo_exercicio_1,
                            widget.exercise.nome_grupo_exercicio_2,
                            widget.exercise.nome_grupo_exercicio_3,
                            widget.exercise.nome_grupo_exercicio_4,
                            widget.exercise.nome_grupo_exercicio_5,
                          ]),
                          sectionChips('Grupos Musculares Secundários', [
                            widget.exercise.nome_grupo_exercicio_6,
                            widget.exercise.nome_grupo_exercicio_7,
                            widget.exercise.nome_grupo_exercicio_8,
                            widget.exercise.nome_grupo_exercicio_9,
                            widget.exercise.nome_grupo_exercicio_10,
                          ]),
                          sectionChips('Articulações', [
                            widget.exercise.nome_articulacao_1,
                            widget.exercise.nome_articulacao_2,
                            widget.exercise.nome_articulacao_3,
                            widget.exercise.nome_articulacao_4,
                          ]),
                          sectionChips('Equipamentos', [
                            widget.exercise.nome_equipamento_1,
                            widget.exercise.nome_equipamento_2,
                            widget.exercise.nome_equipamento_3,
                          ]),
                          sectionChips('Tipo de exercício', [
                            widget.exercise.nome_tipo_exercicio,
                          ]),
                          sectionChips('Resistência do exercício', [
                            widget.exercise.nome_exercicio_resistencia,
                          ]),
                          sectionChips('Indicação', [
                            widget.exercise.nome_indicacao,
                          ]),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
