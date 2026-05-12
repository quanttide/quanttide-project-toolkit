# quanttide_project

项目管理领域模型。

## 模型

| 类 | 说明 |
|---|---|
| `Project` | 项目，包含标识信息和审计字段 |
| `Task` | 任务，含分类、状态、计划、审计等字段 |

## 使用

```dart
import 'package:quanttide_project/quanttide_project.dart';

final task = Task(
  id: 't1',
  title: '完成报告',
  status: 'pending',
  assignee: '张三',
);

final json = task.toJson();
final restored = Task.fromJson(json);
```
