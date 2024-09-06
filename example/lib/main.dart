import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whisper_flutter/whisper_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:wav/wav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Whisper Flutter Example')),
        body: const WhisperExample(),
      ),
    );
  }
}

class WhisperExample extends StatefulWidget {
  const WhisperExample({super.key});

  @override
  _WhisperExampleState createState() => _WhisperExampleState();
}

class _WhisperExampleState extends State<WhisperExample> {
  final _whisper = WhisperFlutter();

  @override
  void initState() {
    super.initState();
    _initializeWhisper();
  }

  Future<void> _initializeWhisper() async {
    try {
      print('Initializing Whisper...');
      final modelBytes = await rootBundle.load('assets/ggml-base.en.bin');
      final directory = await getTemporaryDirectory();
      final tempModelPath = '${directory.path}/temp_model.bin';

      print('Writing model to temporary file: $tempModelPath');
      await File(tempModelPath).writeAsBytes(modelBytes.buffer.asUint8List());

      await _whisper.initialize(tempModelPath);
      print('Whisper initialized successfully');
    } catch (e) {
      print('Error initializing Whisper: $e');
    }
  }

  Future<List<double>> _readWavFile(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final wav = Wav.read(bytes);
    final audioData = wav.channels.first;
    return audioData.map((e) => e.toDouble()).toList();
  }

  Future<void> _transcribe() async {
    try {
      print('Starting transcription...');

      const wavFileName = 'jfk.wav';
      final directory = await getApplicationDocumentsDirectory();
      final wavFilePath = '${directory.path}/$wavFileName';

      if (!await File(wavFilePath).exists()) {
        final byteData = await rootBundle.load('assets/$wavFileName');
        await File(wavFilePath).writeAsBytes(byteData.buffer.asUint8List());
      }

      // Read WAV file
      final audioData = await _readWavFile(wavFilePath);
      print('Audio data length: ${audioData.length}');
      print('Audio data length: ${audioData.length}');

      final result = _whisper.transcribe(audioData);
      print('Transcription result: $result');
    } catch (e) {
      print('Error during transcription: $e');
    }
  }

  @override
  void dispose() {
    _whisper.dispose();
    print('Whisper disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _transcribe,
        child: const Text('Transcribe'),
      ),
    );
  }
}
