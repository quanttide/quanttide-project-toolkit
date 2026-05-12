import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quanttide_projects/flutter_quanttide_projects.dart';

void main() {
  testWidgets('渲染标题', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BoardCard(
          title: const Text('卡片标题'),
        ),
      ),
    ));

    expect(find.text('卡片标题'), findsOneWidget);
  });

  testWidgets('渲染描述', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BoardCard(
          title: const Text('标题'),
          description: const Text('描述内容'),
        ),
      ),
    ));

    expect(find.text('标题'), findsOneWidget);
    expect(find.text('描述内容'), findsOneWidget);
  });

  testWidgets('没有描述时不渲染描述区域', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BoardCard(
          title: const Text('标题'),
        ),
      ),
    ));

    expect(find.text('标题'), findsOneWidget);
    // 没有 description 参数时，不应有额外的描述文本
  });

  testWidgets('点击触发 onTap', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BoardCard(
          title: const Text('标题'),
          onTap: () => tapped = true,
        ),
      ),
    ));

    await tester.tap(find.text('标题'));
    expect(tapped, true);
  });
}
