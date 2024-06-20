import 'package:flutter/material.dart';
import 'package:aboditest/data/models/conversation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConversationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Conversation conversation;
  final bool isSearchVisible;
  final Function onSearchPressed;
  final Function onCloseSearchPressed;
  final Function onSearchTextChanged;

  const ConversationAppBar({
    required this.conversation,
    required this.isSearchVisible,
    required this.onSearchPressed,
    required this.onCloseSearchPressed,
    required this.onSearchTextChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return AppBar(
      backgroundColor: isDarkMode ? Color(0xFF0A161C) : Color(0xFFF2F3F5),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: iconColor),
      ),
      title: isSearchVisible
          ? Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: TextField(
          controller: TextEditingController(),
          onChanged: (text) => onSearchTextChanged(text),
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white70),
            contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          ),
          style: TextStyle(color: Colors.white),
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(conversation.imageURL),
            minRadius: 20,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversation.name,
                style: TextStyle(
                  fontSize: 20,
                  color: isDarkMode ? Color(0xFFFFFFFF) : Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                conversation.lastSeen,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Color(0xFFB0B3B5) : Color(0xFF666666),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'San Francisco',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: isSearchVisible
          ? [
        IconButton(
          icon: Icon(Icons.close, color: iconColor),
          onPressed: () {
            onCloseSearchPressed();
          },
        )
      ]
          : [
        IconButton(
          onPressed: () {},
          icon: Icon(FontAwesomeIcons.video, size: 20, color: iconColor),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(FontAwesomeIcons.phone, size: 20, color: iconColor),
        ),
        PopupMenuButton<String>(
          icon: Icon(FontAwesomeIcons.ellipsis, color: iconColor),
          onSelected: (value) {
            if (value == 'search') {
              onSearchPressed();
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                child: Text("Search"),
                value: 'search',
              ),
            ];
          },
        ),
      ],
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
