# fastapi-quanttide-project

量潮项目管理 FastAPI 工具箱。

## 用法

```python
from fastapi import FastAPI
from quanttide_project import Project, Task
from fastapi_quanttide_project import ModelRouter

app = FastAPI()

# 存储由用户自己管理，你可以用 dict、SQLite、Redis……
projects: dict[str, Project] = {}
tasks: dict[str, Task] = {}

app.include_router(ModelRouter(Project).build(
    create=lambda _id, p: projects.setdefault(_id, p) or p,
    get=projects.get,
    list_all=lambda: list(projects.values()),
    update=lambda _id, p: projects.update({_id: p}) or p,
    delete=lambda _id: projects.pop(_id, None) is not None,
))

app.include_router(ModelRouter(Task).build(
    create=lambda _id, t: tasks.setdefault(_id, t) or t,
    get=tasks.get,
    list_all=lambda: list(tasks.values()),
    update=lambda _id, t: tasks.update({_id: t}) or t,
    delete=lambda _id: tasks.pop(_id, None) is not None,
))
```

## 安装

```bash
pip install fastapi-quanttide-project
```
