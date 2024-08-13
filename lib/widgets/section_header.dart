// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  Widget? action;

  SectionHeader({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        action ?? const SizedBox.shrink()
      ],
    );
  }
}
