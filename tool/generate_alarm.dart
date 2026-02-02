import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

void main() {
  final file = File('assets/alarm.wav');
  final int sampleRate = 44100;
  // Make it exactly 1 second for easy looping
  final int durationSeconds = 1;
  final int numSamples = sampleRate * durationSeconds;
  final int numChannels = 1;
  final int byteRate = sampleRate * numChannels * 2; // 16-bit
  final int blockAlign = numChannels * 2;

  final int dataSize = numSamples * numChannels * 2;
  final int fileSize = 36 + dataSize;

  final buffer = BytesBuilder();

  // RIFF header
  buffer.add('RIFF'.codeUnits);
  buffer.addByte(fileSize & 0xFF);
  buffer.addByte((fileSize >> 8) & 0xFF);
  buffer.addByte((fileSize >> 16) & 0xFF);
  buffer.addByte((fileSize >> 24) & 0xFF);
  buffer.add('WAVE'.codeUnits);

  // fmt chunk
  buffer.add('fmt '.codeUnits);
  buffer.addByte(16);
  buffer.addByte(0);
  buffer.addByte(0);
  buffer.addByte(0); // Chunk size (16)
  buffer.addByte(1);
  buffer.addByte(0); // Audio format (1 = PCM)
  buffer.addByte(numChannels);
  buffer.addByte(0);
  buffer.addByte(sampleRate & 0xFF);
  buffer.addByte((sampleRate >> 8) & 0xFF);
  buffer.addByte((sampleRate >> 16) & 0xFF);
  buffer.addByte((sampleRate >> 24) & 0xFF);
  buffer.addByte(byteRate & 0xFF);
  buffer.addByte((byteRate >> 8) & 0xFF);
  buffer.addByte((byteRate >> 16) & 0xFF);
  buffer.addByte((byteRate >> 24) & 0xFF);
  buffer.addByte(blockAlign);
  buffer.addByte(0);
  buffer.addByte(16);
  buffer.addByte(0); // Bits per sample

  // data chunk
  buffer.add('data'.codeUnits);
  buffer.addByte(dataSize & 0xFF);
  buffer.addByte((dataSize >> 8) & 0xFF);
  buffer.addByte((dataSize >> 16) & 0xFF);
  buffer.addByte((dataSize >> 24) & 0xFF);

  // Alarm Pattern: Beep (0.2s) - Silence (0.1s) - Beep (0.2s) - Silence (0.5s)
  // Frequency: 880Hz (A5)
  for (int i = 0; i < numSamples; i++) {
    double t = i / sampleRate;
    double freq = 0;

    if (t < 0.2) {
      freq = 880.0;
    } else if (t < 0.3) {
      freq = 0;
    } else if (t < 0.5) {
      freq = 880.0;
    } else {
      freq = 0;
    }

    int value = 0;
    if (freq > 0) {
      double sample = sin(2 * pi * freq * t);
      // Simple envelope to avoid clicking at start/end of tones
      // But keeping it simple for now, just raw sine
      value = (sample * 30000).round();
    }

    buffer.addByte(value & 0xFF);
    buffer.addByte((value >> 8) & 0xFF);
  }

  file.writeAsBytesSync(buffer.toBytes());
  print('Generated assets/alarm.wav');
}
