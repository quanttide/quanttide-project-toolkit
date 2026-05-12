import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quanttide_projects/flutter_quanttide_projects.dart';

void main() {
  testWidgets('渲染多列按照 flex 比例', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 500,
          child: BoardView(
            columns: [
              const Text('列A'),
              const Text('列B'),
              const Text('列C'),
            ],
            flexes: [1.0, 2.0, 1.0],
          ),
        ),
      ),
    ));

    expect(find.text('列A'), findsOneWidget);
    expect(find.text('列B'), findsOneWidget);
    expect(find.text('列C'), findsOneWidget);
  });

  testWidgets('渲染 header', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 500,
          child: BoardView(
            header: const Text('看板标题'),
            columns: [
              const Text('列A'),
            ],
            flexes: [1.0],
          ),
        ),
      ),
    ));

    expect(find.text('看板标题'), findsOneWidget);
    expect(find.text('列A'), findsOneWidget);
  });
}
