part of 'socket_bloc.dart';

abstract class SocketEvent {}

class SendMessage extends SocketEvent {
  final String receivedId;
  final String userId;
  final String message;
  SendMessage(
    this.userId,
    this.message,
    this.receivedId,
  );
}
