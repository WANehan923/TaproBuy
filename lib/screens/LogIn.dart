import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taprobuy/color_schemes.g.dart';
import 'package:taprobuy/screens/SignUp.dart';

class LogIn extends StatefulWidget {
  final Function()? onTap;
  const LogIn({super.key, required this.onTap});

  @override
  State<LogIn> createState() => _LogInState();
}
class _LogInState extends State<LogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isObscuredText = true;

  void Login() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayErrorMessage(e.code);
    }
  }

  void displayErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            message,
          )),
        );
      },
    );
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("TaproBuy", style: TextStyle(color: k_background)),
        backgroundColor: k_primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "Log In",
                      style: TextStyle(
                          color: k_secondary,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                          color: k_secondary,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Colors.black12, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: k_primary, width: 2.0),
                    ),
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Colors.black38),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "Password",
                      style: TextStyle(
                          color: k_secondary,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  obscureText: _isObscuredText,
                  controller: passwordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Colors.black12, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscuredText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscuredText = !_isObscuredText;
                        });
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: k_primary, width: 2.0),
                    ),
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Colors.black38),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: FilledButton(
                  onPressed: () {
                    Login();
                  },
                  style: FilledButton.styleFrom(
                      backgroundColor: k_primary,
                      textStyle: const TextStyle(fontSize: 18.0),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.9, 60.0)),
                  child: const Text(
                    "Log In",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black54, fontSize: 15.0),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
