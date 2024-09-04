import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:whisper_flutter/whisper_flutter_bindings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisper Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Whisper Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WhisperTranscriberBindings _bindings;
  late ffi.Pointer<WhisperTranscriber> _transcriber;
  String _transcription = '';
  bool _isTranscribing = false;

  @override
  void initState() {
    super.initState();
    _initializeWhisper();
  }

  Future<void> _initializeWhisper() async {
    final directory = await getApplicationDocumentsDirectory();
    final modelPath = '${directory.path}/whisper-model.bin';

    // Ensure that the model file is available at this path
    // You might want to add code here to download the model if it doesn't exist

    // Load the dynamic library
    final dylib = ffi.DynamicLibrary.open(
        'libwhisper_flutter.dylib'); // Update this to match your actual library name
    _bindings = WhisperTranscriberBindings(dylib);

    // Create and initialize the transcriber
    final modelPathPointer = modelPath.toNativeUtf8();
    _transcriber =
        _bindings.whisper_transcriber_create(modelPathPointer.cast());
    calloc.free(modelPathPointer);

    final result = _bindings.whisper_transcriber_initialize(_transcriber);
    if (result != 0) {
      print('Whisper initialized successfully');
    } else {
      print('Failed to initialize Whisper');
    }
  }

  Future<void> _transcribeAudio() async {
    setState(() {
      _isTranscribing = true;
      _transcription = '';
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wav'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        List<double> audioData = await _readWavFile(file);

        final audioDataPointer = calloc<ffi.Float>(audioData.length);
        final audioDataArray = audioDataPointer.asTypedList(audioData.length);
        audioDataArray.setAll(0, audioData);

        final transcriptionPointer = _bindings.whisper_transcriber_transcribe(
          _transcriber,
          audioDataPointer,
          audioData.length,
        );

        _transcription = transcriptionPointer.cast<Utf8>().toDartString();
        _bindings.whisper_free_string(transcriptionPointer);
        calloc.free(audioDataPointer);
      } else {
        _transcription = 'No file selected';
      }
    } catch (e) {
      _transcription = 'Error during transcription: $e';
    } finally {
      setState(() {
        _isTranscribing = false;
      });
    }
  }

  Future<List<double>> _readWavFile(File file) async {
    // This is a placeholder. You'll need to implement proper WAV file reading.
    // The actual implementation will depend on the specific WAV format you're using.
    // You might want to use a package like `wav` for this.
    final bytes = await file.readAsBytes();
    return bytes.map((e) => e.toDouble() / 255).toList();
  }

  @override
  void dispose() {
    _bindings.whisper_transcriber_free(_transcriber);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isTranscribing ? null : _transcribeAudio,
              child:
                  Text(_isTranscribing ? 'Transcribing...' : 'Select WAV File'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_transcription),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
