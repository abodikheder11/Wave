import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VoiceMessageProvider with ChangeNotifier {
  final Record _audioRecorder = Record();
  bool _isRecording = false;
  String? _filePath;

  bool get isRecording => _isRecording;

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        _filePath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          path: _filePath,
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100,
        );
        _isRecording = true;
        notifyListeners();
        print('Start recording');
      }
    } catch (e) {
      print('Error starting recording: $e');
      _isRecording = false;
      notifyListeners();
    }
  }

  Future<String?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _isRecording = false;
      notifyListeners();
      if (path != null) {
        print('Recording stopped and saved at: $path');
        return path;
      } else {
        print('Recording failed to save');
        return null;
      }
    } catch (e) {
      print('Error stopping recording: $e');
      _isRecording = false;
      notifyListeners();
      return null;
    }
  }
}
