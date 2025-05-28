import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task/task_bloc.dart';
import '../bloc/task/task_event.dart';
import '../bloc/task/task_state.dart';

class TasksPage extends StatefulWidget {
  final String searchTerm;
  const TasksPage({Key? key, this.searchTerm = ''}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Add a task'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    context.read<TaskBloc>().add(AddTask(text));
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              final tasks = widget.searchTerm.isEmpty
                  ? state.tasks
                  : state.tasks
                        .where(
                          (t) => t.text.toLowerCase().contains(
                            widget.searchTerm.toLowerCase(),
                          ),
                        )
                        .toList();
              return ReorderableListView(
                onReorder: (oldIndex, newIndex) => context.read<TaskBloc>().add(
                  ReorderTasks(oldIndex, newIndex),
                ),
                children: [
                  for (int i = 0; i < tasks.length; i++)
                    ListTile(
                      key: ValueKey(tasks[i].id),
                      title: Text(tasks[i].text),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
