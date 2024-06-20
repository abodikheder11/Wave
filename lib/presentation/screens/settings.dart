import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Notifications'),
            onTap: () {
              // Navigate to the notifications settings screen
              // You can implement navigation logic here
            },
          ),
          ListTile(
            title: Text('Privacy'),
            onTap: () {
              // Navigate to the privacy settings screen
              // You can implement navigation logic here
            },
          ),
          ListTile(
            title: Text('Theme'),
            onTap: () {
              // Navigate to the theme settings screen
              // You can implement navigation logic here
            },
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              // Navigate to the about screen
              // You can implement navigation logic here
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
