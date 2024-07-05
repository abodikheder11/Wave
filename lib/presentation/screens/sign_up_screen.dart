import 'package:aboditest/bloc/Auth/authentication_bloc.dart';
import 'package:aboditest/bloc/Auth/authentication_event.dart';
import 'package:aboditest/bloc/Auth/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:button_animations/button_animations.dart';
import 'home_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (state is AuthenticationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signup Failure: ${state.error}')),
            );
            print('Signup Failure: ${state.error}');
          }
        },
        child: Stack(
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
                    padding: const EdgeInsets.only(top: 70, bottom: 20),
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
                  _buildTextInput('Full Name', controller: _fullNameController),
                  _buildTextInput('Username', controller: _usernameController),
                  _buildTextInput('Email', controller: _emailController),
                  _buildTextInput('Password', isPassword: true, controller: _passwordController),
                  _buildTextInput('Confirm Password', isPassword: true, controller: _confirmPasswordController),
                  _buildTextInput('Phone Number', controller: _phoneNumberController),
                  _buildTextInput("Gender", controller: _genderController),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AnimatedButton(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (c)=> HomePage()));
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match')),
                          );
                        } else {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            AuthenticationSignedUp(
                              fullName: _fullNameController.text,
                              username: _usernameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              confPassword: _confirmPasswordController.text,
                              phoneNumber: _phoneNumberController.text,
                              gender: _genderController.text,
                            ),
                          );
                        }
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
                      isOutline: true,
                      color: Color(0xFF6CCFF6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
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
      ),
    );
  }

  Widget _buildTextInput(String label, {bool isPassword = false, required TextEditingController controller}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: isPassword
            ? (label == 'Confirm Password' ? !_isConfirmPasswordVisible : !_isPasswordVisible)
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
          fillColor: isDarkMode ? Colors.white : Color(0xFFE3E4E8),
          filled: true,
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              (label == 'Confirm Password' ? _isConfirmPasswordVisible : !_isPasswordVisible)
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              setState(() {
                if (label == 'Confirm Password') {
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
