import 'package:flutter/material.dart';
import 'package:io1/chartscreen.dart';
import 'package:io1/groupchart.dart';

class UserSelectionScreen extends StatelessWidget {
  final String url;
  const UserSelectionScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('User 1'),
            onTap: () {
              _navigateToChatScreen(context, '1', url);
            },
          ),
          ListTile(
            title: const Text('User 2'),
            onTap: () {
              _navigateToChatScreen(context, '2', url);
            },
          ),
          ListTile(
            title: const Text('group 1'),
            onTap: () {
              _navigateToGroupChatScreen(context, '1', url);
            },
          ),
          ListTile(
            title: const Text('test 1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

void _navigateToGroupChatScreen(
    BuildContext context, String userId, String url) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GroupChatScreen(userId: userId, url: url),
    ),
  );
}

void _navigateToChatScreen(BuildContext context, String userId, String url) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(userId: userId, url: url),
    ),
  );
}
