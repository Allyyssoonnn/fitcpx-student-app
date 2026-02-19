import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_bloc.dart';
import 'package:fitcpxaluno/src/blocs/fitnessAssessment/fitness_assessment_event.dart';
import 'package:fitcpxaluno/src/services/fitness_assessment_service.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

  // 1. CRIAMOS A LISTA DE FOTOS AQUI NO PAI
  final List<XFile> _assessmentImages = [];

  // 2. FUNÇÃO PARA ADICIONAR NOVA FOTO NA LISTA
  void _onImageAdded(XFile image) {
    setState(() {
      _assessmentImages.add(image);
    });
  }

  void _onImageRemoved(XFile image) {
    setState(() {
      _assessmentImages.remove(image);
    });
  }

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
        images: _assessmentImages,
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
                ImagesToUpload(
                  images: _assessmentImages,
                  onImageSelected: _onImageAdded,
                  onImageRemoved: _onImageRemoved,
                ),

                const SizedBox(height: 40),
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

class ImagesToUpload extends StatelessWidget {
  final List<XFile> images;
  final Function(XFile) onImageSelected;
  final Function(XFile) onImageRemoved;

  const ImagesToUpload({
    super.key,
    required this.images,
    required this.onImageSelected,
    required this.onImageRemoved,
  });

  void showOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: const Text('Fotos da Avaliação'),
        message: const Text('Adicione fotos para acompanhar sua evolução'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Tirar Foto'),
            onPressed: () {
              Navigator.pop(modalContext);
              _pickImage(context, ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Escolher da Galeria'),
            onPressed: () {
              Navigator.pop(modalContext);
              _pickImage(context, ImageSource.gallery);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(modalContext),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? rawImage = await picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (rawImage != null && context.mounted) {
        // Abre o Modal de Preview
        final XFile? processedImage = await showCupertinoModalPopup<XFile>(
          context: context,
          builder: (ctx) =>
              _AssessmentImagePreview(imageFile: File(rawImage.path)),
        );

        // Se o usuário clicou em "Adicionar" no preview, a imagem volta processada
        if (processedImage != null) {
          onImageSelected(processedImage);
        }
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
    }
  }

  void _showFullImage(BuildContext context, File image, XFile originalXFile) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.black,
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: Image.file(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      FontAwesomeIcons.x,
                      color: CupertinoColors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Icon(
                    CupertinoIcons.clear,
                    color: CupertinoColors.white,
                    size: 30,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    onImageRemoved(originalXFile);
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    CupertinoIcons.trash,
                    color: CupertinoColors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Imagens',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            height: 0.5,
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
        CupertinoButton.filled(
          onPressed: () => showOptions(context),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.camera),
              SizedBox(width: 8),
              Text("Adicionar Foto"),
            ],
          ),
        ),
        const SizedBox(height: 20),

        if (images.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Nenhuma imagem adicionada',
              style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
            ),
          )
        else
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: images.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final imgFile = File(images[index].path);
              final xFileOriginal = images[index];

              return GestureDetector(
                onTap: () => _showFullImage(context, imgFile, xFileOriginal),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Image.file(
                      imgFile,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: CupertinoColors.systemGrey5,
                        child: const Center(
                          child: Icon(
                            FontAwesomeIcons.image,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

// --- NOVO WIDGET DE PREVIEW ESPECÍFICO PARA A AVALIAÇÃO ---

class _AssessmentImagePreview extends StatefulWidget {
  final File imageFile;

  const _AssessmentImagePreview({required this.imageFile});

  @override
  State<_AssessmentImagePreview> createState() =>
      _AssessmentImagePreviewState();
}

class _AssessmentImagePreviewState extends State<_AssessmentImagePreview> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isProcessing = false;

  Future<void> _captureAndAdd() async {
    setState(() => _isProcessing = true);
    try {
      // Como a imagem já está visível na tela, não precisamos daquele hack do loop!
      await Future.delayed(const Duration(milliseconds: 100));

      RenderRepaintBoundary? boundary =
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) return;

      // Mantém pixelRatio alto para garantir boa qualidade
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/eval_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await file.writeAsBytes(pngBytes);

      // Fecha o modal retornando a nova imagem processada!
      if (mounted) Navigator.pop(context, XFile(file.path));
    } catch (e) {
      debugPrint("Erro ao capturar preview: $e");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            "Ajustar Foto",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: _repaintKey,
                child: AspectRatio(
                  aspectRatio: 9 / 16, // Garante o formato perfeito 9:16
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: FileImage(widget.imageFile),
                        fit:
                            BoxFit.cover, // Faz o corte automático centralizado
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Positioned.fill(
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //         begin: Alignment.bottomCenter,
                        //         end: Alignment.center,
                        //         colors: [
                        //           Colors.black.withOpacity(0.6),
                        //           Colors.transparent,
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Logo no canto inferior esquerdo
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/logo.png', // <--- SUA LOGO
                                height: 30,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      CupertinoIcons.bolt_fill,
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "FitCpx",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    child: const Text("Cancelar"),
                    onPressed: () => Navigator.pop(context), // Retorna null
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CupertinoButton.filled(
                    onPressed: _isProcessing ? null : _captureAndAdd,
                    child: _isProcessing
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : const Text("Adicionar"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
