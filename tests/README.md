# 契约测试

跨语言数据模型一致性验证。

## 背景

| 包 | 语言 | 字段风格 | 定位 |
|---|---|---|---|
| `dart/` | Dart | 源码 snake_case，JSON camelCase | 参考实现 |
| `python/` | Python (Pydantic) | snake_case | 对照实现 |
| `fastapi/` | Python (FastAPI) | snake_case | CRUD 路由 |

Dart 包是数据模型参考实现（`dart/AGENTS.md`），新字段先在 Dart 定义，Python 等语言对照实现。

## 方案：共享 JSON Fixture

仓库根 `tests/fixtures/` 下存放中立 JSON 测试数据，两端各自消费。

```
tests/
  README.md
  fixtures/
    task.json
    project.json
```

### Fixture 格式

用 **camelCase** JSON（与 Dart `toJson()`/`fromJson()` 一致），Python 侧反序列化前做 `snake_case` 转换。

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
  "startAt": "2026-05-13T00:00:00Z",
  "endAt": "2026-05-13T00:00:00Z",
  "createdBy": "alice",
  "createdAt": "2026-05-13T00:00:00Z",
  "updatedBy": "bob",
  "updatedAt": "2026-05-13T00:00:00Z"
}
```

**Dart 侧消费：**

```dart
import 'dart:io';
final json = File('tests/fixtures/task.json');
final task = Task.fromJson(jsonDecode(await json.readAsString()));
```

**Python 侧消费：**

```python
import json
from pathlib import Path

def camel_to_snake(d: dict) -> dict:
    import re
    return {
        re.sub(r'(?<!^)(?=[A-Z])', '_', k).lower(): v
        for k, v in d.items()
    }

data = camel_to_snake(json.loads(Path("tests/fixtures/task.json").read_text()))
t = Task.model_validate(data)
```

## 交叉验证

新增 `tests/test_contract.py`（Python），从共享 fixture 读取→反序列化→断言关键字段。

```python
import json
from pathlib import Path
from quanttide_project.models.task import Task

FIXTURES = Path(__file__).parents[2] / "tests" / "fixtures"

def camel_to_snake(d: dict) -> dict:
    import re
    return {
        re.sub(r'(?<!^)(?=[A-Z])', '_', k).lower(): v
        for k, v in d.items()
    }

class TestContract:
    def test_task_fixture(self):
        data = json.loads((FIXTURES / "task.json").read_text())
        t = Task.model_validate(camel_to_snake(data))
        assert t.title == "Test"
        assert t.type == "task"
        assert t.tags == {"env": "prod"}
```

## CI 集成

GitHub Actions 中执行：

```yaml
- run: pip install -e packages/python
- run: python -m pytest packages/python/tests tests/
```

## 注意事项

- 添加新字段时，先更新 **Dart 模型**，再更新 **共享 fixture**，最后更新各语言实现
- fixture 字段增减应当视为契约变更，需要同步更新所有消费方
- Dart `fromJson` 默认 camelCase，Python `model_validate` 默认 snake_case，两者通过 `camel_to_snake` 桥接
