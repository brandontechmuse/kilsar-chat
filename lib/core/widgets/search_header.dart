import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<String> onSearchChanged;
  final int currentIndex;
  const SearchHeader({
    Key? key,
    required this.onSearchChanged,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        decoration: InputDecoration(
          hintText: currentIndex == 0
              ? 'Search tasks...'
              : 'Search messages...',
          border: InputBorder.none,
        ),
        onChanged: onSearchChanged,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
