import 'package:flutter/material.dart';
import 'package:quanttide_project/quanttide_project.dart';
import 'board_card.dart';
import 'board_column.dart';

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
              itemBuilder: (context, i) => BoardCard(task: entry.value[i]),
            ),
          ),
        );
      },
    );
  }
}
