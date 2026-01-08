import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fitcpxaluno/src/models/workout_history_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class WorkoutShareSheet {
  // Mudei o nome do parâmetro para 'parentContext' para ficar explícito
  static void show(
    BuildContext parentContext,
    WorkoutHistoryModel workout,
    String durationFormatted,
  ) {
    showCupertinoModalPopup(
      context: parentContext,
      // AQUI ESTAVA O ERRO:
      // Usamos 'modalContext' aqui para não substituir o 'parentContext'
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: const Text('Compartilhar Treino'),
        message: const Text('Escolha uma foto para o fundo do seu story'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Tirar Foto'),
            onPressed: () {
              // Fecha o menu de opções
              Navigator.pop(modalContext);

              // Usa o contexto da PÁGINA (parentContext) para abrir o picker
              _pickImage(
                parentContext,
                ImageSource.camera,
                workout,
                durationFormatted,
              );
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Escolher da Galeria'),
            onPressed: () {
              // Fecha o menu de opções
              Navigator.pop(modalContext);

              // Usa o contexto da PÁGINA (parentContext)
              _pickImage(
                parentContext,
                ImageSource.gallery,
                workout,
                durationFormatted,
              );
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

  static Future<void> _pickImage(
    BuildContext context,
    ImageSource source,
    WorkoutHistoryModel workout,
    String duration,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();

      // O await aqui faz a execução parar enquanto o usuário escolhe a foto
      final XFile? image = await picker.pickImage(source: source);

      // Verificamos se o widget pai ainda está montado
      if (image != null && context.mounted) {
        // Agora sim, usamos o contexto válido da página para abrir o preview
        showCupertinoModalPopup(
          context: context,
          builder: (ctx) => _SharePreviewContent(
            imageFile: File(image.path),
            workout: workout,
            durationText: duration,
          ),
        );
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
    }
  }
}

// --- WIDGET INTERNO (Mantido igual, apenas ajustei o aspect ratio) ---

class _SharePreviewContent extends StatefulWidget {
  final File imageFile;
  final WorkoutHistoryModel workout;
  final String durationText;

  const _SharePreviewContent({
    required this.imageFile,
    required this.workout,
    required this.durationText,
  });

  @override
  State<_SharePreviewContent> createState() => _SharePreviewContentState();
}

class _SharePreviewContentState extends State<_SharePreviewContent> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSharing = false;

  Future<void> _captureAndShare() async {
    setState(() => _isSharing = true);
    try {
      // Pequeno delay para garantir renderização antes do print (opcional, mas ajuda em dispositivos lentos)
      await Future.delayed(const Duration(milliseconds: 100));

      RenderRepaintBoundary? boundary =
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("Boundary null");
        return;
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/workout_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Treino concluído! 💪 @fitcpx');

      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Erro ao compartilhar: $e");
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            "Visualizar Story",
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
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  // RECOMENDAÇÃO: Mantenha o AspectRatio para garantir formato de Story
                  // Se tirar, a imagem pode ficar quadrada dependendo do conteúdo
                  // aspectRatio: 9 / 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: FileImage(widget.imageFile),
                      fit: BoxFit.cover,
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
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: const [0.0, 0.4, 1.0],
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: CupertinoColors.activeGreen,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "TREINO FINALIZADO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.workout.name.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildBadge(
                                  CupertinoIcons.calendar,
                                  widget.workout.date,
                                ),
                                const SizedBox(width: 8),
                                _buildBadge(
                                  CupertinoIcons.time,
                                  widget.durationText,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                // Icon(
                                //   CupertinoIcons.bolt_fill,
                                //   color: CupertinoColors.systemYellow,
                                //   size: 16,
                                // ),
                                Image.asset(
                                  'assets/images/logo.png', // <--- CAMINHO DA SUA LOGO BRANCA
                                  height:
                                      30, // Ajuste a altura conforme necessário para ficar harmônico
                                  fit: BoxFit.contain,
                                  // Se a imagem não carregar ou não existir, mostra um ícone de erro discreto
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        CupertinoIcons.bolt_fill,
                                        color: Colors.white54,
                                        size: 20,
                                      ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "FitCpx",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    child: const Text("Voltar"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CupertinoButton.filled(
                    onPressed: _isSharing ? null : _captureAndShare,
                    child: _isSharing
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : const Text("Compartilhar"),
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

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
