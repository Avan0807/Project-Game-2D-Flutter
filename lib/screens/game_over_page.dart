import 'package:flutter/material.dart';
import 'package:game2d/screens/menu_page.dart';
import 'package:game2d/screens/game_play.dart';  // Import GamePlay để restart game

class GameOverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Over'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Over', style: TextStyle(fontSize: 32)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => GamePlay()),  // Chuyển đến menu_page
                );
              },
              child: Text('Restart'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainMenu()),
                );
              },
              child: Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
