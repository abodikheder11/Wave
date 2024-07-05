import 'package:aboditest/bloc/Auth/authentication_bloc.dart';
import 'package:aboditest/presentation/themes/app_theme.dart';
import 'package:aboditest/presentation/themes/theme.dart';
import 'package:aboditest/presentation/widgets/splash_screen.dart';
import 'package:aboditest/utils/voice_Message_Recorder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/Chat_Bloc/chat_bloc.dart';
import 'bloc/Messaging/messaging_bloc.dart';
import 'data/services/user_repo.dart';

void main() {
  final userRepository = UserRepository(baseUrl: 'https://8240-188-139-225-43.ngrok-free.app');
  runApp(MyApp(userRepository: userRepository));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp({required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
        BlocProvider<MessagingBloc>(create: (context) => MessagingBloc()),
        ChangeNotifierProvider(create: (_) => VoiceMessageProvider()),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(userRepository: userRepository),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
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
