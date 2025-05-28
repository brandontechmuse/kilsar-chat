import 'package:equatable/equatable.dart';
import 'package:kilsar_chat/domain/entities/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;

  const ChatState({this.messages = const [], this.isLoading = false});

  @override
  List<Object?> get props => [messages, isLoading];

  Map<String, dynamic> toJson() => {
    'messages': messages.map((m) => m.toJson()).toList(),
    'isLoading': isLoading,
  };

  factory ChatState.fromJson(Map<String, dynamic> json) {
    final list = (json['messages'] as List)
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
    return ChatState(
      messages: list,
      isLoading: json['isLoading'] as bool? ?? false,
    );
  }
}
