import 'package:aboditest/presentation/screens/home_page.dart';
import 'package:button_animations/button_animations.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late VideoPlayerController _controller;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: isDarkMode ? Color(0xFF0D1B24) : Colors.white,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 70 , bottom: 20),
                  child: Image.asset("images/sign_up.png", scale: 5),
                ),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Color(0xFF1E1E1E),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextInput('Full Name'),
                _buildTextInput('Email'),
                _buildTextInput('Password', isPassword: true, isConfirmPassword: false),
                _buildTextInput('Confirm Password', isPassword: true, isConfirmPassword: true),
                _buildTextInput('Phone Number'),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: AnimatedButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (x) => const HomePage()));
                    },
                    type: null,
                    height: 50,
                    shadowHeightBottom: 0,
                    shadowHeightLeft: 0,
                    shadowColor: isDarkMode ? Color(0xFF0D1B24) : Colors.white,
                    width: 340,
                    borderRadius: 25,
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    darkShadow: false,
                    isOutline : true,
                    color:  Color(0xFF6CCFF6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white ,
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput(String label, {bool isPassword = false, bool isConfirmPassword = false}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        obscureText: isPassword
            ? (isConfirmPassword ? !_isConfirmPasswordVisible : !_isPasswordVisible)
            : false,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: label,
          labelStyle: TextStyle(color: isDarkMode ? Colors.black : Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isDarkMode ? theme.colorScheme.primary : theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: isDarkMode ? theme.colorScheme.primary : theme.colorScheme.primary),
          ),
          fillColor: isDarkMode ?  Colors.white : Color(0xFFE3E4E8),
          filled: true,
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              (isConfirmPassword ? _isConfirmPasswordVisible : _isPasswordVisible)
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              setState(() {
                if (isConfirmPassword) {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                } else {
                  _isPasswordVisible = !_isPasswordVisible;
                }
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
