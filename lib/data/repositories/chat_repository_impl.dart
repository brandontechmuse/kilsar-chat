import 'package:kilsar_chat/domain/entities/chat_message.dart';
import 'package:kilsar_chat/domain/repositories/chat_repository.dart';
import 'package:kilsar_chat/data/datasources/local_data_source.dart';
import 'package:kilsar_chat/data/datasources/remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<List<ChatMessage>> getMessages() async =>
      localDataSource.getMessages();

  @override
  Future<void> saveMessages(List<ChatMessage> messages) async =>
      localDataSource.saveMessages(messages);

  @override
  Future<ChatMessage> sendMessage(String text) =>
      remoteDataSource.sendMessage(text);
}
