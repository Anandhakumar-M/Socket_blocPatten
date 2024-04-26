// ignore_for_file: library_private_types_in_public_api, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io1/bloc/socket_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String url;
  final String userId;

  ChatScreen({super.key, required this.userId, required this.url});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocketBloc(url, userId),
      child: BlocBuilder<SocketBloc, List<dynamic>>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Chat with User $userId'),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      return state[index]['type'] == 'send'
                          ? ListTile(
                              title: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(state[index]['message'])),
                            )
                          : ListTile(
                              title: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(state[index]['message'])),
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
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
                          String message = _controller.text.trim();
                          String receivedId = userId == '2' ? '1' : '2';
                          context
                              .read<SocketBloc>()
                              .add(SendMessage(userId, message, receivedId));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
