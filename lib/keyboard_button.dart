import 'package:bytepusher_emulator/memory.dart';
import 'package:flutter/material.dart';

class KeyboardButton extends StatelessWidget {
  final int address;
  final String label;

  const KeyboardButton({super.key, required this.address, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) {
        Memory.setKeyMem(address, 1);
      },
      onTapUp: (_) {
        Memory.setKeyMem(address, 0);
      },
      onTapCancel: () {
        Memory.setKeyMem(address, 0);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(),
        child: Center(
          child: Text(label),
        ),
      ),
    );
  }
}
