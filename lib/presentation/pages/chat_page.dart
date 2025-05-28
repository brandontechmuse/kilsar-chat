import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kilsar_chat/domain/entities/chat_message.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_event.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_state.dart';

class ChatPage extends StatefulWidget {
  final String searchTerm;
  final bool isActive;
  const ChatPage({super.key, this.searchTerm = '', required this.isActive});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _dotsController;
  bool _askedRecipe = false;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isActive && !_askedRecipe) {
        _askedRecipe = true;
        _showRecipePrompt();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChatPage old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive && !_askedRecipe) {
      _askedRecipe = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showRecipePrompt());
    }
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

  void _showRecipePrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Hello Joel'),
        content: const Text(
          'Since you live in Portugal, would you like the recipe for Pastel de Nata?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _showLanguagePrompt(),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showLanguagePrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Choose Language'),
        content: const Text(
          'Would you like the recipe in English or Portuguese?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ChatBloc>().add(
                SendMessageEvent(
                  'Please provide the recipe for Pastel de Nata in English.',
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text('English'),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatBloc>().add(
                SendMessageEvent(
                  'Por favor, forneca a receita de Pastel de Nata em Portugues.',
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Portugues'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final totalItems =
                  state.messages.length + (state.isLoading ? 1 : 0);
              return ListView.builder(
                controller: _scrollController,
                itemCount: totalItems,
                itemBuilder: (context, index) {
                  if (index < state.messages.length) {
                    final m = state.messages[index];
                    return Align(
                      alignment: m.role == Role.user
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: m.role == Role.user
                              ? Colors.blue[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(m.text),
                      ),
                    );
                  } else {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (i) {
                            final start = i * 0.2;
                            final end = start + 0.6;
                            return FadeTransition(
                              opacity: _dotsController.drive(
                                CurveTween(
                                  curve: Interval(
                                    start,
                                    end,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                              ),
                              child: const Text(
                                '.',
                                style: TextStyle(fontSize: 32),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  }
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
