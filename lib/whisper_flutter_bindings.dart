// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// Bindings for WhisperTranscriber
class WhisperTranscriberBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  WhisperTranscriberBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  WhisperTranscriberBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  ffi.Pointer<WhisperTranscriber> whisper_transcriber_create(
    ffi.Pointer<ffi.Char> model_path,
  ) {
    return _whisper_transcriber_create(
      model_path,
    );
  }

  late final _whisper_transcriber_createPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<WhisperTranscriber> Function(
              ffi.Pointer<ffi.Char>)>>('whisper_transcriber_create');
  late final _whisper_transcriber_create =
      _whisper_transcriber_createPtr.asFunction<
          ffi.Pointer<WhisperTranscriber> Function(ffi.Pointer<ffi.Char>)>();

  int whisper_transcriber_initialize(
    ffi.Pointer<WhisperTranscriber> transcriber,
  ) {
    return _whisper_transcriber_initialize(
      transcriber,
    );
  }

  late final _whisper_transcriber_initializePtr = _lookup<
          ffi
          .NativeFunction<ffi.Int Function(ffi.Pointer<WhisperTranscriber>)>>(
      'whisper_transcriber_initialize');
  late final _whisper_transcriber_initialize =
      _whisper_transcriber_initializePtr
          .asFunction<int Function(ffi.Pointer<WhisperTranscriber>)>();

  ffi.Pointer<ffi.Char> whisper_transcriber_transcribe(
    ffi.Pointer<WhisperTranscriber> transcriber,
    ffi.Pointer<ffi.Float> audio_data,
    int audio_data_length,
  ) {
    return _whisper_transcriber_transcribe(
      transcriber,
      audio_data,
      audio_data_length,
    );
  }

  late final _whisper_transcriber_transcribePtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<WhisperTranscriber>,
              ffi.Pointer<ffi.Float>,
              ffi.Int)>>('whisper_transcriber_transcribe');
  late final _whisper_transcriber_transcribe =
      _whisper_transcriber_transcribePtr.asFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<WhisperTranscriber>, ffi.Pointer<ffi.Float>, int)>();

  void whisper_transcriber_free(
    ffi.Pointer<WhisperTranscriber> transcriber,
  ) {
    return _whisper_transcriber_free(
      transcriber,
    );
  }

  late final _whisper_transcriber_freePtr = _lookup<
          ffi
          .NativeFunction<ffi.Void Function(ffi.Pointer<WhisperTranscriber>)>>(
      'whisper_transcriber_free');
  late final _whisper_transcriber_free = _whisper_transcriber_freePtr
      .asFunction<void Function(ffi.Pointer<WhisperTranscriber>)>();

  void whisper_free_string(
    ffi.Pointer<ffi.Char> str,
  ) {
    return _whisper_free_string(
      str,
    );
  }

  late final _whisper_free_stringPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Char>)>>(
          'whisper_free_string');
  late final _whisper_free_string = _whisper_free_stringPtr
      .asFunction<void Function(ffi.Pointer<ffi.Char>)>();

  late final ffi.Pointer<ffi.Int> _WavReader = _lookup<ffi.Int>('WavReader');

  int get WavReader => _WavReader.value;

  set WavReader(int value) => _WavReader.value = value;
}

final class WhisperTranscriber extends ffi.Opaque {}
