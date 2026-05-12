import 'package:test/test.dart';
import 'package:quanttide_project/quanttide_project.dart';

void main() {
  group('Task constructor', () {
    test('required fields only', () {
      final task = Task(id: 't1', title: '任务');
      expect(task.id, 't1');
      expect(task.title, '任务');
      expect(task.description, '');
      expect(task.type, isNull);
      expect(task.category, isNull);
      expect(task.tags, isEmpty);
      expect(task.status, isNull);
      expect(task.priority, isNull);
      expect(task.assigner, isNull);
      expect(task.assignee, isNull);
      expect(task.startAt, isNull);
      expect(task.endAt, isNull);
      expect(task.createdBy, isNull);
      expect(task.createdAt, isNull);
      expect(task.updatedBy, isNull);
      expect(task.updatedAt, isNull);
    });

    test('all fields', () {
      final now = DateTime(2024, 1, 15);
      final task = Task(
        id: 't1', title: '任务', description: '描述',
        type: 'task', category: 'ideal',
        tags: {'domain': 'sales'}, status: 'done',
        priority: 'high', assigner: '甲', assignee: '乙',
        startAt: now, endAt: now,
        createdBy: '甲', createdAt: now,
        updatedBy: '乙', updatedAt: now,
      );
      expect(task.id, 't1');
      expect(task.type, 'task');
      expect(task.category, 'ideal');
      expect(task.tags, {'domain': 'sales'});
      expect(task.status, 'done');
      expect(task.priority, 'high');
      expect(task.assigner, '甲');
      expect(task.assignee, '乙');
      expect(task.startAt, now);
      expect(task.endAt, now);
      expect(task.createdBy, '甲');
      expect(task.createdAt, now);
      expect(task.updatedBy, '乙');
      expect(task.updatedAt, now);
    });
  });

  group('Task.fromJson', () {
    test('parses all fields', () {
      final json = {
        'id': 't1', 'title': '任务', 'description': '描述',
        'type': 'task', 'category': 'ideal',
        'tags': {'domain': 'sales'}, 'status': 'done',
        'priority': 'high', 'assigner': '甲', 'assignee': '乙',
        'startAt': '2024-01-15T00:00:00.000',
        'endAt': '2024-01-16T00:00:00.000',
        'createdBy': '甲', 'createdAt': '2024-01-15T00:00:00.000',
        'updatedBy': '乙', 'updatedAt': '2024-01-16T00:00:00.000',
      };
      final task = Task.fromJson(json);
      expect(task.id, 't1');
      expect(task.type, 'task');
      expect(task.category, 'ideal');
      expect(task.tags, {'domain': 'sales'});
      expect(task.status, 'done');
      expect(task.priority, 'high');
      expect(task.assigner, '甲');
      expect(task.assignee, '乙');
      expect(task.startAt, DateTime(2024, 1, 15));
      expect(task.endAt, DateTime(2024, 1, 16));
      expect(task.createdBy, '甲');
      expect(task.createdAt, DateTime(2024, 1, 15));
      expect(task.updatedBy, '乙');
      expect(task.updatedAt, DateTime(2024, 1, 16));
    });

    test('missing optional fields use defaults', () {
      final json = {'id': 't1', 'title': '任务'};
      final task = Task.fromJson(json);
      expect(task.description, '');
      expect(task.type, isNull);
      expect(task.category, isNull);
      expect(task.tags, isEmpty);
      expect(task.status, isNull);
      expect(task.priority, isNull);
      expect(task.assigner, isNull);
      expect(task.assignee, isNull);
      expect(task.startAt, isNull);
      expect(task.endAt, isNull);
      expect(task.createdBy, isNull);
      expect(task.createdAt, isNull);
      expect(task.updatedBy, isNull);
      expect(task.updatedAt, isNull);
    });

    test('non-string tag values coerced to string', () {
      final json = {
        'id': 't1', 'title': '任务',
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

    test('null datetime fields handled', () {
      final json = {
        'id': 't1', 'title': '任务',
        'createdAt': null, 'startAt': null,
      };
      final task = Task.fromJson(json);
      expect(task.createdAt, isNull);
      expect(task.startAt, isNull);
    });
  });

  group('Task.toJson', () {
    test('all populated fields included', () {
      final now = DateTime(2024, 1, 15);
      final task = Task(
        id: 't1', title: '任务', description: '描述',
        type: 'task', category: 'ideal',
        tags: {'domain': 'sales'}, status: 'done',
        priority: 'high', assigner: '甲', assignee: '乙',
        startAt: now, endAt: now,
        createdBy: '甲', createdAt: now,
        updatedBy: '乙', updatedAt: now,
      );
      final json = task.toJson();
      expect(json['id'], 't1');
      expect(json['type'], 'task');
      expect(json['category'], 'ideal');
      expect(json['tags'], {'domain': 'sales'});
      expect(json['status'], 'done');
      expect(json['priority'], 'high');
      expect(json['assigner'], '甲');
      expect(json['assignee'], '乙');
      expect(json['startAt'], '2024-01-15T00:00:00.000');
      expect(json['endAt'], '2024-01-15T00:00:00.000');
      expect(json['createdBy'], '甲');
      expect(json['createdAt'], '2024-01-15T00:00:00.000');
      expect(json['updatedBy'], '乙');
      expect(json['updatedAt'], '2024-01-15T00:00:00.000');
    });

    test('null/empty optionals omitted', () {
      final task = Task(id: 't1', title: '任务');
      final json = task.toJson();
      expect(json.containsKey('type'), isFalse);
      expect(json.containsKey('category'), isFalse);
      expect(json.containsKey('tags'), isFalse);
      expect(json.containsKey('status'), isFalse);
      expect(json.containsKey('priority'), isFalse);
      expect(json.containsKey('assigner'), isFalse);
      expect(json.containsKey('assignee'), isFalse);
      expect(json.containsKey('startAt'), isFalse);
      expect(json.containsKey('endAt'), isFalse);
      expect(json.containsKey('createdBy'), isFalse);
      expect(json.containsKey('createdAt'), isFalse);
      expect(json.containsKey('updatedBy'), isFalse);
      expect(json.containsKey('updatedAt'), isFalse);
    });
  });

  group('Task round-trip', () {
    test('fromJson -> toJson preserves values', () {
      final original = {
        'id': 't1', 'title': '任务', 'description': '描述',
        'type': 'task', 'category': 'ideal',
        'tags': {'domain': 'sales'}, 'status': 'done',
        'priority': 'high', 'assigner': '甲', 'assignee': '乙',
        'startAt': '2024-01-15T00:00:00.000',
        'endAt': '2024-01-16T00:00:00.000',
        'createdBy': '甲', 'createdAt': '2024-01-15T00:00:00.000',
        'updatedBy': '乙', 'updatedAt': '2024-01-16T00:00:00.000',
      };
      final task = Task.fromJson(original);
      final json = task.toJson();
      expect(json['id'], 't1');
      expect(json['type'], 'task');
      expect(json['startAt'], '2024-01-15T00:00:00.000');
      expect(json['endAt'], '2024-01-16T00:00:00.000');
    });
  });

  group('Task.copyWith', () {
    test('overrides each field', () {
      final task = Task(id: 't1', title: '任务');
      expect(task.copyWith(type: 'bug').type, 'bug');
      expect(task.copyWith(category: 'reality').category, 'reality');
      expect(task.copyWith(status: 'done').status, 'done');
      expect(task.copyWith(priority: 'high').priority, 'high');
      expect(task.copyWith(assigner: '甲').assigner, '甲');
      expect(task.copyWith(assignee: '乙').assignee, '乙');
      final now = DateTime(2024, 1, 15);
      expect(task.copyWith(startAt: now).startAt, now);
      expect(task.copyWith(endAt: now).endAt, now);
    });

    test('overrides multiple fields at once', () {
      final task = Task(id: 't1', title: '任务',
          category: 'ideal', status: 'pending', assignee: 'A');
      final copied = task.copyWith(
        category: 'reality', status: 'done', assignee: 'B',
      );
      expect(copied.category, 'reality');
      expect(copied.status, 'done');
      expect(copied.assignee, 'B');
    });

    test('no args preserves everything', () {
      final now = DateTime(2024, 1, 15);
      final task = Task(
        id: 't1', title: '任务', description: '描述',
        type: 'task', category: 'ideal', tags: {'k': 'v'},
        status: 'done', priority: 'high',
        assigner: '甲', assignee: '乙',
        startAt: now, endAt: now,
        createdBy: '甲', createdAt: now,
        updatedBy: '乙', updatedAt: now,
      );
      final copied = task.copyWith();
      expect(copied.id, task.id);
      expect(copied.title, task.title);
      expect(copied.type, task.type);
      expect(copied.category, task.category);
      expect(copied.tags, task.tags);
      expect(copied.status, task.status);
      expect(copied.priority, task.priority);
      expect(copied.assigner, task.assigner);
      expect(copied.assignee, task.assignee);
      expect(copied.startAt, task.startAt);
      expect(copied.endAt, task.endAt);
      expect(copied.createdBy, task.createdBy);
      expect(copied.createdAt, task.createdAt);
      expect(copied.updatedBy, task.updatedBy);
      expect(copied.updatedAt, task.updatedAt);
    });
  });

}
