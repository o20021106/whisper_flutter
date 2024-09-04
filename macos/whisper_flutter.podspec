#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint whisper_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'whisper_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for Whisper speech recognition.'
  s.description      = <<-DESC
A Flutter plugin that integrates OpenAI's Whisper model for speech recognition, including WAV file reading capabilities.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*',
                   'whisper.cpp/src/whisper.cpp',
                   'whisper.cpp/ggml/src/ggml.c',
                   'whisper.cpp/ggml/src/ggml-alloc.c',
                   'whisper.cpp/ggml/src/ggml-backend.c',
                   'whisper.cpp/ggml/src/ggml-metal.m',
                   'whisper.cpp/ggml/src/ggml-quants.c',
                   'whisper.cpp/ggml/src/ggml-aarch64.c',
                   'third_party/*.h'

  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.swift_version = '5.0'

  s.library = 'c++'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'USER_HEADER_SEARCH_PATHS' => [
      '$(PODS_TARGET_SRCROOT)/Classes',
      '$(PODS_TARGET_SRCROOT)/Classes/third_party',  
      '$(PODS_TARGET_SRCROOT)/whisper.cpp/ggml/include',
      '$(PODS_TARGET_SRCROOT)/whisper.cpp/include',
      '$(PODS_TARGET_SRCROOT)/whisper.cpp/src',
      '$(PODS_TARGET_SRCROOT)/whisper.cpp/**/*.h'
    ],
    'HEADER_SEARCH_PATHS' => [
      '$(PODS_TARGET_SRCROOT)/Classes',
      '$(PODS_TARGET_SRCROOT)/Classes/third_party',  
      '$(PODS_TARGET_SRCROOT)/whisper.cpp/ggml/include',
      '$(PODS_TARGET_SRCROOT)/whisper.cpp/include',
      '$(PODS_TARGET_SRCROOT)/whisper.cpp/src',
      '$(PODS_TARGET_SRCROOT)/whisper.cpp/**/*.h'
    ],
    # -w is to suppress warnings from whisper.cpp, there's tons of them
    'OTHER_CFLAGS' => ['$(inherited)', '-O3', '-flto', '-fno-objc-arc', '-w', '-I$(PODS_TARGET_SRCROOT)/whisper.cpp/include', '-I$(PODS_TARGET_SRCROOT)/whisper.cpp/ggml/include'],
    'OTHER_CPLUSPLUSFLAGS' => ['$(inherited)', '-O3', '-flto', '-fno-objc-arc', '-w', '-I$(PODS_TARGET_SRCROOT)/whisper.cpp/include', '-I$(PODS_TARGET_SRCROOT)/whisper.cpp/ggml/include'],
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
    'CLANG_CXX_LIBRARY' => 'libc++',
    'MACOSX_DEPLOYMENT_TARGET' => '10.11'
  }

  # This is to ensure that the pod target has C++ enabled
  s.requires_arc = false
end