import 'package:flutter/material.dart';
import 'user_service.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final UserService _userService = UserService();
  bool isLoading = true;
  List<Map<String, dynamic>> leaderboard = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    List<Map<String, dynamic>> users = await _userService.getLeaderboard();
    setState(() {
      leaderboard = users;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : leaderboard.isEmpty
          ? Center(child: Text('No data available'))
          : ListView.builder(
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          // Handle null values by providing default values
          String username = leaderboard[index]['name'] ?? 'Unknown';
          int score = leaderboard[index]['score'] ?? 0;

          return ListTile(
            leading: Text('#${index + 1}'),
            title: Text(username),
            trailing: Text('Score: $score'),
          );
        },
      ),
    );
  }
}
