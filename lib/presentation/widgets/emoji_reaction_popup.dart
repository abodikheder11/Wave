
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmojiReactionPopup extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const EmojiReactionPopup({super.key, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Text('👍', style: TextStyle(fontSize: 24)),
            onPressed: () => onEmojiSelected('👍'),
          ),
          IconButton(
            icon: const Text('❤️', style: TextStyle(fontSize: 24)),
            onPressed: () => onEmojiSelected('❤️'),
          ),
          IconButton(
            icon: const Text('😂', style: TextStyle(fontSize: 24)),
            onPressed: () => onEmojiSelected('😂'),
          ),
          IconButton(
            icon: const Text('😮', style: TextStyle(fontSize: 24)),
            onPressed: () => onEmojiSelected('😮'),
          ),
          IconButton(
            icon: const Text('😢', style: TextStyle(fontSize: 24)),
            onPressed: () => onEmojiSelected('😢'),
          ),
          IconButton(
            icon: const Text('🙏', style: TextStyle(fontSize: 24)),
            onPressed: () => onEmojiSelected('🙏'),
          ),
        ],
      ),
    );
  }
}