import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

class TaskState extends Equatable {
  final List<Task> tasks;
  const TaskState({this.tasks = const []});

  @override
  List<Object?> get props => [tasks];

  Map<String, dynamic> toJson() => {
    'tasks': tasks.map((e) => e.toJson()).toList(),
  };
  factory TaskState.fromJson(Map<String, dynamic> json) {
    final list = (json['tasks'] as List)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
    return TaskState(tasks: list);
  }
}
