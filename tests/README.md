# 契约测试

跨语言数据模型一致性验证。

## 背景

| 包 | 语言 | 字段风格 | 
|---|---|---|
| `dart/` | Dart | 源码 snake_case，JSON camelCase |
| `python/` | Python (Pydantic) | snake_case |
| `fastapi/` | Python (FastAPI) | snake_case |

各语言独立演化，通过契约束保证模型同步。

## 方案：JSON Schema 作为契约（推荐）

以语言无关的 JSON Schema 作为单一事实来源（SSOT），各语言实现自行验证一致性。

```
tests/
  README.md
  schemas/
    task.json
    project.json
  fixtures/
    task.json
    project.json
```

### Schema 定义

**`tests/schemas/task.json`：**

```json
{
  "$schema": "https://json-schema.org/draft-07/schema#",
  "type": "object",
  "title": "Task",
  "properties": {
    "id":               {"type": "string"},
    "title":            {"type": "string"},
    "description":      {"type": "string", "default": ""},
    "type":             {"type": "string"},
    "category":         {"type": "string"},
    "tags":             {"type": "object", "additionalProperties": {"type": "string"}, "default": {}},
    "status":           {"type": "string"},
    "priority":         {"type": "string"},
    "assigner":         {"type": "string"},
    "assignee":         {"type": "string"},
    "start_at":         {"type": "string", "format": "date-time"},
    "end_at":           {"type": "string", "format": "date-time"},
    "created_by":       {"type": "string"},
    "created_at":       {"type": "string", "format": "date-time"},
    "updated_by":       {"type": "string"},
    "updated_at":       {"type": "string", "format": "date-time"}
  },
  "required": ["id", "title"]
}
```

> 字段名使用 snake_case，这是跨语言最通用的命名惯例。各语言在序列化/反序列化时按需做 case 转换。

### Python 侧验证

```python
import json, jsonschema
from pathlib import Path
from quanttide_project.models.task import Task

SCHEMA = json.loads(Path("tests/schemas/task.json").read_text())

class TestContract:
    def test_task_serialization(self):
        t = Task(id="t1", title="Test", type="task")
        data = t.model_dump(mode="json", exclude_none=True)
        jsonschema.validate(data, SCHEMA)
```

### Dart 侧验证

```dart
import 'dart:convert';
import 'dart:io';
import 'package:json_schema/json_schema.dart';

void main() async {
  final schema = await JsonSchema.create(
    json.decode(await File('tests/schemas/task.json').readAsString()),
  );
  final task = Task(id: 't1', title: 'Test');
  final data = task.toJson();  // camelCase
  // 转为 snake_case 匹配 schema
  final snake = <String, dynamic>{};
  data.forEach((k, v) {
    final s = k.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m.group(0)!.toLowerCase()}');
    snake[s] = v;
  });
  print(schema.validate(snake));  // true
}
```

## 备选：共享 Fixture Round-Trip

不依赖 JSON Schema 时的轻量方案。

### Fixture 格式

统一使用 snake_case JSON（Python 原生风格），Dart 侧反序列化前做 `camelCase` 转换。

**`tests/fixtures/task.json`：**

```json
{
  "id": "t1",
  "title": "Test",
  "description": "desc",
  "type": "task",
  "category": "dev",
  "tags": {"env": "prod"},
  "status": "in_progress",
  "priority": "high",
  "assigner": "alice",
  "assignee": "bob",
  "start_at": "2026-05-13T00:00:00Z",
  "end_at": "2026-05-13T00:00:00Z",
  "created_by": "alice",
  "created_at": "2026-05-13T00:00:00Z",
  "updated_by": "bob",
  "updated_at": "2026-05-13T00:00:00Z"
}
```

### Python 侧消费

```python
import json
from pathlib import Path
from quanttide_project.models.task import Task

data = json.loads(Path("tests/fixtures/task.json").read_text())
t = Task.model_validate(data)
assert t.title == "Test"
```

### Dart 侧消费

```dart
import 'dart:convert';
import 'dart:io';

Map<String, dynamic> snakeToCamel(Map<String, dynamic> input) {
  final result = <String, dynamic>{};
  input.forEach((k, v) {
    final camel = k.replaceAllMapped(RegExp(r'_(.)'), (m) => m.group(1)!.toUpperCase());
    result[camel] = v is Map ? snakeToCamel(v) : v;
  });
  return result;
}

final json = jsonDecode(await File('tests/fixtures/task.json').readAsString());
final task = Task.fromJson(snakeToCamel(json));
```

## CI 集成

GitHub Actions：

```yaml
- name: Validate Python against schema
  run: |
    pip install jsonschema
    python -m pytest tests/ packages/python/tests/

- name: Validate Dart against schema
  run: dart run packages/dart/test/contract_test.dart
```

## 工作流

1. **新增字段**：先更新 JSON Schema（`tests/schemas/`），再更新各语言实现
2. **修改字段**：更新 Schema + fixture，所有语言必须通过 Schema 验证
3. **每次提交**：CI 中跑 Schema 验证 + round-trip 测试
