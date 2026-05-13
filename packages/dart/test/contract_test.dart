import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:quanttide_project/quanttide_project.dart';

Map<String, dynamic> _snakeToCamel(Map<String, dynamic> input) {
  final result = <String, dynamic>{};
  for (final entry in input.entries) {
    final camel = entry.key.replaceAllMapped(
      RegExp(r'_(.)'),
      (m) => m.group(1)!.toUpperCase(),
    );
    result[camel] = entry.value;
  }
  return result;
}

String _fixturePath(String name) =>
    File('${Directory.current.path}/../../tests/fixtures/$name').path;

String _schemaPath(String name) =>
    File('${Directory.current.path}/../../tests/schemas/$name').path;

void main() {
  group('Contract: Task schema and fixture', () {
    test('schema definition is valid JSON', () {
      final path = _schemaPath('task.json');
      final raw = File(path).readAsStringSync();
      final schema = jsonDecode(raw) as Map<String, dynamic>;
      expect(schema['title'], 'Task');
      expect(schema['required'], contains('id'));
      expect(schema['required'], contains('title'));
    });

    test('fixture deserializes correctly', () {
      final path = _fixturePath('task.json');
      final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      final camel = _snakeToCamel(raw);
      final task = Task.fromJson(camel);
      expect(task.id, 't1');
      expect(task.title, 'Test Task');
      expect(task.type, 'task');
      expect(task.category, 'dev');
    });

    test('round-trip: fixture toJson matches expected fields', () {
      final path = _fixturePath('task.json');
      final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      final camel = _snakeToCamel(raw);
      final task = Task.fromJson(camel);
      final json = task.toJson();
      expect(json['id'], 't1');
      expect(json['title'], 'Test Task');
      expect(json['type'], 'task');
    });

    test('required fields present in serialized output', () {
      final task = Task(id: 't1', title: 'Minimal');
      final json = task.toJson();
      expect(json.containsKey('id'), isTrue);
      expect(json.containsKey('title'), isTrue);
    });
  });

  group('Contract: Project schema and fixture', () {
    test('schema definition is valid JSON', () {
      final path = _schemaPath('project.json');
      final raw = File(path).readAsStringSync();
      final schema = jsonDecode(raw) as Map<String, dynamic>;
      expect(schema['title'], 'Project');
      expect(schema['required'], contains('id'));
      expect(schema['required'], contains('name'));
      expect(schema['required'], contains('title'));
    });

    test('fixture deserializes correctly', () {
      final path = _fixturePath('project.json');
      final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      final camel = _snakeToCamel(raw);
      final project = Project.fromJson(camel);
      expect(project.id, 'p1');
      expect(project.name, 'demo-project');
      expect(project.title, 'Demo Project');
    });

    test('round-trip: fixture toJson matches expected fields', () {
      final path = _fixturePath('project.json');
      final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      final camel = _snakeToCamel(raw);
      final project = Project.fromJson(camel);
      final json = project.toJson();
      expect(json['id'], 'p1');
      expect(json['name'], 'demo-project');
      expect(json['title'], 'Demo Project');
    });

    test('required fields present in serialized output', () {
      final project = Project(id: 'p1', name: 'demo', title: 'Minimal');
      final json = project.toJson();
      expect(json.containsKey('id'), isTrue);
      expect(json.containsKey('name'), isTrue);
      expect(json.containsKey('title'), isTrue);
    });
  });
}
