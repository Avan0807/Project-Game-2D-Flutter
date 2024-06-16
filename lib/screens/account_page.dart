import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'user_service.dart';
import 'edit_page.dart';
import 'login_page.dart';
import 'game_state.dart';

class AccountPage extends StatefulWidget {
  final User user;

  const AccountPage({Key? key, required this.user}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late String username;
  String avatarUrl = 'assets/images/user_avatar.png';
  int coin = 0;
  int score = 0;
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    username = widget.user.email ?? 'van';
    _createUserIfNotExists();
    _loadUserData();
  }

  Future<void> _createUserIfNotExists() async {
    await _userService.createUserIfNotExists(widget.user.uid, {
      'name': username,
      'avatarUrl': avatarUrl,
      'coin': coin,
      'score': GameState.score,
    });
  }

  Future<void> _loadUserData() async {
    _userService.getUser(widget.user.uid).listen((event) {
      final userData = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        username = userData['name'] ?? widget.user.email;
        avatarUrl = userData['avatarUrl'] ?? 'assets/images/user_avatar.png';
        coin = userData['coin'];
        score = userData['score'];
        GameState.updateScore(score); // Update GameState score
        isLoading = false;
      });
    }).onError((error) {
      print("Error loading user data: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String downloadUrl = await _userService.uploadAvatar(widget.user.uid, pickedFile.path);
      await _userService.updateUser(widget.user.uid, {'avatarUrl': downloadUrl});
      setState(() {
        avatarUrl = downloadUrl;
      });
    }
  }

  void _updateProfile(String newUsername, String newPassword) async {
    await _userService.updateUser(widget.user.uid, {'name': newUsername});
    setState(() {
      username = newUsername;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Page'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: avatarUrl.startsWith('http')
                      ? NetworkImage(avatarUrl)
                      : AssetImage(avatarUrl) as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                username,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Text(
                'Coins: $coin',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Score: ${GameState.score}', // Display GameState score
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        username: username,
                        onSave: (String newUsername, String newPassword) {
                          setState(() {
                            username = newUsername; // Cập nhật lại username mới
                            // Handle post save logic here, like updating user info in your app
                            // Or showing a save success message
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Text('Edit Profile'),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
