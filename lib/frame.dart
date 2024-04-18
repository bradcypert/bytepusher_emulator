import 'dart:io';

import 'package:bytepusher_emulator/keyboard_button.dart';
import 'package:bytepusher_emulator/memory.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Frame extends StatelessWidget {
  final Widget child;

  const Frame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(child: child),
        Column(
          children: [
            MaterialButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  if (kIsWeb) {
                    final bytes = result.files.first.bytes;
                    Memory.clear();
                    Memory.load(bytes!);
                  } else {
                    final file = File(result.files.first.path!);
                    final bytes = await file.readAsBytes();
                    Memory.clear();
                    Memory.load(bytes);
                  }
                }
              },
              child: const Text("Insert ROM"),
            ),
            const Material(
              color: Colors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KeyboardButton(
                        label: "1",
                        address: 1,
                      ),
                      KeyboardButton(
                        label: "2",
                        address: 2,
                      ),
                      KeyboardButton(
                        label: "3",
                        address: 3,
                      ),
                      KeyboardButton(
                        label: "C",
                        address: 12,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KeyboardButton(
                        label: "4",
                        address: 4,
                      ),
                      KeyboardButton(
                        label: "5",
                        address: 5,
                      ),
                      KeyboardButton(
                        label: "6",
                        address: 6,
                      ),
                      KeyboardButton(
                        label: "D",
                        address: 13,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KeyboardButton(
                        label: "7",
                        address: 7,
                      ),
                      KeyboardButton(
                        label: "8",
                        address: 8,
                      ),
                      KeyboardButton(
                        label: "9",
                        address: 9,
                      ),
                      KeyboardButton(
                        label: "E",
                        address: 14,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KeyboardButton(
                        label: "A",
                        address: 10,
                      ),
                      KeyboardButton(
                        label: "0",
                        address: 0,
                      ),
                      KeyboardButton(
                        label: "B",
                        address: 11,
                      ),
                      KeyboardButton(
                        label: "F",
                        address: 15,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
