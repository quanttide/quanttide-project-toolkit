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
      expect(tasks.where((t) => t.type == 'clarify').length, 2);
      expect(tasks.where((t) => t.type == 'research').length, 8);
      expect(tasks.where((t) => t.type == 'decide').length, 2);
      expect(tasks.where((t) => t.type == 'execute').length, 6);
    });

    test('clarify tasks have source, confirmed status, and category', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final tasks = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'clarify')
          .toList();

      expect(tasks.length, 2);
      for (final t in tasks) {
        expect(t.tags['source'], isNotNull);
        expect(t.status, 'confirmed');
        expect(t.category, isNotNull);
      }
    });

    test('research tasks have source, rootCause, impact, domain', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final research = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'research')
          .toList();

      expect(research.length, 8);
      final withSource = research.where((t) => t.tags['source'] != null).toList();
      expect(withSource.length, 4);
      final withInsight = research.where((t) => t.tags['rootCause'] != null).toList();
      expect(withInsight.length, 4);
    });

    test('research tasks have rootCause, impact, domain for orient-originated items', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final research = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'research')
          .toList();

      expect(research.length, 8);
      final withInsight = research.where((t) => t.tags['rootCause'] != null).toList();
      expect(withInsight.length, 4);
      for (final t in withInsight) {
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

    test('execute tasks have status, assignee, dates, and progress', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final execute = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'execute')
          .toList();

      expect(execute.length, 6);
      for (final t in execute) {
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

    test('all tasks have non-null category', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final tasks = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final t in tasks) {
        expect(t.category, isNotNull);
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
      expect(tasks.where((t) => t.type == 'clarify').length, 4);
      expect(tasks.where((t) => t.type == 'research').length, 8);
      expect(tasks.where((t) => t.type == 'decide').length, 2);
      expect(tasks.where((t) => t.type == 'execute').length, 6);
    });

    test('clarify and research tasks have correct status (pending vs confirmed)', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final clarify = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'clarify')
          .toList();
      final research = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'research')
          .toList();

      expect(clarify.where((t) => t.status == 'pending').length, 4);
      expect(research.where((t) => t.status == 'confirmed').length, 4);
    });

    test('execute tasks handle missing dates and blocked status', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final execute = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .where((t) => t.type == 'execute')
          .toList();

      expect(execute.where((t) => t.status == 'doing').length, 3);
      expect(execute.where((t) => t.status == 'todo').length, 2);
      expect(execute.where((t) => t.status == 'blocked').length, 1);

      final withoutDates = execute.where((t) => t.startAt == null).toList();
      expect(withoutDates.length, 2);

      final blocked = execute.firstWhere((t) => t.tags['blockedReason'] != null);
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

    test('all tasks have non-null category', () {
      final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
      final tasks = (raw['tasks'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final t in tasks) {
        expect(t.category, isNotNull);
      }
    });
  });
}
