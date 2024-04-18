import 'package:bytepusher_emulator/frame.dart';
import 'package:bytepusher_emulator/virtual_machine.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bytepusher Emulator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Container(
        decoration: const BoxDecoration(color: Colors.blue),
        child: const Frame(
          child: VirtualMachine(),
        ),
      ),
    );
  }
}
