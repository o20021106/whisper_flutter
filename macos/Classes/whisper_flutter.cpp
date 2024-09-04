#include "../whisper.cpp/include/whisper.h"
#include <cstring>
#include <vector>
#include <iostream>
#include <memory>

class WhisperTranscriber
{
private:
    std::string model_path;
    whisper_context *ctx;

public:
    WhisperTranscriber(const std::string &model_path)
        : model_path(model_path), ctx(nullptr) {}

    ~WhisperTranscriber()
    {
        if (ctx)
        {
            whisper_free(ctx);
        }
    }

    bool initialize()
    {
        whisper_context_params ctx_params = whisper_context_default_params();
        ctx = whisper_init_from_file_with_params(model_path.c_str(), ctx_params);

        if (!ctx)
        {
            std::cerr << "Failed to initialize Whisper context from file: " << model_path << std::endl;
        }

        return ctx != nullptr;
    }

    std::string transcribe(const std::vector<float> &audio_data)
    {
        if (!ctx)
        {
            std::cerr << "Whisper context is not initialized\n";
            return "";
        }

        if (audio_data.empty())
        {
            std::cerr << "Error: audio_data is empty" << std::endl;
            return "";
        }

        whisper_full_params wparams = whisper_full_default_params(WHISPER_SAMPLING_GREEDY);
        wparams.print_realtime = true;
        wparams.print_progress = true;
        wparams.print_timestamps = true;

        if (whisper_full(ctx, wparams, audio_data.data(), audio_data.size()) != 0)
        {
            std::cerr << "Failed to run Whisper transcription\n";
            return "";
        }

        std::string result;
        const int n_segments = whisper_full_n_segments(ctx);
        for (int i = 0; i < n_segments; ++i)
        {
            const char *text = whisper_full_get_segment_text(ctx, i);
            result += text;
            result += "\n";
        }

        return result;
    }
};

// C-compatible wrapper functions
extern "C"
{

    WhisperTranscriber *whisper_transcriber_create(const char *model_path)
    {
        return new WhisperTranscriber(model_path);
    }

    int whisper_transcriber_initialize(WhisperTranscriber *transcriber)
    {
        return transcriber->initialize() ? 1 : 0;
    }

    const char *whisper_transcriber_transcribe(WhisperTranscriber *transcriber, const float *audio_data, int audio_data_length)
    {
        std::vector<float> audio_vec(audio_data, audio_data + audio_data_length);
        std::string result = transcriber->transcribe(audio_vec);
        char *cstr = new char[result.length() + 1];
        std::strcpy(cstr, result.c_str());
        return cstr;
    }

    void whisper_transcriber_free(WhisperTranscriber *transcriber)
    {
        delete transcriber;
    }

    void whisper_free_string(char *str)
    {
        delete[] str;
    }
}