// ignore_for_file: deprecated_member_use

import 'package:test/test.dart';
import 'package:quanttide_project/quanttide_project.dart';

void main() {
  group('Board', () {
    test('fromJson parses list names as keys', () {
      final json = {
        'tasks': [{'id': 't1', 'title': '任务'}],
        'ideas': [{'id': 'i1', 'title': '想法'}],
      };
      final board = Board.fromJson(json);
      expect(board.lists.length, 2);
      expect(board.lists.containsKey('tasks'), isTrue);
      expect(board.lists.containsKey('ideas'), isTrue);
    });

    test('toJson -> fromJson round-trip', () {
      final board = Board(lists: {
        'observe': BoardList(name: 'observe', cards: [
          Task(id: 'o1', title: '卡片1', status: 'pending'),
        ]),
        'done': BoardList(name: 'done', cards: [
          Task(id: 'd1', title: '卡片2', assignee: '某人'),
        ]),
      });
      final json = board.toJson();
      final restored = Board.fromJson(json);
      expect(restored.lists.length, 2);
      expect(restored.lists['observe']!.cards.length, 1);
      expect(restored.lists['observe']!.cards[0].id, 'o1');
      expect(restored.lists['done']!.cards[0].assignee, '某人');
    });

    test('empty lists map', () {
      final board = Board(lists: {});
      final json = board.toJson();
      expect(json, isEmpty);
      final restored = Board.fromJson(json);
      expect(restored.lists, isEmpty);
    });
  });

  group('Project', () {
    test('toJson -> fromJson preserves all data', () {
      final project = Project(
        name: 'test',
        title: '测试项目',
        board: Board(lists: {
          'observe': BoardList(name: 'observe', cards: [
            Task(id: 'o1', title: '卡片1', category: 'ideal',
                status: 'pending'),
          ]),
          'orient': BoardList(name: 'orient', cards: [
            Task(id: 'i1', title: '洞察1', tags: {'domain': '技术领域'}),
          ]),
          'decide': BoardList(name: 'decide', cards: [
            Task(id: 's1', title: '方案A', custom: {'isSelected': true}),
          ]),
          'act': BoardList(name: 'act', cards: [
            Task(id: 't1', title: '任务1', assignee: '某人'),
          ]),
        }),
      );

      final json = project.toJson();
      final restored = Project.fromJson(json);

      expect(restored.name, 'test');
      expect(restored.title, '测试项目');
      expect(restored.board.lists.length, 4);
      expect(restored.board.lists['observe']!.cards.length, 1);
      expect(restored.board.lists['observe']!.cards[0].id, 'o1');
      expect(restored.board.lists['orient']!.cards[0].tags, {'domain': '技术领域'});
      expect(restored.board.lists['decide']!.cards[0].custom['isSelected'], true);
      expect(restored.board.lists['act']!.cards[0].assignee, '某人');
    });

    test('fromJson -> toJson -> fromJson identity', () {
      final originalJson = {
        'name': 'demo',
        'title': '演示',
        'board': {
          'todo': [{'id': 't1', 'title': '待办', 'status': 'pending'}],
          'done': [{'id': 'd1', 'title': '已完成', 'status': 'done'}],
        },
      };
      final project = Project.fromJson(originalJson);
      final json = project.toJson();
      final restored = Project.fromJson(json);
      expect(restored.name, 'demo');
      expect(restored.title, '演示');
      expect(restored.board.lists['todo']!.cards[0].status, 'pending');
      expect(restored.board.lists['done']!.cards[0].status, 'done');
    });
  });
}
