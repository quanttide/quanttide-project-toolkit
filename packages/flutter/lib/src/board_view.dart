import 'package:flutter/material.dart';
import 'package:quanttide_project/quanttide_project.dart';
import 'board_column.dart';
import 'board_card.dart';

class BoardView extends StatelessWidget {
  final Map<String, List<Task>> lists;

  const BoardView({super.key, required this.lists});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lists.length,
      itemBuilder: (context, index) {
        final entry = lists.entries.elementAt(index);
        return SizedBox(
          width: 280,
          child: BoardColumn(
            title: Text(entry.key,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
            content: ListView.builder(
              itemCount: entry.value.length,
              itemBuilder: (context, i) => BoardCard(
                title: Text(entry.value[i].title, style: Theme.of(context).textTheme.titleSmall),
                description: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (entry.value[i].assignee != null)
                      Text('负责人: ${entry.value[i].assignee}',
                          style: Theme.of(context).textTheme.bodySmall),
                    if (entry.value[i].status != null)
                      Chip(label: Text(entry.value[i].status!)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
