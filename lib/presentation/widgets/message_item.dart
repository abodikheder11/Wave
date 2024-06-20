import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'dart:ui' as ui;
import '../../data/models/messages.dart';
import 'voice_message_bubble.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final GlobalKey key;
  final Function onLongPress;
  final Function onDoubleTap;
  final bool isHighlighted;

  const MessageItem({
    required this.message,
    required this.key,
    required this.onLongPress,
    required this.onDoubleTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    bool isVoiceMessage = message.text.endsWith('.m4a');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        key: key,
        onTap: () => onLongPress(),
        onDoubleTap: () => onDoubleTap(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              color: isHighlighted ? Colors.yellow.withOpacity(0.3) : Colors.transparent,
              child: isVoiceMessage
                  ? VoiceMessageBubble(
                filePath: message.text,
                isCurrentUser: message.isCurrentUser,
              )
                  : ChatBubble(
                margin: const EdgeInsets.all(10),
                clipper: message.isCurrentUser
                    ? ChatBubbleClipper5(type: BubbleType.sendBubble)
                    : ChatBubbleClipper5(type: BubbleType.receiverBubble),
                alignment: message.isCurrentUser ? Alignment.topRight : Alignment.topLeft,
                backGroundColor: message.isCurrentUser
                    ? (isDarkMode ? Color(0xFF6CCFF6) : Color(0xFF6CCFF6))
                    : (isDarkMode ? Color(0xFF5E798E) : Color(0xFF8DA2B3)),
                child: Column(
                  crossAxisAlignment: message.isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.isCurrentUser
                              ? Colors.white
                              : (isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          message.timestamp,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        ),
                        if (message.isCurrentUser) ...[
                          const SizedBox(width: 5),
                          _buildStatusIcon(message.status),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (message.reaction != null)
              Positioned(
                bottom: -10,
                right: message.isCurrentUser ? 10 : null,
                left: message.isCurrentUser ? null : 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    message.reaction!,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.check, color: Colors.grey, size: 12);
      case MessageStatus.received:
        return const Icon(Icons.check_circle, color: Colors.grey, size: 12);
      case MessageStatus.read:
        return const Icon(Icons.check_circle, color: Color(0xFF009688), size: 12); // Teal color
      default:
        return Container();
    }
  }
}
