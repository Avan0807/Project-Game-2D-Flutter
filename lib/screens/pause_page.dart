import 'package:flutter/material.dart';
import 'package:game2d/screens/menu_page.dart';  // Import menu_page

class PausePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pause'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('The game is paused'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();  // Quay lại trang trước đó
              },
              child: Text('Resume'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainMenu()),  // Chuyển đến menu_page
                );
              },
              child: Text('Quit'),
            ),
          ],
        ),
      ),
    );
  }
}
