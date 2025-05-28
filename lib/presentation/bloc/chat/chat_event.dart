import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String text;
  const SendMessageEvent(this.text);
  @override
  List<Object?> get props => [text];
}
