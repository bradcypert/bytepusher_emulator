import 'dart:async';

import 'package:flutter/widgets.dart';

class BytePusherPainterNotifier extends ChangeNotifier {
  late Timer timer;
  static const fps = 60;
  static const fpms = (1000 / fps) * 100;

  BytePusherPainterNotifier() {
    timer = Timer.periodic(Duration(microseconds: fpms.toInt()), (timer) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class BytePusherPainter extends CustomPainter {
  final List<List<(int, int, int)>> videoBuffer;

  BytePusherPainter({required this.videoBuffer})
      : super(repaint: BytePusherPainterNotifier());

  // "pixel" dimensions
  static const width = 256;
  static const height = 256;

  @override
  void paint(Canvas canvas, Size size) {
    for (var x = 0; x < 256; x++) {
      for (var y = 0; y < 256; y++) {
        final (r, g, b) = videoBuffer[x][y];
        _drawPixel(canvas, size, x.toDouble(), y.toDouble(),
            Color.fromARGB(255, r, g, b));
      }
    }
  }

  _drawPixel(Canvas canvas, Size size, double x, double y, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final widthFactor = width / size.width;
    final heightFactor = height / size.height;
    final scaledX = x / widthFactor;
    final scaledY = y / heightFactor;

    canvas.drawRect(
        Rect.fromLTWH(scaledX, scaledY, 1 / widthFactor, 1 / heightFactor),
        paint);
  }

  @override
  bool shouldRepaint(BytePusherPainter oldDelegate) => true;
}
