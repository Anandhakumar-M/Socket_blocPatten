// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as iio;

part 'socket_event.dart';

class SocketBloc extends Bloc<SocketEvent, List<dynamic>> {
  late iio.Socket _socket;
  SocketBloc(String url, String userId) : super([]) {
    _socket = iio.io(url, <String, dynamic>{
      'transports': ['websocket'],
    });
    _socket.connect();
    _socket.emit('login', userId);
    _socket.on('privateMessage', _handlePrivateMessage);
    on<SendMessage>(
      (event, emit) =>
          sendMessage(event.message, event.receivedId, event.userId),
    );
  }

  void _handlePrivateMessage(dynamic data) {
    Map<String, dynamic>? messageData = data as Map<String, dynamic>?;

    if (messageData != null) {
      addMessage({'type': 'received', 'message': messageData['message']});
    }
  }

  void sendMessage(String message, String receiverId, String userId) {
    if (message.isNotEmpty) {
      _socket.emit('privateMessage', {
        'senderId': userId,
        'receiverId': receiverId,
        'message': message,
      });
      addMessage({'type': 'send', 'message': message});
    }
  }

  void addMessage(dynamic message) {
    List<dynamic> updatedMessages = [...state, message];
    emit(updatedMessages);
  }
}
