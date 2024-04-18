import 'package:just_audio/just_audio.dart';

class ByteStream extends StreamAudioSource {
  final List<int> bytes;
  ByteStream({required this.bytes});

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

class AudioEngine {
  static final player = AudioPlayer();

  static playBytes(List<int> bytes) {
    player.setAudioSource(ByteStream(bytes: bytes));
    player.play();
  }
}
