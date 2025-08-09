import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWebViewPlayer extends StatefulWidget {
  final String videoUrl;

  const YoutubeWebViewPlayer({Key? key, required this.videoUrl})
    : super(key: key);

  @override
  State<YoutubeWebViewPlayer> createState() => _YoutubeWebViewPlayerState();
}

class _YoutubeWebViewPlayerState extends State<YoutubeWebViewPlayer> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void didUpdateWidget(covariant YoutubeWebViewPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoUrl != widget.videoUrl) {
      final videoId =
          Uri.tryParse(widget.videoUrl)?.queryParameters['v'] ??
          widget.videoUrl.split("/").last;

      final embedUrl = 'https://www.youtube.com/embed/$videoId';
      _controller.loadRequest(Uri.parse(embedUrl));
    }
  }

  @override
  void initState() {
    super.initState();

    final videoId =
        Uri.tryParse(widget.videoUrl)?.queryParameters['v'] ??
        widget.videoUrl.split("/").last;

    final embedUrl = 'https://www.youtube.com/embed/$videoId';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(embedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
