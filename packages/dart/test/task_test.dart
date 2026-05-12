import 'package:test/test.dart';
import 'package:quanttide_project/quanttide_project.dart';

void main() {
  group('Task constructor', () {
    test('required fields only', () {
      final task = Task(id: 't1', title: '任务');
      expect(task.id, 't1');
      expect(task.title, '任务');
      expect(task.description, '');
      expect(task.category, isNull);
      expect(task.tags, isEmpty);
      expect(task.status, isNull);
      expect(task.date, isNull);
      expect(task.assignee, isNull);
      expect(task.custom, isEmpty);
    });

    test('all fields', () {
      final task = Task(
        id: 't1',
        title: '任务',
        description: '描述',
        category: 'ideal',
        tags: {'domain': 'sales'},
        status: 'done',
        date: '2024-01-15',
        assignee: '某人',
        custom: {'source': '访谈'},
      );
      expect(task.id, 't1');
      expect(task.description, '描述');
      expect(task.category, 'ideal');
      expect(task.tags, {'domain': 'sales'});
      expect(task.status, 'done');
      expect(task.date, '2024-01-15');
      expect(task.assignee, '某人');
      expect(task.custom, {'source': '访谈'});
    });
  });

  group('Task.fromJson', () {
    test('parses all built-in fields', () {
      final json = {
        'id': 't1',
        'title': '任务',
        'description': '描述',
        'category': 'ideal',
        'tags': {'domain': 'sales'},
        'status': 'done',
        'date': '2024-01-15',
        'assignee': '某人',
      };
      final task = Task.fromJson(json);
      expect(task.id, 't1');
      expect(task.title, '任务');
      expect(task.description, '描述');
      expect(task.category, 'ideal');
      expect(task.tags, {'domain': 'sales'});
      expect(task.status, 'done');
      expect(task.date, '2024-01-15');
      expect(task.assignee, '某人');
      expect(task.custom, isEmpty);
    });

    test('missing optional fields use defaults', () {
      final json = {'id': 't1', 'title': '任务'};
      final task = Task.fromJson(json);
      expect(task.description, '');
      expect(task.category, isNull);
      expect(task.tags, isEmpty);
      expect(task.status, isNull);
      expect(task.date, isNull);
      expect(task.assignee, isNull);
      expect(task.custom, isEmpty);
    });

    test('non-string tag values coerced to string', () {
      final json = {
        'id': 't1',
        'title': '任务',
        'tags': {'count': 42, 'active': true, 'score': 3.14},
      };
      final task = Task.fromJson(json);
      expect(task.tags['count'], '42');
      expect(task.tags['active'], 'true');
      expect(task.tags['score'], '3.14');
    });

    test('non-Map tags results in empty tags', () {
      final json = {'id': 't1', 'title': '任务', 'tags': 'invalid'};
      final task = Task.fromJson(json);
      expect(task.tags, isEmpty);
    });

    test('date as Map', () {
      final json = {
        'id': 't1', 'title': '任务',
        'date': {'start': '2024-01-01', 'end': '2024-12-31'},
      };
      final task = Task.fromJson(json);
      expect(task.date, {'start': '2024-01-01', 'end': '2024-12-31'});
    });

    test('unknown fields go to custom', () {
      final json = {
        'id': 't1', 'title': '任务',
        'source': '访谈', 'cost': 100,
      };
      final task = Task.fromJson(json);
      expect(task.id, 't1');
      expect(task.custom['source'], '访谈');
      expect(task.custom['cost'], 100);
    });

    test('status is built-in, not custom', () {
      final json = {'id': 't1', 'title': '任务', 'status': 'pending'};
      final task = Task.fromJson(json);
      expect(task.status, 'pending');
      expect(task.custom.containsKey('status'), isFalse);
    });
  });

  group('Task.toJson', () {
    test('all populated fields are included', () {
      final task = Task(
        id: 't1', title: '任务', description: '描述',
        category: 'ideal', tags: {'domain': 'sales'},
        status: 'done', date: '2024-01-15',
        assignee: '某人', custom: {'source': '访谈'},
      );
      final json = task.toJson();
      expect(json['id'], 't1');
      expect(json['title'], '任务');
      expect(json['description'], '描述');
      expect(json['category'], 'ideal');
      expect(json['tags'], {'domain': 'sales'});
      expect(json['status'], 'done');
      expect(json['date'], '2024-01-15');
      expect(json['assignee'], '某人');
      expect(json['source'], '访谈');
    });

    test('null/empty optionals omitted', () {
      final task = Task(id: 't1', title: '任务');
      final json = task.toJson();
      expect(json.containsKey('category'), isFalse);
      expect(json.containsKey('tags'), isFalse);
      expect(json.containsKey('status'), isFalse);
      expect(json.containsKey('date'), isFalse);
      expect(json.containsKey('assignee'), isFalse);
    });
  });

  group('Task round-trip', () {
    test('fromJson -> toJson preserves values', () {
      final original = {
        'id': 't1', 'title': '任务', 'description': '描述',
        'category': 'ideal', 'tags': {'domain': 'sales'},
        'status': 'done', 'date': '2024-01-15',
        'assignee': '某人', 'source': '访谈',
      };
      final task = Task.fromJson(original);
      final json = task.toJson();
      expect(json['id'], 't1');
      expect(json['title'], '任务');
      expect(json['description'], '描述');
      expect(json['category'], 'ideal');
      expect(json['tags'], {'domain': 'sales'});
      expect(json['status'], 'done');
      expect(json['date'], '2024-01-15');
      expect(json['assignee'], '某人');
      expect(json['source'], '访谈');
    });

    test('toJson -> fromJson preserves values', () {
      final task = Task(
        id: 't1', title: '任务', description: '描述',
        category: 'ideal', tags: {'domain': 'sales'},
        status: 'done', date: '2024-01-15',
        assignee: '某人', custom: {'source': '访谈'},
      );
      final json = task.toJson();
      final restored = Task.fromJson(json);
      expect(restored.id, task.id);
      expect(restored.title, task.title);
      expect(restored.description, task.description);
      expect(restored.category, task.category);
      expect(restored.tags, task.tags);
      expect(restored.status, task.status);
      expect(restored.date, task.date);
      expect(restored.assignee, task.assignee);
      expect(restored.custom['source'], '访谈');
    });
  });

  group('Task.copyWith', () {
    test('overrides category', () {
      final task = Task(id: 't1', title: '任务', category: 'ideal');
      final copied = task.copyWith(category: 'reality');
      expect(copied.category, 'reality');
      expect(copied.title, '任务');
    });

    test('overrides status', () {
      final task = Task(id: 't1', title: '任务', status: 'pending');
      final copied = task.copyWith(status: 'done');
      expect(copied.status, 'done');
    });

    test('overrides assignee', () {
      final task = Task(id: 't1', title: '任务', assignee: 'A');
      final copied = task.copyWith(assignee: 'B');
      expect(copied.assignee, 'B');
    });

    test('overrides multiple fields at once', () {
      final task = Task(
        id: 't1', title: '任务',
        category: 'ideal', status: 'pending', assignee: 'A',
      );
      final copied = task.copyWith(
        category: 'reality', status: 'done', assignee: 'B',
      );
      expect(copied.category, 'reality');
      expect(copied.status, 'done');
      expect(copied.assignee, 'B');
    });

    test('no args preserves everything', () {
      final task = Task(
        id: 't1', title: '任务', description: '描述',
        category: 'ideal', tags: {'k': 'v'},
        status: 'pending', date: '2024-01-15',
        assignee: 'A', custom: {'x': 'y'},
      );
      final copied = task.copyWith();
      expect(copied.id, task.id);
      expect(copied.title, task.title);
      expect(copied.description, task.description);
      expect(copied.category, task.category);
      expect(copied.tags, task.tags);
      expect(copied.status, task.status);
      expect(copied.date, task.date);
      expect(copied.assignee, task.assignee);
      expect(copied.custom, task.custom);
    });

    test('null arg keeps original value', () {
      final task = Task(id: 't1', title: '任务', status: 'pending');
      final copied = task.copyWith(status: null);
      expect(copied.status, 'pending');
    });
  });

  group('BoardCard deprecated typedef', () {
    test('BoardCard resolves to Task', () {
      final card = BoardCard(id: 'b1', title: '旧卡片', status: 'old');
      expect(card, isA<Task>());
      expect(card.id, 'b1');
      expect(card.status, 'old');
    });

    test('BoardCard.fromJson works', () {
      final json = {'id': 'b1', 'title': '旧卡片', 'status': 'old'};
      final card = BoardCard.fromJson(json);
      expect(card, isA<Task>());
      expect(card.status, 'old');
    });

    test('BoardCard.toJson works', () {
      final card = BoardCard(id: 'b1', title: '旧卡片');
      final json = card.toJson();
      expect(json['id'], 'b1');
    });
  });
}
