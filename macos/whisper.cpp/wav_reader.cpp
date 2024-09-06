#define DR_WAV_IMPLEMENTATION
#include "third_party/dr_wav.h"
#include "wav_reader.h"
#include <iostream>
#include <vector>

WavReader::WavReader() {}

bool WavReader::read_wav(const std::string &fname, std::vector<float> &pcmf32, std::vector<std::vector<float>> &pcmf32s, bool stereo)
{
    drwav wav;

    if (!drwav_init_file(&wav, fname.c_str(), nullptr))
    {
        std::cerr << "error: failed to open '" << fname << "' as WAV file\n";
        return false;
    }

    if (wav.channels != 1 && wav.channels != 2)
    {
        std::cerr << __func__ << ": WAV file must be mono or stereo\n";
        drwav_uninit(&wav);
        return false;
    }

    if (stereo && wav.channels != 2)
    {
        std::cerr << __func__ << ": WAV file must be stereo for diarization\n";
        drwav_uninit(&wav);
        return false;
    }

    if (wav.sampleRate != 16000)
    {
        std::cerr << __func__ << ": WAV file must be 16 kHz\n";
        drwav_uninit(&wav);
        return false;
    }

    if (wav.bitsPerSample != 16)
    {
        std::cerr << __func__ << ": WAV file must be 16-bit\n";
        drwav_uninit(&wav);
        return false;
    }

    const uint64_t n = wav.totalPCMFrameCount;

    std::vector<int16_t> pcm16(n * wav.channels);
    size_t framesRead = drwav_read_pcm_frames_s16(&wav, n, pcm16.data());
    drwav_uninit(&wav);

    if (framesRead != n)
    {
        std::cerr << "Error: only " << framesRead << " out of " << n << " frames read from WAV file." << std::endl;
        return false;
    }

    // Convert to mono, float
    pcmf32.resize(n);
    if (wav.channels == 1)
    {
        for (uint64_t i = 0; i < n; i++)
        {
            pcmf32[i] = float(pcm16[i]) / 32768.0f;
        }
    }
    else
    {
        for (uint64_t i = 0; i < n; i++)
        {
            pcmf32[i] = float(pcm16[2 * i] + pcm16[2 * i + 1]) / 65536.0f;
        }
    }

    if (stereo)
    {
        // Convert to stereo, float
        pcmf32s.resize(2);
        pcmf32s[0].resize(n);
        pcmf32s[1].resize(n);
        for (uint64_t i = 0; i < n; i++)
        {
            pcmf32s[0][i] = float(pcm16[2 * i]) / 32768.0f;
            pcmf32s[1][i] = float(pcm16[2 * i + 1]) / 32768.0f;
        }
    }

    return true;
}

extern "C"
{

    WavReader *wav_reader_create()
    {
        return new WavReader();
    }

    int wav_reader_read_wav(WavReader *reader, const char *fname, float **pcmf32, int *pcmf32_size, float ***pcmf32s, int *pcmf32s_size, int stereo)
    {
        if (!reader)
            return 0;

        std::vector<float> pcmf32_vec;
        std::vector<std::vector<float>> pcmf32s_vec;

        bool success = reader->read_wav(fname, pcmf32_vec, pcmf32s_vec, stereo != 0);

        if (success)
        {
            *pcmf32_size = pcmf32_vec.size();
            *pcmf32 = (float *)malloc(sizeof(float) * *pcmf32_size);
            std::memcpy(*pcmf32, pcmf32_vec.data(), sizeof(float) * *pcmf32_size);

            if (stereo)
            {
                *pcmf32s_size = pcmf32s_vec.size();
                *pcmf32s = (float **)malloc(sizeof(float *) * *pcmf32s_size);
                for (int i = 0; i < *pcmf32s_size; ++i)
                {
                    (*pcmf32s)[i] = (float *)malloc(sizeof(float) * pcmf32s_vec[i].size());
                    std::memcpy((*pcmf32s)[i], pcmf32s_vec[i].data(), sizeof(float) * pcmf32s_vec[i].size());
                }
            }
        }

        return success ? 1 : 0;
    }

    void wav_reader_free(WavReader *reader)
    {
        delete reader;
    }

    void free_float_array(float *arr)
    {
        free(arr);
    }

    void free_float_array_array(float **arr, int size)
    {
        for (int i = 0; i < size; ++i)
        {
            free(arr[i]);
        }
        free(arr);
    }
}