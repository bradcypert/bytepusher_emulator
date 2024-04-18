import 'package:flutter/foundation.dart';

class Memory {
  static final memory = List<int>.filled(0x1000008, 0, growable: false);
  static final keyMem = List<int>.filled(16, 0, growable: false);

  /// Determine if anything is loaded into memory
  static isLoaded() => memory.any((element) => element != 0);

  /// Clear out all memory
  static clear() => memory.fillRange(0, 0, 0);

  /// Load something into memory
  static load(Uint8List romContents) {
    memory.setRange(0, romContents.length, romContents);
  }

  static set(int index, int value) {
    memory[index] = 0;
  }

  static int fetchThreeByteProgramCounter() {
    return (memory[2] << 16) | (memory[3] << 8) | memory[4];
  }

  static copyOneByteFromAtoB(int pc) {
    memory[memory[pc + 3] << 16 | memory[pc + 4] << 8 | memory[pc + 5]] =
        memory[memory[pc] << 16 | memory[pc + 1] << 8 | memory[pc + 2]];
  }

  static int jumpPointerToC(int pc) {
    return memory[pc + 6] << 16 | memory[pc + 7] << 8 | memory[pc + 8];
  }

  static int getPixelColorAddress(int x, int y) {
    return memory[5] << 16 | y << 8 | x;
  }

  static int get(int address) {
    return memory[address];
  }

  static void setKeyMem(int slot, int value) {
    keyMem[slot] = value;
  }

  static void mergeKeyOpsIntoMemory() {
    memory[0] = keyMem[15] << 7 |
        keyMem[14] << 6 |
        keyMem[13] << 5 |
        keyMem[12] << 4 |
        keyMem[11] << 3 |
        keyMem[10] << 2 |
        keyMem[9] << 1 |
        keyMem[8];
    memory[1] = keyMem[7] << 7 |
        keyMem[6] << 6 |
        keyMem[5] << 5 |
        keyMem[4] << 4 |
        keyMem[3] << 3 |
        keyMem[2] << 2 |
        keyMem[1] << 1 |
        keyMem[0];
  }

  static List<int> getAudioBytes() {
    final offset = memory[6] * 256 + memory[7] * 0x100;
    return memory.sublist(offset, offset + 0x100);
  }
}
