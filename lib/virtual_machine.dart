import 'dart:async';

import 'package:bytepusher_emulator/audio_engine.dart';
import 'package:bytepusher_emulator/bytepusher_painter.dart';
import 'package:bytepusher_emulator/memory.dart';
import 'package:flutter/material.dart';

class VirtualMachine extends StatefulWidget {
  const VirtualMachine({super.key});

  @override
  State<VirtualMachine> createState() => _VirtualMachineState();
}

class _VirtualMachineState extends State<VirtualMachine> {
  late Timer timer;
  static const fps = 60;
  List<List<(int, int, int)>> videoBuffer =
      List.generate(256, (index) => List.generate(256, (_) => (0, 0, 0)));

  _VirtualMachineState() {
    timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ fps), (timer) {
      List<List<(int, int, int)>> vbs =
          List.generate(256, (index) => List.generate(256, (_) => (0, 0, 0)));
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

            vbs[x][y] = color;
          }
        }
      }

      AudioEngine.playBytes(Memory.getAudioBytes());
      setState(() {
        videoBuffer = vbs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // Inner yellow container
      builder: (_, constraints) => Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: CustomPaint(
          painter: BytePusherPainter(videoBuffer: videoBuffer),
          willChange: true,
        ),
      ),
    );
  }
}
