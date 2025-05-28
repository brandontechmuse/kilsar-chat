import 'package:equatable/equatable.dart';

enum Role { user, assistant }

class ChatMessage extends Equatable {
  final String id;
  final String text;
  final Role role;

  const ChatMessage({required this.id, required this.text, required this.role});

  @override
  List<Object?> get props => [id, text, role];

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'role': role.index};

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] as String,
    text: json['text'] as String,
    role: Role.values[json['role'] as int],
  );
}
