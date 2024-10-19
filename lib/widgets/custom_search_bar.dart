import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function() onTap;
  const CustomSearchBar({super.key, required this.onChanged, required this.onTap, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) => onChanged(value),
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        filled: true,
        fillColor: Colors.grey[200],
        hintText: "Type your query",
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: const Icon(Icons.mic, color: Colors.blue),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
