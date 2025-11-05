import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ViewImagesFitnessAssessment extends StatelessWidget {
  const ViewImagesFitnessAssessment({super.key, this.images});
  final List<String>? images;

  Future<void> _saveImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await file.writeAsBytes(response.bodyBytes);
      await GallerySaver.saveImage(file.path);
    } catch (e) {
      debugPrint('Erro ao salvar imagem: $e');
    }
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.black,
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => const Icon(
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
                    await _saveImage(imageUrl);
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    CupertinoIcons.arrow_down_circle,
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
    return CustomScaffold(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: CupertinoColors.white,
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
          children: [
            const Text(
              'Imagens',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 12),
              child: Container(height: 0.5, color: CupertinoColors.separator),
            ),
            Expanded(
              child: (images == null || images!.isEmpty)
                  ? const Center(
                      child: Text(
                        'Nenhuma imagem disponível',
                        style: TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    )
                  : MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemCount: images!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _showFullImage(context, images![index]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: images![index],
                              placeholder: (context, url) => Container(
                                color: CupertinoColors.systemGrey,
                                child: const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                height:
                                    150, // pode ajustar altura do placeholder
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(FontAwesomeIcons.x),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
