import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('chat/messages');
  final TextEditingController _messageController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _messages = [];
  late StreamSubscription<DatabaseEvent> _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _messagesSubscription = _messagesRef.orderByChild('timestamp').limitToLast(100).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final messages = data.entries.map((entry) {
        return {
          'username': entry.value['username'],
          'message': entry.value['message'],
          'timestamp': entry.value['timestamp']
        };
      }).toList();
      setState(() {
        _messages = messages;
      });
    });
  }

  @override
  void dispose() {
    _messagesSubscription.cancel();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _messagesRef.push().set({
        'username': user?.email ?? 'Unknown',
        'message': _messageController.text,
        'timestamp': timestamp
      });
      _messageController.clear();
    }
  }

  String _formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('World Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - index - 1];
                return ListTile(
                  title: Text(message['username']),
                  subtitle: Text(message['message']),
                  trailing: Text(_formatTimestamp(message['timestamp'])),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
