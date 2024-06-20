import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userProfile', json.encode(profile.toJson()));
  }

  Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userProfileData = prefs.getString('userProfile');
    if (userProfileData != null) {
      return UserProfile.fromJson(json.decode(userProfileData));
    }
    return null;
  }
}

class UserProfile {
  String fullName;
  String email;
  String statusMessage;
  String profilePictureUrl;

  UserProfile({
    required this.fullName,
    required this.email,
    this.statusMessage = '',
    this.profilePictureUrl = '',
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'statusMessage': statusMessage,
    'profilePictureUrl': profilePictureUrl,
  };

  static UserProfile fromJson(Map<String, dynamic> json) => UserProfile(
    fullName: json['fullName'],
    email: json['email'],
    statusMessage: json['statusMessage'],
    profilePictureUrl: json['profilePictureUrl'],
  );
}
class UserProfileScreen extends StatefulWidget {
  final Key? key;

  UserProfileScreen({this.key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late UserProfile userProfile;
  final ImagePicker _picker = ImagePicker();
  final LocalStorageService _localStorageService = LocalStorageService();
  bool isLoading = true;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _statusMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profile = await _localStorageService.getUserProfile();
    if (profile != null) {
      setState(() {
        userProfile = profile;
        _fullNameController.text = userProfile.fullName;
        _emailController.text = userProfile.email;
        _statusMessageController.text = userProfile.statusMessage;
        isLoading = false;
      });
    } else {
      setState(() {
        userProfile = UserProfile(
          fullName: '',
          email: '',
          statusMessage: '',
          profilePictureUrl: '',
        );
        isLoading = false;
      });
    }
  }

  Future<void> _saveUserProfile() async {
    userProfile.fullName = _fullNameController.text;
    userProfile.email = _emailController.text;
    userProfile.statusMessage = _statusMessageController.text;
    await _localStorageService.saveUserProfile(userProfile);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved!')));
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        userProfile.profilePictureUrl = image.path; // For demonstration; normally you'd upload this to a server
      });
      await _saveUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Color(0xFF0D1B24) : Color(0xFF6CCFF6);
    final backgroundColor = isDarkMode ? Color(0xFF0D1B24) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: userProfile.profilePictureUrl.isNotEmpty
                    ? FileImage(File(userProfile.profilePictureUrl))
                    : null,
                child: userProfile.profilePictureUrl.isEmpty
                    ? Icon(Icons.person, size: 50, color: textColor)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: isDarkMode ? Color(0xFF1C2A32) : Color(0xFFF2F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: isDarkMode ? Color(0xFF1C2A32) : Color(0xFFF2F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _statusMessageController,
              decoration: InputDecoration(
                labelText: 'Status Message',
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: isDarkMode ? Color(0xFF1C2A32) : Color(0xFFF2F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveUserProfile();
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                onPrimary: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _statusMessageController.dispose();
    super.dispose();
  }
}
