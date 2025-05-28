import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/task/task_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/task/task_event.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_event.dart';
import 'package:kilsar_chat/core/widgets/search_header.dart';
import 'package:kilsar_chat/presentation/pages/tasks_page.dart';
import 'package:kilsar_chat/presentation/pages/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String searchTerm = '';

  void onSearchChanged(String term) => setState(() => searchTerm = term);

  void onItemTapped(int idx) {
    setState(() {
      selectedIndex = idx;
      searchTerm = '';
      if (idx == 0) {
        context.read<TaskBloc>().add(LoadTasks());
      } else {
        context.read<ChatBloc>().add(LoadMessages());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SearchHeader(
          currentIndex: selectedIndex,
          onSearchChanged: onSearchChanged,
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          TasksPage(searchTerm: searchTerm),
          ChatPage(searchTerm: searchTerm),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}
