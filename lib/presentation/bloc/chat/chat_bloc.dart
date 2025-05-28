import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kilsar_chat/domain/entities/chat_message.dart';
import 'package:kilsar_chat/domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(const ChatState()) {
    on<LoadMessages>((event, emit) async {
      final msgs = await repository.getMessages();
      emit(ChatState(messages: msgs));
    });
    on<SendMessageEvent>((event, emit) async {
      final userMsg = ChatMessage(
        id: DateTime.now().toIso8601String(),
        text: event.text,
        role: Role.user,
      );
      final updated = List<ChatMessage>.from(state.messages)..add(userMsg);
      emit(ChatState(messages: updated, isLoading: true));
      final aiMsg = await repository.sendMessage(event.text);
      final finalList = List<ChatMessage>.from(updated)..add(aiMsg);
      emit(ChatState(messages: finalList));
      await repository.saveMessages(finalList);
    });
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) => ChatState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ChatState state) => state.toJson();
}
