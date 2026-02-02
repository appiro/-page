import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() {
  final file = File('assets/alarm.wav');
  if (!file.parent.existsSync()) {
    file.parent.createSync(recursive: true);
  }

  final sampleRate = 44100;
  final duration = 2.0; // 2 seconds
  final numSamples = (sampleRate * duration).toInt();
  final frequency = 880.0; // A5 (High pitch)

  final dataSize = numSamples * 2; // 16-bit
  final fileSize = 36 + dataSize;

  final buffer = BytesBuilder();

  // RIFF header
  buffer.add('RIFF'.codeUnits);
  buffer.add(_int32(fileSize));
  buffer.add('WAVE'.codeUnits);

  // fmt chunk
  buffer.add('fmt '.codeUnits);
  buffer.add(_int32(16)); // Chunk size
  buffer.add(_int16(1)); // PCM
  buffer.add(_int16(1)); // 1 channel
  buffer.add(_int32(sampleRate));
  buffer.add(_int32(sampleRate * 2)); // Byte rate
  buffer.add(_int16(2)); // Block align
  buffer.add(_int16(16)); // Bits per sample

  // data chunk
  buffer.add('data'.codeUnits);
  buffer.add(_int32(dataSize));

  // Generate sine wave
  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    // Intermittent beep (phone call like: Beep-Beep... Beep-Beep...)
    // 0.0-0.4: Beep
    // 0.4-0.5: Silence
    // 0.5-0.9: Beep
    // 0.9-1.0: Silence

    // Cycle is 1 second
    final cycleT = t % 1.0;
    double sample = 0;

    if (cycleT < 0.4 || (cycleT > 0.5 && cycleT < 0.9)) {
      sample = sin(2 * pi * frequency * t);
    }

    final int16Sample = (sample * 32767).toInt();
    buffer.add(_int16(int16Sample));
  }

  file.writeAsBytesSync(buffer.toBytes());
  print('Generated ${file.path}');
}

List<int> _int32(int value) {
  final b = ByteData(4);
  b.setInt32(0, value, Endian.little);
  return b.buffer.asUint8List();
}

List<int> _int16(int value) {
  final b = ByteData(2);
  b.setInt16(0, value, Endian.little);
  return b.buffer.asUint8List();
}
