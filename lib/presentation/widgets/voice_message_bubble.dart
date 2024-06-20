import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceMessageBubble extends StatefulWidget {
  final String filePath;
  final bool isCurrentUser;

  const VoiceMessageBubble({
    required this.filePath,
    required this.isCurrentUser,
    Key? key,
  }) : super(key: key);

  @override
  _VoiceMessageBubbleState createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setSourceDeviceFile(widget.filePath);
    _audioPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => _position = p));
    _audioPlayer.onPlayerComplete.listen((_) => setState(() {
      _isPlaying = false;
      _position = Duration.zero;
    }));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(DeviceFileSource(widget.filePath));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: widget.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: widget.isCurrentUser
              ? (isDarkMode ? Color(0xFF6CCFF6) : Color(0xFF6CCFF6))
              : (isDarkMode ? Color(0xFF5E798E) : Color(0xFF8DA2B3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: widget.isCurrentUser ? Colors.white : Colors.black),
              onPressed: _togglePlayPause,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      final position = Duration(seconds: value.toInt());
                      _audioPlayer.seek(position);
                      setState(() {
                        _position = position;
                      });
                    },
                  ),
                  Text(
                    "${_position.toString().split('.').first} / ${_duration.toString().split('.').first}",
                    style: TextStyle(
                      color: widget.isCurrentUser ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
