import 'package:aboditest/bloc/Auth/authentication_bloc.dart';
import 'package:aboditest/bloc/Auth/authentication_event.dart';
import 'package:aboditest/presentation/screens/log_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:aboditest/presentation/screens/conversation_screen.dart';
import 'package:aboditest/presentation/screens/settings.dart';
import 'package:aboditest/presentation/screens/user_profile.dart';
import 'package:aboditest/data/models/conversation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'about.dart';
import 'contacts-list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<Conversation> conversations = [
  Conversation(name: "Abodi", lastMessage: "hi", imageURL: "images/abodi.jpg", timeStamp: "10:00 am", lastSeen: "today at 8:00 am", unreadCount: 2),
  Conversation(name: "ragh", lastMessage: "hel", imageURL: "images/abodi.jpg", timeStamp: "10:00 am", lastSeen: "today at 8:00 am", unreadCount: 3),
  Conversation(name: "fad", lastMessage: "hgferwa", imageURL: "images/hello.jpg", timeStamp: "9:00 am", lastSeen: "today at 8:00 am", unreadCount: 4),
];
int _selectedIndex = 0;
PageController _pageController = PageController();

class _HomePageState extends State<HomePage> {
  List<Conversation> filteredConversations = [];
  TextEditingController searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    filteredConversations = conversations;
    searchController.addListener(_filterConversations);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterConversations);
    searchController.dispose();
    super.dispose();
  }

  void _filterConversations() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredConversations = conversations.where((conversation) {
        return conversation.name.toLowerCase().contains(query) || conversation.lastMessage.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode ? Color(0xFF0A161C) : theme.colorScheme.primary,
        leading: _isSearchVisible
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearchVisible = false;
              searchController.clear();
              filteredConversations = conversations;
            });
          },
        )
            : null,
        title: _isSearchVisible
            ? Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: "Search...",
              hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white70 : Colors.black),
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            ),
            style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
          ),
        )
            : const Text("Waves"),
        actions: _isSearchVisible
            ? []
            : [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera)),
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchVisible = true;
              });
            },
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'Settings') {
                Navigator.push(context, MaterialPageRoute(builder: (c) => SettingsPage()));
              }
              if (choice == 'About') {
                Navigator.push(context, MaterialPageRoute(builder: (c) => AboutScreen()));
              }
              if (choice == 'Profile') {
                Navigator.push(context, MaterialPageRoute(builder: (c) => UserProfileScreen()));
              }
              if (choice == 'Logout') {
                BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
                Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'About',
                child: Text('About'),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _selectedIndex == 0
            ? ListView.builder(
          key: ValueKey(0),
          padding: const EdgeInsets.only(top: 10),
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            Conversation conversation = conversations[index];
            return ListTile(
              leading: Stack(children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(conversation.imageURL),
                ),
                if (conversation.unreadCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFF6CCFF6),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        conversation.unreadCount.toString(),
                        style: TextStyle(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  )
              ]),
              title: Text(
                conversation.name,
                style: TextStyle(
                    fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.normal),
              ),
              subtitle: Text(
                conversation.lastMessage,
                style: TextStyle(
                    fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                    color: conversation.unreadCount > 0 ? theme.colorScheme.onSurface : null),
              ),
              trailing: Text(
                conversation.timeStamp,
                style: TextStyle(
                    color: conversation.unreadCount > 0
                        ?  Color(0xFF6CCFF6)
                        : isDarkMode ? Colors.white : Colors.black ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => ConversationScreen(conversation)));
                setState(() {
                  conversation.unreadCount = 0;
                });
              },
            );
          },
        )
            : UserProfileScreen(key: ValueKey(1)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF6CCFF6),
        onTap: _onItemTapped,
        backgroundColor: isDarkMode ? Color(0xFF0A161C) : theme.colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (c) => ContactsListPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: isDarkMode ? Color(0xff1092c4) : theme.colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
