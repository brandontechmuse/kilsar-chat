import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kilsar_chat/domain/entities/chat_message.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_event.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_state.dart';

class ChatPage extends StatefulWidget {
  final String searchTerm;
  const ChatPage({Key? key, this.searchTerm = ''}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchTerm.isNotEmpty) {
      final index = context.read<ChatBloc>().state.messages.indexWhere(
        (m) => m.text.toLowerCase().contains(widget.searchTerm.toLowerCase()),
      );
      if (index != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            index * 60.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state.isLoading && state.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final msg = state.messages[index];
                  return Align(
                    alignment: msg.role == Role.user
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: msg.role == Role.user
                            ? Colors.blue[100]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg.text),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Ask Kilsar'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    context.read<ChatBloc>().add(SendMessageEvent(text));
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
