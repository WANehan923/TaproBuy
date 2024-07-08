import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taprobuy/color_schemes.g.dart';
import 'package:taprobuy/screens/Home.dart';
import 'package:taprobuy/screens/LogIn.dart';
class SignUp extends StatefulWidget {
  final Function()? onTap;
  const SignUp({super.key, required this.onTap});
  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final reenterPasswordController = TextEditingController();
  bool _isObscuredText1 = true;
  bool _isObscuredText2 = true;
  void SignUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      if (passwordController.text == reenterPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        displayErrorMessage("Passwords don't match");
      }
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
                      "Sign Up",
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
                  controller: passwordController,
                  obscureText: _isObscuredText1,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Colors.black12, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscuredText1
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscuredText1 = !_isObscuredText1;
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
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "Re-Enter Password",
                      style: TextStyle(
                        color: k_secondary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: reenterPasswordController,
                  obscureText: _isObscuredText2,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Colors.black12, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscuredText2
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscuredText2 = !_isObscuredText2;
                        });
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: k_primary, width: 2.0),
                    ),
                    hintText: "Re-enter your password",
                    hintStyle: const TextStyle(color: Colors.black38),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: FilledButton(
                  onPressed: () {
                    SignUp();
                  },
                  child: Text(
                    "Sign Up",
                  ),
                  style: FilledButton.styleFrom(
                      backgroundColor: k_primary,
                      textStyle: const TextStyle(fontSize: 18.0),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.9, 60.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black54, fontSize: 15.0),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Log In",
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