# API 参考

## 预置路由

### `ProjectRouter`

```python
ProjectRouter.prefix   # "/projects"
ProjectRouter.tags     # ["项目"]

ProjectRouter.build(*, create, get, list_all, update, delete) -> APIRouter
ProjectRouter.build_default() -> APIRouter  # 内置内存存储
```

### `TaskRouter`

```python
TaskRouter.prefix   # "/tasks"
TaskRouter.tags     # ["任务"]

TaskRouter.build(*, create, get, list_all, update, delete) -> APIRouter
TaskRouter.build_default() -> APIRouter  # 内置内存存储
```

### build 参数

| 参数 | 签名 |
|------|------|
| `create` | `(id: str, model) -> model` |
| `get` | `(id: str) -> model \| None` |
| `list_all` | `() -> list[model]` |
| `update` | `(id: str, model) -> model` |
| `delete` | `(id: str) -> bool` |

### 端点

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `{prefix}` | 创建。自动注入 `created_at`、`updated_at` |
| GET | `{prefix}` | 列表 |
| GET | `{prefix}/{item_id}` | 详情，不存在返回 404 |
| PATCH | `{prefix}/{item_id}` | 更新，不存在返回 404。自动刷新 `updated_at` |
| DELETE | `{prefix}/{item_id}` | 删除，不存在返回 404 |

---

## 通用路由

### `ModelRouter`

为任意 Pydantic 模型生成 CRUD 路由。

```python
ModelRouter(model, prefix=None, tags=None)
```

| 参数 | 类型 | 默认 | 说明 |
|------|------|------|------|
| `model` | `Type[BaseModel]` | — | 任意 Pydantic 模型 |
| `prefix` | `str \| None` | `f"/{model_name}s"` | 路由前缀 |
| `tags` | `list[str] \| None` | `[model.__name__]` | FastAPI tags |

`.build()` 签名与预置路由一致。

---

## Schema 推导

所有 Schema 继承 `CamelCaseModel`，JSON 输入输出自动转 camelCase： `created_at` ↔ `createdAt`。Python 代码中仍用 snake_case。

### CreateSchema

`{ModelName}Create`。`id` 必填，审计字段排除，`createdBy` 可选，其余保留模型默认值。

### UpdateSchema

`{ModelName}Update`。所有可变字段包装为 `Optional`，默认 `None`，未传的跳过。

### 审计字段

`createdBy`、`createdAt`、`updatedBy`、`updatedAt`。POST 自动写入 `createdAt`、`updatedAt`，PATCH 刷新 `updatedAt`。

---

## 更新行为

PATCH 端点检测模型是否有 `replace()` 方法：

- 有（如 `Task`）— `instance.replace(**data)`，只传非 None 值
- 无（如 `Project`）— 重建实例，非 None 请求值覆盖原值，`updated_at` 自动更新
