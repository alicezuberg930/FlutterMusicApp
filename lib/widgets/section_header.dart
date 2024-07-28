import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final Color color;

  const SectionHeader({super.key, required this.title, this.action = 'View more', this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          action,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
