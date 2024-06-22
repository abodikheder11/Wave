import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibration/vibration.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController messageController;
  final Function onSendPressed;
  final Function onAttachFilePressed;
  final Function onImagePressed;
  final Function onEmojiPickerPressed;
  final Function(bool) onVoiceMessageClosed; // Updated to accept a boolean parameter
  final Function onVoiceMessageStarted;
  final bool isRecording;

  const MessageInput({
    required this.messageController,
    required this.onSendPressed,
    required this.onAttachFilePressed,
    required this.onImagePressed,
    required this.onEmojiPickerPressed,
    required this.onVoiceMessageClosed,
    required this.onVoiceMessageStarted,
    Key? key,
    required this.isRecording,
  }) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  late Timer _timer;
  int _recordDuration = 0;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _recordDuration = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 3),
            child: TextField(
              controller: widget.messageController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: isDarkMode ? BorderSide.none : BorderSide(color: Color(0xffE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                  borderSide: isDarkMode ? BorderSide.none : BorderSide(color: Color(0xffE0E0E0)),
                ),
                contentPadding: EdgeInsets.zero,
                fillColor: isDarkMode ? Color(0xFF1C2A32) : Colors.white,
                filled: true,
                prefixIcon: widget.isRecording ? Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 7),
                  child: Text(
                    _formatDuration(_recordDuration),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 7),
                  child: Text(
                    _formatDuration(_recordDuration),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.paperclip, size: 20),
                      onPressed: () {
                        widget.onAttachFilePressed();
                      },
                      color: isDarkMode ? Colors.white : Colors.grey,
                    ),
                    GestureDetector(
                      onLongPressStart: (_) async {
                        if ((await Vibration.hasVibrator()) ?? false) {
                          Vibration.vibrate(duration: 50);
                        }
                        widget.onVoiceMessageStarted();
                        _startTimer();
                      },
                      onLongPressMoveUpdate: (details) {
                        if (details.localPosition.dx < -50) {
                          widget.onVoiceMessageClosed(true); // Cancel recording if dragged left
                          _stopTimer();
                        }
                      },
                      onLongPressEnd: (_) async {
                        if (widget.isRecording) {
                          await widget.onVoiceMessageClosed(false); // Send recording if released
                          _stopTimer();
                        }
                      },
                      child: _buildRecordingButton(context, isDarkMode),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                hintText: widget.isRecording ? "Swipe left to cancel" : "Message",
                hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: isDarkMode ? BorderSide.none : BorderSide(color: Color(0xffE0E0E0)),
                ),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: IconButton(
            icon: Icon(FontAwesomeIcons.circleArrowRight, size: 27),
            onPressed: () {
              widget.onSendPressed();
            },
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingButton(BuildContext context, bool isDarkMode) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: widget.isRecording
          ? Icon(Icons.stop, key: ValueKey('stop'), color: isDarkMode ? Colors.white : Colors.black, size: 25)
          : Icon(Icons.mic, key: ValueKey('mic'), color: isDarkMode ? Colors.white : Colors.black, size: 25),
    );
  }
}
