import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GameState {
  static int score = 0;

  static Map<String, int> characterScore = {
    'Mask Dude': 0,
    'Ninja Frog': 100,
    'Pink Man': 200,
    'Virtual Guy': 300,
  };

  static void updateScore(int newScore) {
    score = newScore;
  }

  static Future<void> initialize() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String userId = user.uid;
      final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

      try {
        final DataSnapshot snapshot = await _dbRef.child('users').child(userId).child('score').get();
        if (snapshot.exists) {
          score = snapshot.value as int;
          print('Score loaded from Firebase: $score');
        } else {
          print('No score found for user in Firebase.');
        }
      } catch (error) {
        print('Failed to load score: $error');
      }
    } else {
      print('No user is signed in.');
    }
  }

  static Future<void> saveScoreToDatabase(int newScore) async {
    final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String userId = user.uid;

      try {
        await _dbRef.child('users').child(userId).child('score').set(newScore);
        print('Score saved to Firebase: $newScore');
      } catch (error) {
        print('Failed to save score: $error');
      }
    } else {
      print('No user is signed in.');
    }
  }

  static bool canUnlock(String character) {
    return score >= characterScore[character]!;
  }
}
