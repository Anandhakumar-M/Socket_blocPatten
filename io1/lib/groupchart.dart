// ignore_for_file: library_private_types_in_public_api, library_prefixes

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupChatScreen extends StatefulWidget {
  final String url;
  final String userId;

  const GroupChatScreen({super.key, required this.userId, required this.url});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late IO.Socket _socket;
  final List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    _socket = IO.io(widget.url, <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.connect();

    _socket.emit('joinRoom', "room1");

    _socket.on('newMessage', _handleNewMessage);
  }

  void _handleNewMessage(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('sender')) {
      String message = data['message'];
      setState(() {
        _messages.add({'type': 'received', 'message': message});
      });
    }
  }

  void _sendMessage(String message, String receiverId) {
    if (message.isNotEmpty) {
      _socket.emit('sendMessageToRoom', {
        'roomId': 'room1',
        'message': message,
      });
      setState(() {
        _messages.add({'type': 'send', 'message': message});
      });
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }

  void _leaveRoom() {
    _socket.emit('leaveRoom', 'room1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('group ${widget.userId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index]['type'] == 'send'
                    ? ListTile(
                        title: Align(
                            alignment: Alignment.topRight,
                            child: Text(_messages[index]['message'])),
                      )
                    : ListTile(
                        title: Align(
                            alignment: Alignment.topLeft,
                            child: Text(_messages[index]['message'])),
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
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(
                        _controller.text, widget.userId == '2' ? '1' : '2');
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.join_left), onPressed: _leaveRoom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
