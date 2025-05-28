import 'package:kilsar_chat/core/api/ai_api_client.dart';
import 'package:kilsar_chat/domain/entities/chat_message.dart';

class RemoteDataSource {
  final AiApiClient apiClient;

  RemoteDataSource(this.apiClient);

  Future<ChatMessage> sendMessage(String text) async {
    final aiText = await apiClient.send(text);
    return ChatMessage(
      id: DateTime.now().toIso8601String(),
      text: aiText,
      role: Role.assistant,
    );
  }
}
