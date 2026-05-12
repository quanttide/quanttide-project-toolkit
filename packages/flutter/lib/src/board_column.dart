import 'package:flutter/material.dart';
import 'package:quanttide_project/quanttide_project.dart';
import 'board_card.dart';

class BoardColumn extends StatelessWidget {
  final String title;
  final List<Task> tasks;

  const BoardColumn({super.key, required this.title, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => BoardCard(task: tasks[index]),
          ),
        ),
      ],
    );
  }
}
