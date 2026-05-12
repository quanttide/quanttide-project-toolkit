import 'package:test/test.dart';
import 'package:quanttide_project/quanttide_project.dart';

void main() {
  group('Project constructor', () {
    test('required fields only', () {
      final project = Project(id: 'p1', name: 'demo', title: '演示');
      expect(project.id, 'p1');
      expect(project.name, 'demo');
      expect(project.title, '演示');
      expect(project.description, '');
      expect(project.createdBy, isNull);
      expect(project.createdAt, isNull);
      expect(project.updatedBy, isNull);
      expect(project.updatedAt, isNull);
    });

    test('all fields', () {
      final now = DateTime(2024, 1, 15);
      final project = Project(
        id: 'p1', name: 'demo', title: '演示',
        description: '描述',
        createdBy: '甲', createdAt: now,
        updatedBy: '乙', updatedAt: now,
      );
      expect(project.description, '描述');
      expect(project.createdBy, '甲');
      expect(project.createdAt, now);
      expect(project.updatedBy, '乙');
      expect(project.updatedAt, now);
    });
  });

  group('Project.fromJson', () {
    test('parses all fields', () {
      final json = {
        'id': 'p1', 'name': 'demo', 'title': '演示',
        'description': '描述',
        'createdBy': '甲', 'createdAt': '2024-01-15T00:00:00.000',
        'updatedBy': '乙', 'updatedAt': '2024-01-16T00:00:00.000',
      };
      final project = Project.fromJson(json);
      expect(project.id, 'p1');
      expect(project.name, 'demo');
      expect(project.title, '演示');
      expect(project.description, '描述');
      expect(project.createdBy, '甲');
      expect(project.createdAt, DateTime(2024, 1, 15));
      expect(project.updatedBy, '乙');
      expect(project.updatedAt, DateTime(2024, 1, 16));
    });

    test('missing optional fields use defaults', () {
      final json = {'id': 'p1', 'name': 'demo', 'title': '演示'};
      final project = Project.fromJson(json);
      expect(project.description, '');
      expect(project.createdBy, isNull);
      expect(project.createdAt, isNull);
      expect(project.updatedBy, isNull);
      expect(project.updatedAt, isNull);
    });
  });

  group('Project.toJson', () {
    test('all populated fields included', () {
      final now = DateTime(2024, 1, 15);
      final project = Project(
        id: 'p1', name: 'demo', title: '演示',
        description: '描述',
        createdBy: '甲', createdAt: now,
        updatedBy: '乙', updatedAt: now,
      );
      final json = project.toJson();
      expect(json['id'], 'p1');
      expect(json['name'], 'demo');
      expect(json['title'], '演示');
      expect(json['description'], '描述');
      expect(json['createdBy'], '甲');
      expect(json['createdAt'], '2024-01-15T00:00:00.000');
      expect(json['updatedBy'], '乙');
      expect(json['updatedAt'], '2024-01-15T00:00:00.000');
    });

    test('null optionals omitted', () {
      final project = Project(id: 'p1', name: 'demo', title: '演示');
      final json = project.toJson();
      expect(json.containsKey('description'), isTrue);
      expect(json.containsKey('createdBy'), isFalse);
      expect(json.containsKey('createdAt'), isFalse);
      expect(json.containsKey('updatedBy'), isFalse);
      expect(json.containsKey('updatedAt'), isFalse);
    });
  });

  group('Project round-trip', () {
    test('fromJson -> toJson -> fromJson', () {
      final original = {
        'id': 'p1', 'name': 'demo', 'title': '演示',
        'description': '描述',
        'createdBy': '甲', 'createdAt': '2024-01-15T00:00:00.000',
        'updatedBy': '乙',
      };
      final project = Project.fromJson(original);
      final json = project.toJson();
      final restored = Project.fromJson(json);
      expect(restored.id, 'p1');
      expect(restored.name, 'demo');
      expect(restored.title, '演示');
      expect(restored.description, '描述');
      expect(restored.createdBy, '甲');
      expect(restored.createdAt, DateTime(2024, 1, 15));
      expect(restored.updatedBy, '乙');
    });
  });
}
