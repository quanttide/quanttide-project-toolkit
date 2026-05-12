import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quanttide_project/flutter_quanttide_project.dart';

void main() {
  testWidgets('渲染标题和内容', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BoardColumn(
          title: const Text('测试列',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          content: const Text('内容区域'),
        ),
      ),
    ));

    expect(find.text('测试列'), findsOneWidget);
    expect(find.text('内容区域'), findsOneWidget);
  });

  testWidgets('标题栏有分割线', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 200,
          child: BoardColumn(
            title: const Text('标题'),
            content: const Text('内容'),
          ),
        ),
      ),
    ));

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(10));
  });

  testWidgets('内容区填充剩余空间', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 300,
          child: BoardColumn(
            title: const Text('标题'),
            content: const Text('填充内容'),
          ),
        ),
      ),
    ));

    expect(find.text('填充内容'), findsOneWidget);
  });
}
