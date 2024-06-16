import 'package:flutter/material.dart';
import 'package:game2d/screens/game_play.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

import 'game_state.dart';

class CharacterPage extends StatelessWidget {
  final User user; // Thêm tham số user
  const CharacterPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Character'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Score: ${GameState.score}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            CharacterButton(character: 'Mask Dude'),
            CharacterButton(character: 'Ninja Frog'),
            CharacterButton(character: 'Pink Man'),
            CharacterButton(character: 'Virtual Guy'),
          ],
        ),
      ),
    );
  }
}

class CharacterButton extends StatelessWidget {
  final String character;

  const CharacterButton({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Main Characters/$character/Jump (32x32).png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 8),
          Text(character),
          const SizedBox(height: 8),
          Text(
            'Score needed: ${GameState.characterScore[character]}', // Thêm dòng này để hiển thị điểm cần thiết
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: GameState.canUnlock(character)
                ? () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => GamePlay(character: character),
                ),
              );
            }
                : null,
            child: const Text('Chọn'),
          ),
        ],
      ),
    );
  }
}

