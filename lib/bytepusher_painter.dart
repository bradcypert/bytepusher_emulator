import 'dart:async';

import 'package:bytepusher_emulator/memory.dart';
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
  BytePusherPainter() : super(repaint: BytePusherPainterNotifier());

  // "pixel" dimensions
  static const width = 256;
  static const height = 256;

  @override
  void paint(Canvas canvas, Size size) {
    if (Memory.isLoaded()) {
      // handle keys
      Memory.mergeKeyOpsIntoMemory();

      var pc = Memory.fetchThreeByteProgramCounter();

      for (var i = 0; i < 65536; i++) {
        Memory.copyOneByteFromAtoB(pc);
        pc = Memory.jumpPointerToC(pc);
      }

      for (var x = 0; x < 256; x++) {
        for (var y = 0; y < 256; y++) {
          final pixelColorAddress = Memory.getPixelColorAddress(x, y);
          var color = (0, 0, 0);

          if (Memory.get(pixelColorAddress) < 216) {
            final blue = (Memory.get(pixelColorAddress) % 6) * 51;
            final green = ((Memory.get(pixelColorAddress) ~/ 6) % 6) * 51;
            final red = ((Memory.get(pixelColorAddress) ~/ 36) % 6) * 51;

            color = (red, green, blue);
          }

          _drawPixel(canvas, size, x.toDouble(), y.toDouble(),
              Color.fromARGB(255, color.$1, color.$2, color.$3));
        }
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
