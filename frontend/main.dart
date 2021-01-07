import 'package:flutter/material.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:frontend/screens/registration_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/chat_screen.dart';

void main() => runApp(ChatApplication());

class ChatApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
