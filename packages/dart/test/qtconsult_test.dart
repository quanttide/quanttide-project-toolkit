import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:quanttide_project/quanttide_project.dart';

void main() {
  group('fixture qtconsult_project0.json', () {
    final fixture = File('test/fixtures/qtconsult_project0.json');

    setUpAll(() {
      if (!fixture.existsSync()) {
        throw StateError('Fixture not found: ${fixture.path}');
      }
    });

    test('reads project metadata', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final project = Project.fromJson(raw);
      expect(project.name, 'project0');
      expect(project.title, '量潮科技自我诊断');
    });

    test('parses all tasks with correct OODA phase', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final tasks = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(tasks.length, 18);
      expect(tasks.where((t) => t.type == 'observe').length, 6);
      expect(tasks.where((t) => t.type == 'orient').length, 4);
      expect(tasks.where((t) => t.type == 'decide').length, 2);
      expect(tasks.where((t) => t.type == 'act').length, 6);
    });

    test('observe tasks have category, source, and confirmed status', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final observe = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'observe')
          .toList();

      expect(observe.length, 6);
      for (final t in observe) {
        expect(['ideal', 'reality'], contains(t.category));
        expect(t.tags['source'], isNotNull);
        expect(t.status, 'confirmed');
      }
    });

    test('orient tasks have rootCause, impact, domain', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final orient = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'orient')
          .toList();

      expect(orient.length, 4);
      for (final t in orient) {
        expect(t.tags['rootCause'], isNotEmpty);
        expect(t.tags['impact'], isNotEmpty);
        expect(t.tags['domain'], isNotEmpty);
      }
    });

    test('decide tasks have priority and decision tags', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final decide = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'decide')
          .toList();

      expect(decide.length, 2);
      for (final t in decide) {
        expect(t.priority, anyOf('P1', 'P2'));
        expect(t.tags['advantage'], isNotEmpty);
        expect(t.tags['summary'], isNotEmpty);
        expect(t.tags['resources'], isNotEmpty);
        expect(t.tags['keyAssumption'], isNotEmpty);
        expect(t.tags.containsKey('isSelected'), isTrue);
        expect(t.tags.containsKey('clientNote'), isTrue);
      }
    });

    test('act tasks have status, assignee, dates, and progress', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final act = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'act')
          .toList();

      expect(act.length, 6);
      for (final t in act) {
        expect(t.assignee, isNotNull);
        expect(t.startAt, isNotNull);
        expect(t.endAt, isNotNull);
        expect(t.status, anyOf('doing', 'todo'));
        expect(t.tags['progress'], isNotNull);
      }
    });

    test('all tasks have UUID id', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final tasks = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      final uuidPattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      );
      for (final t in tasks) {
        expect(t.id, matches(uuidPattern));
      }
    });

    test('no task has upstream tag', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final tasks = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final t in tasks) {
        expect(t.tags.containsKey('upstream'), isFalse);
      }
    });
  });

  group('fixture qtconsult_project1.json', () {
    final fixture = File('test/fixtures/qtconsult_project1.json');

    setUpAll(() {
      if (!fixture.existsSync()) {
        throw StateError('Fixture not found: ${fixture.path}');
      }
    });

    test('reads project metadata', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final project = Project.fromJson(raw);
      expect(project.name, 'project1');
      expect(project.title, '商家赋能平台数字化转型');
    });

    test('parses all tasks with correct OODA phase', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final tasks = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(tasks.length, 20);
      expect(tasks.where((t) => t.type == 'observe').length, 8);
      expect(tasks.where((t) => t.type == 'orient').length, 4);
      expect(tasks.where((t) => t.type == 'decide').length, 2);
      expect(tasks.where((t) => t.type == 'act').length, 6);
    });

    test('observe tasks have correct status (pending vs confirmed)', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final observe = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'observe')
          .toList();

      expect(observe.where((t) => t.status == 'pending').length, 4);
      expect(observe.where((t) => t.status == 'confirmed').length, 4);
    });

    test('act tasks handle missing dates and blocked status', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final act = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'act')
          .toList();

      expect(act.where((t) => t.status == 'doing').length, 3);
      expect(act.where((t) => t.status == 'todo').length, 2);
      expect(act.where((t) => t.status == 'blocked').length, 1);

      final withoutDates = act.where((t) => t.startAt == null).toList();
      expect(withoutDates.length, 2);

      final blocked = act.firstWhere((t) => t.tags['blockedReason'] != null);
      expect(blocked.tags['blockedReason'], '数据工程师未到岗，无法启动');
    });

    test('all tasks have UUID id', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final tasks = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      final uuidPattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      );
      for (final t in tasks) {
        expect(t.id, matches(uuidPattern));
      }
    });

    test('no task has upstream tag', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final tasks = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final t in tasks) {
        expect(t.tags.containsKey('upstream'), isFalse);
      }
    });
  });
}
