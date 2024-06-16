import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<DatabaseEvent> getUser(String uid) {
    return _dbRef.child('users').child(uid).onValue;
  }

  Future<void> createUserIfNotExists(String uid, Map<String, dynamic> data) async {
    DatabaseEvent snapshot = await _dbRef.child('users').child(uid).once();
    if (snapshot.snapshot.value == null) {
      await _dbRef.child('users').child(uid).set(data);
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _dbRef.child('users').child(uid).update(data);
      print("User data updated: $data");
    } catch (e) {
      print("Failed to update user data: $e");
    }
  }

  Future<String> uploadAvatar(String userId, String imagePath) async {
    File file = File(imagePath);
    String fileName = 'avatars/$userId/avatar.jpg'; // Set the file name and path in Firebase Storage

    try {
      // Upload file to Firebase Storage
      await firebase_storage.FirebaseStorage.instance.ref(fileName).putFile(file);

      // Get the download URL of the uploaded file
      String downloadUrl = await firebase_storage.FirebaseStorage.instance.ref(fileName).getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading avatar: $e');
      return '';
    }
  }

  Future<void> saveUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _dbRef.child('users').child(uid).set(data);
      print("User data saved: $data");
    } catch (e) {
      print("Failed to save user data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    List<Map<String, dynamic>> users = [];

    try {
      final DatabaseEvent event = await _dbRef.child('users').orderByChild('score').once();
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> userMap = event.snapshot.value as Map<dynamic, dynamic>;
        userMap.forEach((key, value) {
          users.add({
            'uid': key,
            'name': value['name'],
            'score': value['score'],
          });
        });

        // Sort scores from highest to lowest
        users.sort((a, b) => b['score'].compareTo(a['score']));
      }
    } catch (error) {
      print('Failed to load leaderboard: $error');
    }

    return users;
  }
}
