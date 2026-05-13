# 用户文档

一套跨语言的项目管理 SDK，覆盖数据模型、API 路由、UI 组件。

## 安装

::::{tab-set}
:::{tab-item} Python
:sync: python

```bash
pip install quanttide-project
```
:::

:::{tab-item} FastAPI
:sync: fastapi

```bash
pip install fastapi-quanttide-project
```

自动安装 `quanttide-project` 和 `fastapi`。
:::

:::{tab-item} Dart
:sync: dart

```yaml
# pubspec.yaml
dependencies:
  quanttide_project: ^0.2.0
```
:::

:::{tab-item} Flutter
:sync: flutter

```yaml
# pubspec.yaml
dependencies:
  flutter_quanttide_project: ^0.1.0
```
:::
::::

## 核心概念

数据模型分为 `Project`（项目）和 `Task`（任务）两种资源。

### Project

项目有唯一标识、名称、标题、描述和审计信息。

::::{tab-set}
:::{tab-item} Python
:sync: python

```python
from quanttide_project import Project

p = Project(
    id="proj-1",
    name="my-project",
    title="我的项目",
    description="项目描述",
)
```
:::

:::{tab-item} Dart
:sync: dart

```dart
import 'package:quanttide_project/quanttide_project.dart';

final p = Project(
  id: 'proj-1',
  name: 'my-project',
  title: '我的项目',
  description: '项目描述',
);
```
:::
::::

### Task

任务比项目多了分类、状态、优先级、负责人和时间计划。

::::{tab-set}
:::{tab-item} Python
:sync: python

```python
from datetime import datetime, timezone
from quanttide_project import Task

t = Task(
    id="task-1",
    title="实现登录功能",
    type="task",
    status="in_progress",
    priority="high",
    assignee="alice",
    tags={"module": "auth"},
    start_at=datetime(2026, 5, 1, tzinfo=timezone.utc),
    end_at=datetime(2026, 5, 15, tzinfo=timezone.utc),
)
```
:::

:::{tab-item} Dart
:sync: dart

```dart
import 'package:quanttide_project/quanttide_project.dart';

final t = Task(
  id: 'task-1',
  title: '实现登录功能',
  type: 'task',
  status: 'in_progress',
  priority: 'high',
  assignee: 'alice',
  tags: {'module': 'auth'},
  startAt: DateTime.utc(2026, 5, 1),
  endAt: DateTime.utc(2026, 5, 15),
);
```
:::
::::

### JSON 序列化

所有模型支持 JSON 序列化和反序列化。

::::{tab-set}
:::{tab-item} Python
:sync: python

```python
# 序列化
data = p.model_dump(mode="json", exclude_none=True)
# 反序列化
p2 = Project.model_validate(data)
```
:::

:::{tab-item} Dart
:sync: dart

```dart
// 序列化
final data = p.toJson();
// 反序列化
final p2 = Project.fromJson(data);
```
:::
::::

### 更新 Task

Task 是不可变模型，通过 `replace`（Python）或 `copyWith`（Dart）创建修改后的新实例。

::::{tab-set}
:::{tab-item} Python
:sync: python

```python
updated = t.replace(status="done", priority="high")
```
:::

:::{tab-item} Dart
:sync: dart

```dart
final updated = t.copyWith(status: 'done', priority: 'high');
```
:::
::::

仅可修改 `type`、`category`、`status`、`priority`、`assigner`、`assignee`、`start_at`、`end_at`，标识和审计字段不可变。

## CRUD API（Python FastAPI）

`fastapi-quanttide-project` 为 Project 和 Task 自动生成标准 CRUD 端点。

```python
from fastapi import FastAPI
from fastapi_quanttide_project import ProjectRouter, TaskRouter

app = FastAPI()

app.include_router(ProjectRouter.build_default())
app.include_router(TaskRouter.build_default())
```

启动后获得：

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/projects` | 创建项目 |
| GET | `/projects` | 项目列表 |
| GET | `/projects/{id}` | 项目详情 |
| PATCH | `/projects/{id}` | 更新项目 |
| DELETE | `/projects/{id}` | 删除项目 |

Task 同理，路径为 `/tasks`。

## UI 组件（Flutter）

`flutter_quanttide_project` 提供看板 UI 组件。

```dart
import 'package:flutter_quanttide_project/flutter_quanttide_project.dart';

BoardView(
  header: Text('项目看板'),
  columns: [
    (child: BoardColumn(
      title: Text('待办'),
      content: ListView(children: [
        BoardCard(
          title: Text('实现登录'),
          onTap: () { /* 点击事件 */ },
        ),
      ]),
    ), flex: 1),
    (child: BoardColumn(
      title: Text('进行中'),
      content: ListView(children: [
        BoardCard(
          title: Text('编写文档'),
          description: Text('完成 API 文档'),
        ),
      ]),
    ), flex: 1),
  ],
)
```

`BoardView` 自动响应桌面端（横向排列）和移动端（纵向堆叠）。

## 包关系

```text
dart ── 数据模型（参考实现）
 │
 ├── python ── Pydantic 模型
 │     │
 │     └── fastapi ── CRUD 路由
 │
 └── flutter ── 看板 UI 组件
```
