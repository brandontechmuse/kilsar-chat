import 'package:kilsar_chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> getMessages();
  Future<void> saveMessages(List<ChatMessage> messages);
  Future<ChatMessage> sendMessage(String text);
}
