import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  final Function(String, String) onSave;

  EditProfilePage({
    required this.username,
    required this.onSave,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  late final UserService _userService; // Declare _userService variable here

  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
    _userService = UserService(); // Initialize _userService here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Old Password'),
                obscureText: true,
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() async {
    try {
      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (newPassword != confirmPassword) {
        setState(() {
          _errorMessage = 'New Passwords do not match.';
        });
        return;
      }

      // Kiểm tra xác thực mật khẩu cũ
      User? user = _auth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: _passwordController.text);
        await user.reauthenticateWithCredential(credential);

        // Lưu mật khẩu mới lên Firebase
        await user.updatePassword(newPassword);

        // Lưu tên người dùng mới lên Firebase
        await _userService.updateUser(user.uid, {'name': _usernameController.text});

        // Gọi hàm onSave để thông báo đã lưu thành công
        widget.onSave(_usernameController.text, newPassword);

        // Đóng trang chỉnh sửa
        Navigator.of(context).pop();
      } else {
        setState(() {
          _errorMessage = 'User not found.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update profile: $e';
      });
    }
  }
}
