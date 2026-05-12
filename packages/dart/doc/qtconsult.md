# QtConsult 接入指南

本库提供 `Project` 和 `Task` 两个领域模型，是量潮咨询应用（qtconsult）的数据基础层。本文档面向 qtconsult 的维护者，说明如何在咨询场景中使用这两个模型。

## 字段约定

qtconsult 使用 `Task` 表达 OODA 看板中的四种卡片，通过字段组合区分卡片类型和业务含义。

### type — OODA 阶段

`type` 表示卡片所属的 OODA 阶段，有且仅有四个值：

| 值 | 含义 | 对应看板列 |
|:---|:-----|:----------|
| `observe` | 调研 | 业务理想/现实状况 |
| `orient` | 分析 | 根因分析/洞察 |
| `decide` | 决策 | 方案对比/策略选择 |
| `act` | 执行 | 任务/行动项 |

### status — 卡片状态

`status` 表示卡片在各自阶段内的进度状态，业务含义随 `type` 变化：

- `observe`：`pending`（待确认）或 `confirmed`（已确认）
- `orient`：通常不设 `status`
- `decide`：通常不设 `status`
- `act`：`todo`（待办）、`doing`（进行中）、`done`（已完成）、`blocked`（受阻）

### tags — 业务元数据

`tags` 存储各阶段特有的字段，全部以字符串键值对表达：

**observe**

| key | 含义 | 来源 |
|:----|:-----|:-----|
| `source` | 数据来源 | 旧 JSON 的 `source` 字段 |

**orient**

| key | 含义 | 来源 |
|:----|:-----|:-----|
| `rootCause` | 根因描述 | 旧 JSON 的 `rootCause` 字段 |
| `impact` | 影响描述 | 旧 JSON 的 `impact` 字段 |
| `domain` | 分析领域 | 旧 JSON 的 `tags.domain` 字段 |

**decide**

| key | 含义 | 来源 |
|:----|:-----|:-----|
| `advantage` | 方案优势 | 旧 JSON 的 `advantage` 字段 |
| `summary` | 方案概要 | 旧 JSON 的 `summary` 字段 |
| `resources` | 资源需求 | 旧 JSON 的 `resources` 字段 |
| `keyAssumption` | 关键假设 | 旧 JSON 的 `keyAssumption` 字段 |
| `isSelected` | 是否倾向此方案 | 旧 JSON 的 `isSelected` 字段，值为 `"true"` 或 `"false"` |
| `clientNote` | 客户备注 | 旧 JSON 的 `clientNote` 字段 |

**act**

| key | 含义 | 来源 |
|:----|:-----|:-----|
| `progress` | 进度百分比（字符串） | 旧 JSON 的 `progress` 字段，如 `"0.3"` |
| `notes` | 备注 | 旧 JSON 的 `notes` 字段 |
| `blockedReason` | 受阻原因 | 旧 JSON 的 `blockedReason` 字段 |

### observe_type — 调研子类型

仅 `type == 'observe'` 时有意义，存储在 `tags['observe_type']`：

- `ideal`：业务理想
- `reality`：现实状况

### category — 分类（通用）

`category` 是通用分类字段，可在任何阶段使用。当前仅 `observe` 阶段使用 `tags['observe_type']` 表达子类型，`category` 保留给未来的问题域分类使用。

### priority — 方案优先级

仅 `type == 'decide'` 时有意义，值为 `"P1"` 或 `"P2"`。

### assignee — 负责人

仅 `type == 'act'` 时有意义。

### startAt / endAt — 计划时间

仅 `type == 'act'` 时有意义。如果任务未设定时间计划，这两个字段为 `null`。

## 数据加载

qtconsult 的 fixture 数据以 JSON 文件形式存在，顶层结构如下：

```json
{
  "id": "project0",
  "name": "project0",
  "title": "量潮科技自我诊断",
  "tasks": [
    { "id": "<uuid>", "title": "...", "type": "observe", ... },
    { "id": "<uuid>", "title": "...", "type": "act", ... }
  ]
}
```

解析方式：

```dart
import 'dart:convert';
import 'dart:io';
import 'package:quanttide_project/quanttide_project.dart';

void loadProject() {
  final raw = jsonDecode(File('fixtures/project0.json').readAsStringSync())
      as Map<String, dynamic>;

  final project = Project.fromJson(raw);
  final tasks = (raw['tasks'] as List)
      .map((e) => Task.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

`Project` 和 `Task` 没有引用关联，是平级的两个独立模型。关联在应用层由 `ProjectLists(List<Task>)` 维护。

## Task 操作

### 创建

```dart
final task = Task(
  id: uuid,        // String，建议用 uuid 包生成
  title: '新任务',
  description: '描述',
  type: 'observe',
  category: 'reality',
  status: 'pending',
  tags: {'source': '访谈'},
);
```

### 修改

`Task` 是不可变对象，修改使用 `copyWith`：

```dart
final updated = task.copyWith(
  type: 'act',
  status: 'doing',
  assignee: '创始人',
  startAt: DateTime(2026, 6, 1),
  endAt: DateTime(2026, 8, 31),
);
```

`copyWith` 只覆盖以下字段：`type`、`category`、`status`、`priority`、`assigner`、`assignee`、`startAt`、`endAt`。`tags` 不可通过 `copyWith` 修改，需要重新构造。

### 按 OODA 阶段过滤

```dart
final observe = tasks.where((t) => t.type == 'observe').toList();
final act = tasks.where((t) => t.type == 'act').toList();
```

### 序列化

```dart
final json = task.toJson();
final restored = Task.fromJson(json);
```

空值和空集合在 `toJson` 中被省略。

## 测试

本库在 `test/fixtures/` 下提供了两份完整的 qtconsult fixture：

- `qtconsult_project0.json` — 量潮科技自我诊断（18 项任务）
- `qtconsult_project1.json` — 商家赋能平台数字化转型（20 项任务）

使用方式：

```dart
final fixture = File('test/fixtures/qtconsult_project0.json');
final raw = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
final tasks = (raw['tasks'] as List)
    .map((e) => Task.fromJson(e as Map<String, dynamic>))
    .toList();
```

两份 fixture 覆盖了以下业务场景：

- observe 任务 confirmed 和 pending 两种状态
- act 任务 doing、todo、blocked 三种状态
- act 任务有计划时间和无计划时间
- act 任务带 blockedReason（受阻原因）
- 有 notes（备注）和无 notes
