#ifndef WHISPER_TRANSCRIBER_H
#define WHISPER_TRANSCRIBER_H

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct WhisperTranscriber WhisperTranscriber;

    WhisperTranscriber *whisper_transcriber_create(const char *model_path);
    int whisper_transcriber_initialize(WhisperTranscriber *transcriber);
    const char *whisper_transcriber_transcribe(WhisperTranscriber *transcriber, const float *audio_data, int audio_data_length);
    void whisper_transcriber_free(WhisperTranscriber *transcriber);
    void whisper_free_string(char *str);

#ifdef __cplusplus
}
#endif

#endif // WHISPER_TRANSCRIBER_H