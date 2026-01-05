import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeWebViewPlayer extends StatefulWidget {
  final String videoUrl;

  const YoutubeWebViewPlayer({Key? key, required this.videoUrl})
    : super(key: key);

  @override
  State<YoutubeWebViewPlayer> createState() => _YoutubeWebViewPlayerState();
}

class _YoutubeWebViewPlayerState extends State<YoutubeWebViewPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: true,
        forceHD: true,
        mute: true,
      ),
    );
  }

  //Nunca mais chamado pois agora controla via Key no componente pai
  @override
  void didUpdateWidget(covariant YoutubeWebViewPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      final newVideoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
      // _controller.load(newVideoId);
      _controller.cue(newVideoId);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ Função que abre o fullscreen em nova tela
  void _goFullScreen() {
    final videoId = _controller.metadata.videoId;
    _controller.pause();
    // _controller.toggleFullScreenMode();

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) {
              final fullscreenController = YoutubePlayerController(
                initialVideoId: videoId,
                flags: YoutubePlayerFlags(
                  autoPlay: false,
                  forceHD: true,
                  mute: true,
                ),
              );

              fullscreenController.toggleFullScreenMode();

              return Scaffold(
                backgroundColor: Colors.black,
                body: SafeArea(
                  child: Stack(
                    children: [
                      Center(
                        child: YoutubePlayer(
                          controller: fullscreenController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.red,
                          aspectRatio: 16 / 9,
                          onEnded: (metaData) {
                            _controller.seekTo(Duration.zero);
                          },
                          bottomActions: [
                            CurrentPosition(),
                            ProgressBar(isExpanded: true),
                            RemainingDuration(),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
        .then((_) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          setState(() {}); // força reconstrução do player original
        });
  }

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        onReady: () {
          debugPrint('Player pronto!');
        },
        onEnded: (metaData) {
          _controller.seekTo(Duration.zero);
        },
        thumbnail: Image.network(
          // 1. Tenta carregar a imagem em HD (Max Resolution)
          'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // 2. Se a HD não existir (erro 404), carrega a HQ (480p) como garantia
            return Image.network(
              'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // 3. Se tudo falhar, tela preta
                return Container(color: Colors.black);
              },
            );
          },
        ),
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            onPressed: _goFullScreen, // chama sua função
          ),
        ],
      ),
    );
  }
}
