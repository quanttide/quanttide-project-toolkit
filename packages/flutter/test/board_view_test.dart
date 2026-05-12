import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quanttide_projects/flutter_quanttide_projects.dart';

void main() {
  testWidgets('渲染多列', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 500,
          child: BoardView(lists: {
            '待办': [],
            '进行中': [],
            '完成': [],
          }),
        ),
      ),
    ));

    expect(find.text('待办'), findsOneWidget);
    expect(find.text('进行中'), findsOneWidget);
    expect(find.text('完成'), findsOneWidget);
  });
}
