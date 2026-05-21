import 'package:flutter/material.dart';

class FloatingToolbar extends StatelessWidget {
  final List<Widget> children;
  const FloatingToolbar({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: IntrinsicHeight(
          child: Row(mainAxisSize: MainAxisSize.min, children: [...children]),
        ),
      ),
    );
  }
}
