import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taprobuy/Models/ThemeModeNotifier.dart';
import 'package:taprobuy/color_schemes.g.dart';
import 'package:taprobuy/items/ItemDrawer.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // Create a variable to hold the user's e-mail address.
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  void LogUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // The 'fetchUserEmail' fetches the user's email address from Firebase Authentication.
  void fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    } else {
      print("User is not logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModeNotifier>(context);
    return Consumer<ThemeModeNotifier>(
        builder: (context, themeNotifier, child) {
      return Theme(
        data: ThemeData(
          primaryColor: k_primary,
          brightness: themeNotifier.themeMode == ThemeMode.dark
              ? Brightness.dark
              : Brightness.light,
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            backgroundColor: k_primary,
          ),
          drawer: const ItemDrawer(),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_circle_outlined,
                          size: 150,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        userEmail != null
                            ? Text(
                                "Welcome $userEmail",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Preferences",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                    color: Colors.white70,
                    child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.dark_mode),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text("Dark Mode",
                                    style: TextStyle(color: Colors.black)),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Switch(
                                      value: themeNotifier.themeMode ==
                                          ThemeMode.dark,
                                      onChanged: (value) {
                                        themeNotifier.toggleDarkMode();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))),
                const SizedBox(
                  height: 30,
                ),
                Card(
                    color: Colors.white70,
                    child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.policy_outlined),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Privacy Policy",
                                    style: TextStyle(color: Colors.black)),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      title: const Text(
                                                          "Privacy Policy"),
                                                      content:
                                                          const SingleChildScrollView(
                                                        child: Text(
                                                          "When you use our application, you're trusting us with your information. We understand that this is a big responsibility and work hard to protect your information at all times. Data that may be collected to improve the user experience may include but is not limited to :- E-mail, Time spent on the application and Products purchased.",
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              "Close"),
                                                        )
                                                      ]);
                                                });
                                          },
                                        )))
                              ],
                            ),
                          ],
                        ))),
                SizedBox(
                  height: 30,
                ),
                Card(
                    color: Colors.white70,
                    child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.logout_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text("Log Out",
                                    style: TextStyle(color: Colors.black)),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                        onPressed: LogUserOut,
                                        child: const Text("Log Out")),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
