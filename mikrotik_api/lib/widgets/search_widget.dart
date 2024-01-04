import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onTextChanged;

  const SearchWidget({
    super.key,
    required this.searchController,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: onTextChanged,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
    );
  }
}
