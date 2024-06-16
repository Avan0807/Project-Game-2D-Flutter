import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game2d/screens/game_state.dart';
import 'package:provider/provider.dart';
import 'package:game2d/screens/menu_page.dart';
import 'package:game2d/sound_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAwHJCZzW2bn7dyUA3Zo3Neh76zMNckP1g",
          authDomain: "game2d-d1b6f.firebaseapp.com",
          databaseURL: "https://game2d-d1b6f-default-rtdb.firebaseio.com",
          projectId: "game2d-d1b6f",
          storageBucket: "game2d-d1b6f.appspot.com",
          messagingSenderId: "653461693916",
          appId: "1:653461693916:web:937d312180cefc99e7db19"
      ),
    );
  }

  // Check if user is already authenticated
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await GameState.initialize(); // Initialize game state if user is logged in
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => SoundProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: MainMenu(),
    );
  }
}
