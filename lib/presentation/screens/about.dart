import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/abodi.jpg" ,scale: 3,), // Replace with your app logo
            const SizedBox(height: 20),
            const Text(
              'Hi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Version 1.0.0', // Replace with your app version
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Developed by Abodi Kheder', // Replace with developer info
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Visit Our Website which we don\'t have for sure'), // Button text
            ),
          ],
        ),
      ),
    );
  }
}
