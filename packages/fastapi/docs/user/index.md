# fastapi-quanttide-project

给 `Project` 和 `Task` 配上标准 CRUD 路由。JSON 传输使用 camelCase（`createdAt`），Python 代码保持 snake_case（`created_at`）。

## 装

```
pip install fastapi-quanttide-project
```

## 用

最简单的，带上默认的内存存储：

```python
from fastapi import FastAPI
from fastapi_quanttide_project import ProjectRouter, TaskRouter

app = FastAPI()

app.include_router(ProjectRouter.build_default())
app.include_router(TaskRouter.build_default())
```

现在 `/projects` 和 `/tasks` 各有了五个端点。

如果你有自己的存储，传回调进去：

```python
app.include_router(ProjectRouter.build(
    create=lambda _id, p: your_store.create(p),
    get=your_store.get,
    list_all=your_store.list,
    update=lambda _id, p: your_store.update(p),
    delete=lambda _id: your_store.delete(_id),
))
```

五个回调分别是 create / get / list_all / update / delete。

## 请求与响应

JSON 输入输出使用 camelCase：

```json
POST /projects
{"id": "p1", "name": "test", "title": "测试项目", "createdBy": "alice"}

→ 200
{"id": "p1", "name": "test", "title": "测试项目", "description": "", "createdBy": "alice", "createdAt": "...", "updatedBy": null, "updatedAt": "..."}
```

Python 代码仍是 snake_case，自动映射。

## PATCH 时发生了什么

Task 有 `replace()` 方法——调 `task.replace(status="done")`，只改传了的字段。Project 没有——新数据盖到老数据上，`updatedAt` 自动刷新。审计字段你不用管。

## 用通用版本

`ModelRouter` 不绑定具体模型，给任意 Pydantic 模型用：

```python
from fastapi_quanttide_project import ModelRouter

router = ModelRouter(MyModel).build(...)
```
