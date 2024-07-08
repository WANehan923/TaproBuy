import 'package:flutter/material.dart';
import 'package:taprobuy/screens/LogIn.dart';
import 'package:taprobuy/screens/SignUp.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogIn(
        onTap: togglePages,
      );
    } else {
      return SignUp(
        onTap: togglePages,
      );
    }
  }
}
