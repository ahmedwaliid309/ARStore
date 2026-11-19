import 'package:flutter/material.dart';

/// شاشة مؤقتة: كل واحد يشيلها ويبني شاشته الحقيقية مكانها.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.owner,
    required this.branch,
    this.tasks = const [],
    this.actions = const [],
  });

  final String title;
  final String owner;
  final String branch;
  final List<String> tasks;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('المسؤول: $owner', style: text.titleMedium),
          const SizedBox(height: 4),
          Text('Branch: $branch', style: text.bodyMedium),
          const SizedBox(height: 20),
          Text('المطلوب:', style: text.titleMedium),
          const SizedBox(height: 8),
          for (final t in tasks)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• $t', style: text.bodyMedium),
            ),
          const SizedBox(height: 24),
          ...actions,
        ],
      ),
    );
  }
}
