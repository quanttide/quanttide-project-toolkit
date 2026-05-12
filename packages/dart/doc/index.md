# 领域模型

`quanttide_project` 提供两个核心领域模型：`Project`（项目）和 `Task`（任务）。

## Project

项目是顶层容器，包含标识信息和看板数据。

| 字段 | 类型 | 说明 |
|:----|:----|:----|
| `name` | `String` | 项目标识名 |
| `title` | `String` | 项目显示标题 |
| `board` | `Board` | 项目的看板数据（已废弃） |

`board` 字段持有 `Board` 类型，后者已标记废弃。后续版本将用直接管理 `Task` 集合的方式替代。

```dart
final project = Project(
  name: 'demo',
  title: '演示项目',
  board: Board(lists: {
    'todo': BoardList(name: 'todo', cards: [
      Task(id: 't1', title: '任务1'),
    ]),
  }),
);
```

## Task

任务是数据实体。

| 字段 | 类型 | 必填 | 说明 |
|:----|:----|:---:|:----|
| `id` | `String` | 是 | 唯一标识 |
| `title` | `String` | 是 | 标题 |
| `description` | `String` | 否 | 详细描述，默认 `''` |
| `category` | `String?` | 否 | 系统分类，如区分 ideal / reality |
| `tags` | `Map<String, String>` | 否 | 多维度标签，默认 `{}` |
| `status` | `String?` | 否 | 任务状态，如 pending / done / archived |
| `date` | `dynamic` | 否 | 日期，支持字符串或起止 Map |
| `assignee` | `String?` | 否 | 负责人 |
| `custom` | `Map<String, dynamic>` | 否 | 自定义字段，序列化时展开到 JSON 根层级 |

```dart
final task = Task(
  id: 't1',
  title: '完成报告',
  status: 'pending',
  assignee: '张三',
  tags: {'domain': 'sales', 'priority': 'high'},
  date: '2024-01-15',
);

final json = task.toJson();
final restored = Task.fromJson(json);
```

### 自定义字段机制

JSON 中不属于内置字段 `{id, title, description, category, tags, status, date, assignee}` 的键值对，在反序列化时自动归入 `custom` Map。序列化时 `custom` 条目展开到 JSON 根层级，与内置字段平级。

```dart
final task = Task.fromJson({
  'id': 't1', 'title': '任务',
  'source': '访谈',     // 归入 custom
  'cost': 100,          // 归入 custom
});

print(task.custom['source']); // '访谈'
print(task.custom['cost']);   // 100
```

### copyWith

支持选择性覆盖 `category`、`status`、`assignee` 三个字段，其余字段保持不变。

```dart
task.copyWith(status: 'done');
task.copyWith(category: 'reality', assignee: '李四');
```

## 废弃类型

以下类型保留用于向后兼容，新代码不应使用：

- `BoardCard` — 已重命名为 `Task`，`typedef BoardCard = Task`
- `BoardList` — 计划移除
- `Board` — 计划移除
