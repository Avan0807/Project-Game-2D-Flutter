import 'dart:io'; // Import the dart:io package
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game2d/screens/game_play.dart';
import 'package:game2d/screens/help_page.dart';
import 'package:game2d/screens/options_page.dart';
import 'package:game2d/screens/about_page.dart';
import 'package:game2d/screens/character_page.dart'; // Import for CharacterPage
import 'package:game2d/screens/account_page.dart'; // Import for AccountPage
import 'package:game2d/widgets/custom_button.dart';

import 'login_page.dart';

class MainMenu extends StatefulWidget {
  final User? user; // Make user a nullable field

  const MainMenu({Key? key, this.user}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = widget.user ?? FirebaseAuth.instance.currentUser; // Get the current authenticated user
  }

  /*
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to close the app?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (kIsWeb) {
                  // Show a message to close the tab manually in the web version
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('Please close the tab manually.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Exit the app for mobile platforms
                  if (Platform.isAndroid || Platform.isIOS) {
                    exit(0);
                  } else {
                    SystemNavigator.pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
*/

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      user = null; // Reset user to null after logging out
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/menu_background.gif",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withAlpha(20),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Adventure Story Of Heroes",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Color(0xFFFCBD80),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 3.0,
                            color: Color(0xFF451B0B),
                          ),
                          Shadow(
                            offset: Offset(3, 3),
                            blurRadius: 3.0,
                            color: Color(0xFF5D2E1C),
                          ),
                          Shadow(
                            offset: Offset(3, 3),
                            blurRadius: 3.0,
                            color: Color(0xFFB47C57),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Username greeting if logged in
                if (user != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Xin chào anh hùng ${user!.email ?? ''}", // Display user's email
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (user == null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CharacterPage(user: user!)),
                          );
                        }
                      },
                      child: const CustomButton(
                        imagePath: "assets/images/HUD/PlayButton.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (user == null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => AccountPage(user: user!)),
                          );
                        }
                      },
                      child: const CustomButton(
                        imagePath: "assets/images/HUD/AccountButton.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => OptionsPage()),
                        );
                      },
                      child: const CustomButton(
                        imagePath: "assets/images/HUD/OptionsButton.png",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LeaderboardPage()),
                        );
                      },
                      child: const CustomButton(
                        imagePath: "assets/images/HUD/LeaderboardButton.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ChatPage()),
                        );
                      },
                      child: const CustomButton(
                        imagePath: "assets/images/HUD/ChatworldButton.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        SystemNavigator.pop();
                        //_showExitDialog(); // Use exit(0) to force the application to close
                      },
                      child: const CustomButton(
                        imagePath: "assets/images/HUD/QuitButton.png",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
