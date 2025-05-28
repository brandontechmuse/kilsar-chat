import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends HydratedBloc<TaskEvent, TaskState> {
  final TaskRepository repository;
  TaskBloc(this.repository) : super(const TaskState()) {
    on<LoadTasks>((event, emit) async {
      final tasks = await repository.getTasks();
      emit(TaskState(tasks: tasks));
    });
    on<AddTask>((event, emit) async {
      final newTask = Task(
        id: DateTime.now().toIso8601String(),
        text: event.text,
      );
      final updated = List<Task>.from(state.tasks)..add(newTask);
      emit(TaskState(tasks: updated));
      await repository.saveTasks(updated);
    });
    on<ReorderTasks>((event, emit) async {
      final list = List<Task>.from(state.tasks);
      final item = list.removeAt(event.oldIndex);
      list.insert(
        event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex,
        item,
      );
      emit(TaskState(tasks: list));
      await repository.saveTasks(list);
    });
  }

  @override
  TaskState? fromJson(Map<String, dynamic> json) => TaskState.fromJson(json);
  @override
  Map<String, dynamic>? toJson(TaskState state) => state.toJson();
}
