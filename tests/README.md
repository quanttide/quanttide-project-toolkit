# 契约测试

跨语言数据模型一致性验证。

## 背景

| 包 | 语言 | 字段风格 |
|---|---|---|
| `dart/` | Dart | 源码 snake_case，JSON camelCase |
| `python/` | Python (Pydantic) | snake_case |
| `fastapi/` | Python (FastAPI) | snake_case |

## 方案

以语言无关的 JSON Schema 作为单一事实来源（SSOT），**各语言在自身包内编写契约测试**，统一引用根 `tests/` 下的 Schema 和 Fixture。

```
tests/
  README.md
  schemas/
    task.json
    project.json
  fixtures/
    task.json
    project.json
packages/
  python/tests/test_contract.py
  dart/test/contract_test.dart
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

字段名使用 **snake_case**（跨语言最通用的命名惯例），各语言在序列化边界按需做 case 转换。

## 测试内容

每个语言的契约测试覆盖：

1. **Schema 验证** — 序列化输出符合 JSON Schema
2. **Fixture 反序列化** — 共享 fixture 能被正确解析
3. **Round-trip** — 反序列化→再序列化，值不变
4. **最小实例** — 仅必填字段的模型也符合 Schema

## 运行

```bash
# Python
cd packages/python && uv run pytest tests/test_contract.py -v

# Dart
cd packages/dart && dart test test/contract_test.dart
```

## 工作流

1. **新增字段**：先更新 JSON Schema（`tests/schemas/`），再更新各语言实现
2. **修改字段**：更新 Schema + fixture，所有语言必须通过验证
3. **CI**：合并前各语言契约测试必须通过
