import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final String text;
  const AddTask(this.text);
  @override
  List<Object?> get props => [text];
}

class ReorderTasks extends TaskEvent {
  final int oldIndex;
  final int newIndex;
  const ReorderTasks(this.oldIndex, this.newIndex);
  @override
  List<Object?> get props => [oldIndex, newIndex];
}
