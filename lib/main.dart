import 'dart:ui';
import 'package:aboditest/presentation/screens/home_page.dart';
import 'package:aboditest/presentation/themes/app_theme.dart';
import 'package:aboditest/presentation/themes/theme.dart';
import 'package:aboditest/presentation/widgets/splash_screen.dart';
import 'package:aboditest/utils/voice_Message_Recorder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/Chat_Bloc/chat_bloc.dart';
import 'bloc/Messaging/messaging_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
        BlocProvider<MessagingBloc>(create: (context) => MessagingBloc()),
        ChangeNotifierProvider(create: (_) => VoiceMessageProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Waves',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
