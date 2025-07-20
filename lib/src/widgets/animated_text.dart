// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:svg_path_parser/svg_path_parser.dart';
//
// //##############################################################################
// //## Widget Principal da Animação
// //##############################################################################
// class TelaAnimacaoManuscrito extends StatefulWidget {
//   const TelaAnimacaoManuscrito({super.key});
//
//   @override
//   State<TelaAnimacaoManuscrito> createState() => _TelaAnimacaoManuscritoState();
// }
//
// class _TelaAnimacaoManuscritoState extends State<TelaAnimacaoManuscrito>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   ui.Path? _caminhoHello;
//
//   // String do path SVG
//   final String stringDoMeuPathSvg =
//       "m 515.76022,583.49567 q -27.75,0 -47.25,-15.9375 -20.8125,-17.0625 -20.8125,-44.15625 0,-31.875 19.96875,-58.125 22.40625,-29.53125 56.4375,-29.53125 32.71875,0 49.03125,15 16.3125,15 16.3125,45.09375 0,31.875 -18.375,57.75 -21.1875,29.90625 -55.3125,29.90625 z m 8.34375,-122.34375 q -20.90625,0 -35.8125,20.25 -13.96875,18.9375 -13.96875,42 0,15.5625 12.09375,25.3125 11.625,9.375 29.34375,9.375 20.625,0 34.40625,-20.25 12.65625,-18.46875 12.65625,-42 0,-19.6875 -8.8125,-27.375 -8.4375,-7.3125 -29.90625,-7.3125 z m 109.6875,102.84375 q 0,17.8125 -12.9375,17.8125 -5.625,0 -9.28125,-3.5625 -3.65625,-3.5625 -3.65625,-9.1875 V 439.40192 q 0,-5.4375 3.9375,-8.90625 3.75,-3.1875 9.28125,-3.1875 5.53125,0 9.09375,3.375 3.5625,3.28125 3.5625,8.71875 z m 104.625,19.96875 q -4.3125,0 -13.6875,-9.375 -8.625,4.125 -15.1875,6.1875 -6.5625,2.15625 -11.15625,2.15625 -22.59375,0 -33.9375,-12.09375 -11.25,-12.09375 -11.25,-36.1875 0,-22.59375 16.6875,-38.625 16.6875,-16.125 39.9375,-16.125 8.90625,0 20.625,5.0625 14.15625,6.09375 14.15625,14.15625 0,3.375 -2.15625,5.90625 -0.9375,3.75 -1.5,9.46875 -0.46875,5.625 -0.46875,13.21875 0,17.90625 2.53125,25.78125 0.28125,0.84375 4.3125,9.75 3.65625,8.0625 3.65625,9.1875 0,4.96875 -3.84375,8.25 -3.75,3.28125 -8.71875,3.28125 z m -23.25,-64.3125 q 0,-3 0.375,-6.84375 0.46875,-3.9375 1.3125,-8.71875 -1.875,-0.9375 -3.375,-1.3125 -1.40625,-0.46875 -2.4375,-0.46875 -12.75,0 -22.3125,10.03125 -9.5625,9.9375 -9.5625,23.0625 0,12.5625 4.5,18.9375 4.5,6.28125 13.5,6.28125 5.8125,0 10.96875,-1.875 5.25,-1.96875 9.84375,-5.71875 -2.8125,-22.3125 -2.8125,-33.375 z m 18.5625,-79.03125 q -4.96875,3.375 -12.28125,11.4375 -7.6875,8.4375 -12.1875,11.71875 -3.65625,2.71875 -8.0625,2.71875 -4.96875,0 -8.625,-3.1875 -3.65625,-3.1875 -3.65625,-7.40625 0,-3.46875 3.9375,-7.59375 3.46875,-3.1875 6.84375,-6.375 10.03125,-10.96875 11.8125,-12.5625 8.53125,-7.6875 15.09375,-7.6875 4.96875,0 8.53125,3.28125 3.65625,3.28125 3.65625,7.40625 0,4.78125 -5.0625,8.25 z m 70.59375,148.78125 q -4.59375,9.1875 -7.3125,14.4375 -3.1875,6.1875 -10.21875,6.1875 -4.96875,0 -8.4375,-3.1875 -3.46875,-3.09375 -3.46875,-7.21875 0,-2.4375 6,-14.53125 5.34375,-10.6875 8.0625,-15.09375 3.46875,-5.53125 9.75,-5.53125 4.96875,0 8.4375,3.1875 3.46875,3.1875 3.46875,7.3125 0,1.875 -6.28125,14.4375 z m 233.99998,-8.8125 q -7.4062,-0.28125 -14.9062,-17.4375 -4.9688,-11.0625 -8.5313,-25.5 -6.9375,1.03125 -22.68748,2.0625 -14.8125,1.03125 -22.6875,2.4375 -4.3125,10.3125 -15,31.03125 -4.125,6.75 -11.4375,6.75 -5.15625,0 -9.28125,-3.46875 -4.125,-3.5625 -4.125,-9 0,-4.78125 13.6875,-32.4375 -1.3125,-2.90625 -1.125,-5.4375 0.375,-4.5 9.09375,-7.03125 13.3125,-23.0625 29.625,-47.8125 23.43748,-35.53125 28.87498,-35.53125 10.3125,0 13.7813,12.46875 1.875,10.03125 5.9062,30.09375 5.7188,27 13.9688,61.78125 0.6562,2.625 4.7812,12.375 3.375,8.0625 3.375,12.09375 0,5.4375 -4.125,9.09375 -4.0312,3.65625 -9.1875,3.46875 z m -34.9687,-96.1875 q -7.31253,12.5625 -20.15628,34.21875 4.21875,-0.9375 13.125,-1.5 10.49998,-0.65625 13.21878,-1.03125 -2.25,-12.1875 -6.1875,-31.6875 z m 96.6562,79.59375 q 0,17.8125 -12.9375,17.8125 -5.625,0 -9.2812,-3.5625 -3.6563,-3.5625 -3.6563,-9.1875 V 439.40192 q 0,-5.4375 3.9375,-8.90625 3.75,-3.1875 9.2813,-3.1875 5.5312,0 9.0937,3.375 3.5625,3.28125 3.5625,8.71875 z m 105.8438,-40.40625 q 0,6.28125 0.094,18.9375 0.094,12.65625 0.094,18.9375 0,1.96875 0.2812,5.90625 0.375,3.84375 0.375,5.8125 0,5.25 -3.8437,8.625 -3.75,3.46875 -9.2813,3.46875 -7.7812,0 -11.3437,-7.03125 -12,4.40625 -24.8438,4.40625 -13.3125,0 -22.4062,-5.625 -10.2188,-6.46875 -12.1875,-18.84375 -3.6563,-23.4375 -3.6563,-41.90625 0,-12.1875 2.8125,-27.84375 1.875,-10.59375 12.6563,-10.59375 5.4375,0 9.2812,3.46875 3.8438,3.375 3.8438,8.625 0,4.125 -1.4063,12.9375 -1.3125,8.8125 -1.3125,13.40625 0,13.21875 0.8438,23.15625 0.9375,9.84375 2.7187,16.3125 2.3438,1.03125 4.5,1.59375 2.25,0.5625 4.3125,0.5625 10.4063,0 22.875,-3 0,-7.21875 -0.094,-16.40625 -0.1875,-10.96875 -0.1875,-15.75 0,-19.21875 1.7812,-33.1875 1.4063,-11.15625 12.75,-11.15625 5.5313,0 9.4688,3.46875 3.9375,3.46875 3.6562,8.71875 -1.7812,35.71875 -1.7812,33 z m 91.5937,60.84375 q -11.5312,0 -12.8437,-11.34375 -1.3125,-9.65625 -2.625,-19.40625 -1.4063,-10.3125 -1.4063,-19.40625 0,-2.4375 0.2813,-8.34375 0.375,-5.90625 0.375,-8.34375 0,-0.65625 0.1875,-3.28125 0.1875,-2.71875 0.1875,-4.40625 0,-7.78125 -4.0313,-7.78125 -8.625,0 -16.9687,10.125 -8.25,10.03125 -12.9375,25.5 -0.1875,3.09375 -0.8438,8.25 -0.5625,4.21875 -0.5625,8.25 0,2.625 0.5625,7.96875 0.6563,5.25 0.6563,7.875 0,5.34375 -3.75,8.8125 -3.6563,3.5625 -9.2813,3.5625 -5.625,0 -9.2812,-3.5625 -3.6563,-3.46875 -3.6563,-8.8125 0,-2.625 -0.5625,-7.875 -0.5625,-5.34375 -0.5625,-7.96875 0,-9 1.3125,-25.03125 1.3125,-16.03125 1.3125,-25.03125 0,-2.8125 -0.375,-8.34375 -0.2812,-5.625 -0.2812,-8.34375 0,-5.25 3.75,-8.625 3.8437,-3.46875 9.375,-3.46875 12.2812,0 13.125,14.71875 l 0.094,1.03125 q 13.6875,-13.78125 28.875,-13.78125 17.7188,0 24.4688,14.8125 4.5,9.9375 4.5,29.71875 v 6.65625 q -0.094,4.3125 -0.094,6.09375 0,7.3125 1.9688,18.84375 2.0625,11.53125 2.0625,18.75 0,5.25 -3.75,8.71875 -3.75,3.46875 -9.2813,3.46875 z m 65.25,-1.125 q -17.3437,0 -29.8125,-11.90625 -13.6875,-13.03125 -14.3437,-34.78125 -0.6563,-20.71875 11.3437,-36.9375 14.25,-19.125 39.6563,-19.125 18.75,0 29.8125,15 9.9375,13.5 9.9375,33.46875 0,21.75 -11.625,37.125 -13.0313,17.15625 -34.9688,17.15625 z m 5.625,-78 q -11.5312,-0.0937 -18.1875,10.5 -5.625,8.90625 -5.625,20.8125 0,11.25 6.375,17.25 5.0625,4.78125 11.8125,4.78125 8.1563,0 14.1563,-5.53125 6.8437,-6.46875 7.3125,-17.53125 1.2187,-30.1875 -15.8438,-30.28125 z";
//
//   // Paint para o traço da animação
//   final Paint _handwritingStrokePaint = Paint()
//     ..color = Colors
//         .white // Cor do traço
//     ..style = PaintingStyle.stroke
//     ..strokeWidth =
//         1.0 // Espessura do traço
//     ..strokeCap = StrokeCap.round
//     ..strokeJoin = StrokeJoin.round;
//
//   // Paint para o preenchimento final
//   final Paint _fillPaint = Paint()
//     ..color = Colors
//         .white // Cor do preenchimento
//     ..style = PaintingStyle.fill
//     ..strokeWidth = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     print(
//       "DEBUG: Iniciando initState. stringDoMeuPathSvg.isNotEmpty: ${stringDoMeuPathSvg.isNotEmpty}",
//     );
//
//     try {
//       if (stringDoMeuPathSvg.isNotEmpty) {
//         _caminhoHello = parseSvgPath(stringDoMeuPathSvg);
//         if (_caminhoHello == null || _caminhoHello!.getBounds().isEmpty) {
//           print(
//             "AVISO: Path SVG parseado retornou nulo ou tem bounds vazios. Usando fallback.",
//           );
//           _caminhoHello = _createFallbackPath();
//         } else {
//           print("Path SVG Parseado com sucesso!");
//           print("Bounds do Path Original: ${_caminhoHello!.getBounds()}");
//         }
//       } else {
//         print("ERRO: stringDoMeuPathSvg está vazia. Usando fallback.");
//         _caminhoHello = _createFallbackPath();
//       }
//     } catch (e) {
//       print(
//         "ERRO CRÍTICO ao parsear a string do path SVG: $e. Usando fallback.",
//       );
//       _caminhoHello = _createFallbackPath();
//     }
//
//     _controller = AnimationController(
//       duration: const Duration(seconds: 4), // Duração da animação de escrita
//       vsync: this,
//     );
//
//     _controller.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//     _controller.addStatusListener((status) {
//       if (mounted) {
//         if (status == AnimationStatus.completed) {
//           print(
//             "Animação de escrita completada. O preenchimento deve ocorrer agora.",
//           );
//           setState(() {}); // Garante um repaint para o estado final
//         } else if (status == AnimationStatus.dismissed) {
//           print("Animação reiniciada ou parada no início.");
//           setState(() {});
//         }
//       }
//     });
//
//     if (_caminhoHello != null && !_caminhoHello!.getBounds().isEmpty) {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (mounted) {
//           _controller.forward();
//         }
//       });
//     } else {
//       print(
//         "Não iniciando animação porque o path SVG não foi carregado corretamente ou é inválido.",
//       );
//     }
//   }
//
//   ui.Path _createFallbackPath() {
//     final path = ui.Path();
//     // Um fallback mais simples e menos propenso a ser confundido com o path principal
//     path.addOval(const Rect.fromLTWH(10, 10, 50, 50));
//     print("Path de fallback criado e sendo usado (um círculo).");
//     return path;
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       child: Builder(
//         builder: (context) {
//           if (_caminhoHello == null || _caminhoHello!.getBounds().isEmpty) {
//             return const Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Carregando animação...",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   SizedBox(height: 10),
//                   SizedBox(
//                     width: 30,
//                     height: 30,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return CustomPaint(
//             size: Size(MediaQuery.of(context).size.width * 0.9, 200),
//             painter: HandwritingPainter(
//               animationController: _controller,
//               originalPath: _caminhoHello!,
//               strokePaint: _handwritingStrokePaint,
//               fillPaint: _fillPaint,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// //##############################################################################
// //## CustomPainter para a Animação
// //##############################################################################
// class HandwritingPainter extends CustomPainter {
//   final AnimationController animationController;
//   final ui.Path originalPath;
//   final Paint strokePaint; // Paint para o traço da escrita
//   final Paint fillPaint; // Paint para o preenchimento inicial (cor base)
//
//   // Poderíamos adicionar um segundo AnimationController para o preenchimento
//   // ou derivar o progresso do preenchimento a partir do animationController principal.
//   // Por simplicidade, vamos tentar derivar do principal.
//
//   HandwritingPainter({
//     required this.animationController,
//     required this.originalPath,
//     required this.strokePaint,
//     required this.fillPaint,
//   }) : super(repaint: animationController);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double overallProgress = animationController.value;
//     final AnimationStatus animationStatus = animationController.status;
//     final Rect pathBounds = originalPath.getBounds();
//
//     if (pathBounds.isEmpty ||
//         size.isEmpty ||
//         pathBounds.width <= 0 ||
//         pathBounds.height <= 0) {
//       return;
//     }
//
//     final double scaleX = size.width / pathBounds.width;
//     final double scaleY = size.height / pathBounds.height;
//     final double scale = (scaleX < scaleY ? scaleX : scaleY) * 0.9;
//
//     if (scale <= 0 || scale.isNaN || scale.isInfinite) {
//       return;
//     }
//
//     final double scaledPathWidth = pathBounds.width * scale;
//     final double scaledPathHeight = pathBounds.height * scale;
//     final double translateX = (size.width - scaledPathWidth) / 2;
//     final double translateY = (size.height - scaledPathHeight) / 2;
//
//     final Matrix4 transformMatrix = Matrix4.identity()
//       ..translate(translateX, translateY)
//       ..scale(scale, scale)
//       ..translate(-pathBounds.left, -pathBounds.top);
//
//     final ui.Path transformedOriginalPath = originalPath.transform(
//       transformMatrix.storage,
//     );
//     if (transformedOriginalPath.getBounds().isEmpty) {
//       return;
//     }
//     final Rect transformedBounds = transformedOriginalPath.getBounds();
//
//     // Defina os estágios da animação
//     // Por exemplo: 0.0 a 0.7 para desenhar o contorno, 0.7 a 1.0 para preencher
//     const double strokeEndTime = 0.7; // Contorno termina em 70% da animação
//     const double fillStartTime =
//         strokeEndTime; // Preenchimento começa quando o contorno termina
//
//     // --- ANIMAÇÃO DO CONTORNO ---
//     double strokeProgress = overallProgress / strokeEndTime;
//     strokeProgress = strokeProgress.clamp(
//       0.0,
//       1.0,
//     ); // Garante que fique entre 0 e 1
//
//     if (overallProgress <= strokeEndTime ||
//         animationStatus == AnimationStatus.forward && overallProgress < 1.0) {
//       final ui.PathMetrics pathMetrics = transformedOriginalPath
//           .computeMetrics();
//       for (final ui.PathMetric metric in pathMetrics) {
//         if (metric.length == 0) continue;
//         final double drawLength = metric.length * strokeProgress;
//         if (drawLength <= 0) continue;
//         try {
//           final ui.Path extractedPath = metric.extractPath(0.0, drawLength);
//           if (!extractedPath.getBounds().isEmpty) {
//             canvas.drawPath(extractedPath, strokePaint);
//           }
//         } catch (e) {
//           // print("HandwritingPainter: Erro ao extrair path do metric: $e");
//         }
//       }
//     }
//
//     // --- ANIMAÇÃO DO PREENCHIMENTO ---
//     if (overallProgress >= fillStartTime) {
//       double fillProgress =
//           (overallProgress - fillStartTime) / (1.0 - fillStartTime);
//       fillProgress = fillProgress.clamp(
//         0.0,
//         1.0,
//       ); // Garante que fique entre 0 e 1
//
//       if (fillProgress > 0) {
//         final Paint animatedFillPaint = Paint()
//           ..style = PaintingStyle.fill
//           ..shader = ui.Gradient.linear(
//             // Animar o gradiente da esquerda para a direita (ou de baixo para cima, etc.)
//             // Aqui, o gradiente vai de "cor de preenchimento" para "transparente"
//             // e a posição da "cor de preenchimento" se move com fillProgress.
//             transformedBounds.topLeft.translate(
//               transformedBounds.width * fillProgress - transformedBounds.width,
//               0,
//             ),
//             // Começa fora da tela à esquerda
//             transformedBounds.topLeft.translate(
//               transformedBounds.width * fillProgress,
//               0,
//             ),
//             // Termina varrendo para a direita
//             [
//               fillPaint.color.withOpacity(0.0),
//               // Começa transparente
//               fillPaint.color,
//               // Cor sólida
//               fillPaint.color,
//               // Cor sólida
//               fillPaint.color.withOpacity(0.0),
//               // Termina transparente para um efeito de "onda"
//             ],
//             [
//               0.0,
//               // Início da parte transparente
//               (fillProgress * 0.5).clamp(0.0, 1.0),
//               // Onde a cor sólida começa a aparecer
//               (0.5 + fillProgress * 0.5).clamp(0.0, 1.0),
//               // Onde a cor sólida começa a desaparecer
//               1.0,
//               // Fim da parte transparente
//             ], // Stops para controlar a transição
//             // Se quiser um preenchimento sólido que apenas "cresce":
//             // transformedBounds.topLeft,
//             // Offset(transformedBounds.left + transformedBounds.width * fillProgress, transformedBounds.top + transformedBounds.height),
//             // [fillPaint.color, fillPaint.color],
//           );
//
//         // Para o preenchimento animado, precisamos desenhar o path completo
//         // e deixar o shader fazer o trabalho de revelação gradual.
//         // Ou, alternativamente, usar clipPath. Vamos com Shader por enquanto.
//         canvas.save();
//         canvas.clipPath(
//           transformedOriginalPath,
//         ); // Importante: Garante que o gradiente só pinte dentro do path
//         canvas.drawRect(
//           transformedBounds,
//           animatedFillPaint,
//         ); // Desenha um retângulo com o gradiente que cobre a área do path
//         canvas.restore();
//       }
//     }
//
//     // --- ESTADO FINAL (Contorno completo sobre o preenchimento completo) ---
//     // Se a animação estiver completa, desenha o contorno por cima do preenchimento final sólido
//     // para garantir que ele fique nítido, especialmente se o stroke e fill forem da mesma cor.
//     if (overallProgress >= 1.0 ||
//         animationStatus == AnimationStatus.completed) {
//       // Redesenha o preenchimento sólido final por baixo
//       canvas.drawPath(transformedOriginalPath, fillPaint);
//       // Redesenha o contorno por cima
//       canvas.drawPath(transformedOriginalPath, strokePaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant HandwritingPainter oldDelegate) {
//     return oldDelegate.animationController.value != animationController.value ||
//         oldDelegate.animationController.status != animationController.status ||
//         oldDelegate.originalPath != originalPath ||
//         oldDelegate.strokePaint != strokePaint ||
//         oldDelegate.fillPaint != fillPaint;
//   }
// }
