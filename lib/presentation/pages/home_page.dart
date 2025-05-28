import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/task/task_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/task/task_event.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_event.dart';
import 'package:kilsar_chat/core/widgets/search_header.dart';
import 'tasks_page.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _searchTerm = '';

  void _onSearchChanged(String term) {
    setState(() => _searchTerm = term);
  }

  void _onItemTapped(int idx) {
    setState(() {
      _selectedIndex = idx;
      _searchTerm = '';
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
          currentIndex: _selectedIndex,
          onSearchChanged: _onSearchChanged,
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          TasksPage(searchTerm: _searchTerm),
          ChatPage(searchTerm: _searchTerm, isActive: _selectedIndex == 1),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}
