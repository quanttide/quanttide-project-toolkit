import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient
from quanttide_project import Project, Task

from fastapi_quanttide_project import ModelRouter


def build_project_router():
    store: dict[str, Project] = {}
    return ModelRouter(Project).build(
        create=lambda _id, p: store.setdefault(_id, p) or p,
        get=store.get,
        list_all=lambda: list(store.values()),
        update=lambda _id, p: store.update({_id: p}) or p,
        delete=lambda _id: store.pop(_id, None) is not None,
    )


def build_task_router():
    store: dict[str, Task] = {}
    return ModelRouter(Task).build(
        create=lambda _id, t: store.setdefault(_id, t) or t,
        get=store.get,
        list_all=lambda: list(store.values()),
        update=lambda _id, t: store.update({_id: t}) or t,
        delete=lambda _id: store.pop(_id, None) is not None,
    )


@pytest.fixture
def client():
    app = FastAPI()
    app.include_router(build_project_router())
    app.include_router(build_task_router())
    return TestClient(app)


class TestProjectCRUD:
    def test_create(self, client):
        resp = client.post(
            "/projects",
            json={
                "id": "p1",
                "name": "test",
                "title": "测试项目",
            },
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["id"] == "p1"
        assert data["name"] == "test"
        assert data["title"] == "测试项目"
        assert data["description"] == ""
        assert data["created_at"] is not None
        assert data["updated_at"] is not None

    def test_create_with_all_fields(self, client):
        resp = client.post(
            "/projects",
            json={
                "id": "p2",
                "name": "full",
                "title": "完整项目",
                "description": "desc",
                "created_by": "alice",
            },
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["description"] == "desc"
        assert data["created_by"] == "alice"

    def test_list(self, client):
        client.post("/projects", json={"id": "p1", "name": "a", "title": "A"})
        client.post("/projects", json={"id": "p2", "name": "b", "title": "B"})
        resp = client.get("/projects")
        assert resp.status_code == 200
        assert len(resp.json()) == 2

    def test_get(self, client):
        client.post("/projects", json={"id": "p1", "name": "t", "title": "T"})
        resp = client.get("/projects/p1")
        assert resp.status_code == 200
        assert resp.json()["id"] == "p1"

    def test_get_not_found(self, client):
        resp = client.get("/projects/none")
        assert resp.status_code == 404

    def test_update(self, client):
        client.post("/projects", json={"id": "p1", "name": "old", "title": "Old"})
        resp = client.patch("/projects/p1", json={"title": "New"})
        assert resp.status_code == 200
        assert resp.json()["title"] == "New"
        assert resp.json()["name"] == "old"

    def test_update_not_found(self, client):
        resp = client.patch("/projects/none", json={"title": "X"})
        assert resp.status_code == 404

    def test_delete(self, client):
        client.post("/projects", json={"id": "p1", "name": "t", "title": "T"})
        resp = client.delete("/projects/p1")
        assert resp.status_code == 200
        assert client.get("/projects/p1").status_code == 404

    def test_delete_not_found(self, client):
        resp = client.delete("/projects/none")
        assert resp.status_code == 404


class TestTaskCRUD:
    def test_create(self, client):
        resp = client.post(
            "/tasks",
            json={
                "id": "t1",
                "title": "测试任务",
            },
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["id"] == "t1"
        assert data["title"] == "测试任务"
        assert data["type"] is None
        assert data["status"] is None

    def test_create_with_all_fields(self, client):
        resp = client.post(
            "/tasks",
            json={
                "id": "t2",
                "title": "完整任务",
                "type": "task",
                "category": "dev",
                "tags": {"env": "prod"},
                "status": "in_progress",
                "priority": "high",
            },
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["type"] == "task"
        assert data["tags"] == {"env": "prod"}
        assert data["priority"] == "high"

    def test_list(self, client):
        client.post("/tasks", json={"id": "t1", "title": "A"})
        client.post("/tasks", json={"id": "t2", "title": "B"})
        resp = client.get("/tasks")
        assert resp.status_code == 200
        assert len(resp.json()) == 2

    def test_update_uses_replace(self, client):
        client.post("/tasks", json={"id": "t1", "title": "Old", "status": "draft"})
        resp = client.patch("/tasks/t1", json={"status": "done"})
        assert resp.status_code == 200
        data = resp.json()
        assert data["status"] == "done"
        assert data["title"] == "Old"

    def test_delete(self, client):
        client.post("/tasks", json={"id": "t1", "title": "T"})
        resp = client.delete("/tasks/t1")
        assert resp.status_code == 200
        assert client.get("/tasks/t1").status_code == 404
