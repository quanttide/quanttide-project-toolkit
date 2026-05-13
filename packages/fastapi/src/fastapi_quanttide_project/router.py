from datetime import datetime, timezone
from typing import Any, Callable, Optional, Type

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, create_model
from quanttide_project import Project, Task

AUDIT_FIELDS = {"created_by", "created_at", "updated_by", "updated_at"}
IDENTITY_FIELDS = {"id"}


def _mutable_fields(model: Type[BaseModel]) -> list[str]:
    return [
        name
        for name in model.model_fields
        if name not in AUDIT_FIELDS and name not in IDENTITY_FIELDS
    ]


def _build_create_schema(model: Type[BaseModel], name: str) -> Type[BaseModel]:
    fields: dict[str, Any] = {}
    for field_name in _mutable_fields(model):
        field_info = model.model_fields[field_name]
        fields[field_name] = (field_info.annotation, field_info.default)
    fields["id"] = (model.model_fields["id"].annotation, ...)
    if "created_by" in model.model_fields:
        fields["created_by"] = (model.model_fields["created_by"].annotation, None)
    return create_model(f"{name}Create", **fields)


def _build_update_schema(model: Type[BaseModel], name: str) -> Type[BaseModel]:
    fields: dict[str, Any] = {}
    for field_name in _mutable_fields(model):
        annotation = model.model_fields[field_name].annotation
        fields[field_name] = (Optional[annotation], None)
    return create_model(f"{name}Update", **fields)


def _has_replace(model: Type[BaseModel]) -> bool:
    return callable(getattr(model, "replace", None))


def _apply(instance: BaseModel, data: dict[str, Any]) -> BaseModel:
    cls = type(instance)
    if _has_replace(cls):
        filtered = {k: v for k, v in data.items() if v is not None}
        return instance.replace(**filtered)
    kwargs: dict[str, Any] = {}
    for name in _mutable_fields(cls):
        if name in data and data[name] is not None:
            kwargs[name] = data[name]
        else:
            kwargs[name] = getattr(instance, name)
    kwargs["id"] = instance.id
    for field_name in AUDIT_FIELDS:
        if field_name in cls.model_fields and field_name != "updated_at":
            kwargs[field_name] = getattr(instance, field_name, None)
    kwargs["updated_at"] = datetime.now(timezone.utc)
    return cls(**kwargs)


def _dict_backend():
    store: dict = {}
    return {
        "create": lambda _id, m: store.setdefault(_id, m) or m,
        "get": store.get,
        "list_all": lambda: list(store.values()),
        "update": lambda _id, m: store.update({_id: m}) or m,
        "delete": lambda _id: store.pop(_id, None) is not None,
    }


class ModelRouter:
    def __init__(
        self,
        model: Type[BaseModel],
        prefix: Optional[str] = None,
        tags: Optional[list[str]] = None,
    ):
        self.model = model
        name = model.__name__.lower()
        self.prefix = prefix or f"/{name}s"
        self.tags = tags or [model.__name__]

    def build(
        self,
        *,
        create: Callable[[str, BaseModel], BaseModel],
        get: Callable[[str], Optional[BaseModel]],
        list_all: Callable[[], list[BaseModel]],
        update: Callable[[str, BaseModel], BaseModel],
        delete: Callable[[str], bool],
    ) -> APIRouter:
        router = APIRouter(prefix=self.prefix, tags=self.tags)
        model = self.model
        create_schema = _build_create_schema(model, model.__name__)
        update_schema = _build_update_schema(model, model.__name__)

        @router.post("", response_model=model)
        def handle_create(body: create_schema):
            now = datetime.now(timezone.utc)
            kwargs = body.model_dump()
            kwargs["created_at"] = now
            kwargs["updated_at"] = now
            instance = model(**kwargs)
            return create(instance.id, instance)

        @router.get("")
        def handle_list():
            return list_all()

        @router.get("/{item_id}", response_model=model)
        def handle_get(item_id: str):
            instance = get(item_id)
            if instance is None:
                raise HTTPException(404, f"{model.__name__} not found")
            return instance

        @router.patch("/{item_id}", response_model=model)
        def handle_update(item_id: str, body: update_schema):
            instance = get(item_id)
            if instance is None:
                raise HTTPException(404, f"{model.__name__} not found")
            updated = _apply(instance, body.model_dump(exclude_none=True))
            return update(item_id, updated)

        @router.delete("/{item_id}")
        def handle_delete(item_id: str):
            if not delete(item_id):
                raise HTTPException(404, f"{model.__name__} not found")
            return {"ok": True}

        return router


class ProjectRouter:
    """Project 标准 CRUD 路由。"""

    prefix = "/projects"
    tags = ["项目"]

    @staticmethod
    def build(
        *,
        create: Callable[[str, Project], Project],
        get: Callable[[str], Optional[Project]],
        list_all: Callable[[], list[Project]],
        update: Callable[[str, Project], Project],
        delete: Callable[[str], bool],
    ) -> APIRouter:
        return ModelRouter(
            Project, prefix=ProjectRouter.prefix, tags=ProjectRouter.tags
        ).build(
            create=create,
            get=get,
            list_all=list_all,
            update=update,
            delete=delete,
        )

    @staticmethod
    def build_default() -> APIRouter:
        return ProjectRouter.build(**_dict_backend())


class TaskRouter:
    """Task 标准 CRUD 路由。"""

    prefix = "/tasks"
    tags = ["任务"]

    @staticmethod
    def build(
        *,
        create: Callable[[str, Task], Task],
        get: Callable[[str], Optional[Task]],
        list_all: Callable[[], list[Task]],
        update: Callable[[str, Task], Task],
        delete: Callable[[str], bool],
    ) -> APIRouter:
        return ModelRouter(Task, prefix=TaskRouter.prefix, tags=TaskRouter.tags).build(
            create=create,
            get=get,
            list_all=list_all,
            update=update,
            delete=delete,
        )

    @staticmethod
    def build_default() -> APIRouter:
        return TaskRouter.build(**_dict_backend())
