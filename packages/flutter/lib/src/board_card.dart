import 'package:flutter/material.dart';
import 'package:quanttide_project/quanttide_project.dart';

class BoardCard extends StatelessWidget {
  final Task task;
  final void Function()? onTap;

  const BoardCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: Theme.of(context).textTheme.titleSmall),
              if (task.assignee != null)
                Text('负责人: ${task.assignee}',
                    style: Theme.of(context).textTheme.bodySmall),
              if (task.status != null)
                Chip(label: Text(task.status!)),
            ],
          ),
        ),
      ),
    );
  }
}
