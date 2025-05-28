import 'package:hive_flutter/hive_flutter.dart';
import 'package:kilsar_chat/domain/entities/task.dart';
import 'package:kilsar_chat/domain/entities/chat_message.dart';

class LocalDataSource {
  static const String taskBox = 'tasks';
  static const String messageBox = 'messages';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(taskBox);
    await Hive.openBox(messageBox);
  }

  List<Task> getTasks() {
    final box = Hive.box(taskBox);
    return box.values
        .cast<Map>()
        .map((e) => Task.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final box = Hive.box(taskBox);
    await box.clear();
    for (var t in tasks) {
      await box.add(t.toJson());
    }
  }

  List<ChatMessage> getMessages() {
    final box = Hive.box(messageBox);
    return box.values
        .cast<Map>()
        .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final box = Hive.box(messageBox);
    await box.clear();
    for (var m in messages) {
      await box.add(m.toJson());
    }
  }
}
