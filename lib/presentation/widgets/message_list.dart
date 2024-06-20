import 'package:flutter/material.dart';
import 'package:aboditest/data/models/messages.dart';
import '../widgets/message_item.dart';

class MessagesList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollController;
  final Map<int, GlobalKey> messageKeys;
  final Function(int, BuildContext) onLongPress;
  final Function(int) onDoubleTap;

  const MessagesList({
    required this.messages,
    required this.scrollController,
    required this.messageKeys,
    required this.onLongPress,
    required this.onDoubleTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (!messageKeys.containsKey(index)) {
          messageKeys[index] = GlobalKey();
        }
        final message = messages[index];
        return MessageItem(
          message: message,
          key: messageKeys[index]!,
          onLongPress: () => onLongPress(index, context),
          onDoubleTap: () => onDoubleTap(index),
        );
      },
    );
  }
}
