import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'whisper_flutter_bindings.dart';

class WhisperFlutter {
  late final WhisperTranscriberBindings _bindings;
  ffi.Pointer<WhisperTranscriber>? _transcriber;

  WhisperFlutter() {
    _bindings = WhisperTranscriberBindings(ffi.DynamicLibrary.process());
  }

  Future<void> initialize(String modelPath) async {
    print('Creating transcriber with model path: $modelPath');
    final modelPathPointer = modelPath.toNativeUtf8().cast<ffi.Char>();
    _transcriber = _bindings.whisper_transcriber_create(modelPathPointer);
    calloc.free(modelPathPointer);

    if (_transcriber == null || _transcriber!.address == 0) {
      throw Exception('Failed to create transcriber');
    }

    print('Transcriber created successfully, now initializing...');
    final result = _bindings.whisper_transcriber_initialize(_transcriber!);
    print('Initialization result: $result');

    if (result == 0) {
      throw Exception('Failed to initialize transcriber. Error code: $result');
    }

    print('Transcriber initialized successfully');
  }

  String transcribe(List<double> audioData) {
    if (_transcriber == null) {
      throw StateError('Transcriber not initialized');
    }

    final audioDataPointer = calloc<ffi.Float>(audioData.length);
    audioDataPointer.asTypedList(audioData.length).setAll(0, audioData);

    final resultPointer = _bindings.whisper_transcriber_transcribe(
      _transcriber!,
      audioDataPointer,
      audioData.length,
    );

    final result = resultPointer.cast<Utf8>().toDartString();
    _bindings.whisper_free_string(resultPointer);
    calloc.free(audioDataPointer);

    return result;
  }

  void dispose() {
    if (_transcriber != null) {
      _bindings.whisper_transcriber_free(_transcriber!);
      _transcriber = null;
    }
  }
}
