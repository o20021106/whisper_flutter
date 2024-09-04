#ifndef WAVREADER_H
#define WAVREADER_H

#include <string>
#include <vector>

class WavReader {
public:
    WavReader();

    bool read_wav(const std::string &fname, std::vector<float>& pcmf32, std::vector<std::vector<float>>& pcmf32s, bool stereo);
};

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer to WavReader
typedef struct WavReader WavReader;

// Create a new WavReader instance
WavReader* wav_reader_create();

// Read WAV file
int wav_reader_read_wav(WavReader* reader, const char* fname, float** pcmf32, int* pcmf32_size, float*** pcmf32s, int* pcmf32s_size, int stereo);

// Free the WavReader instance
void wav_reader_free(WavReader* reader);

#ifdef __cplusplus
}
#endif

#endif // WAVREADER_H
