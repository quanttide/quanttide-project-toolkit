from fastapi import FastAPI
from fastapi.testclient import TestClient
from quanttide_project import Project

from fastapi_quanttide_project import ProjectRouter, TaskRouter


class TestProjectRouter:
    def test_build_default(self):
        app = FastAPI()
        app.include_router(ProjectRouter.build_default())
        client = TestClient(app)

        resp = client.post("/projects", json={"id": "p1", "name": "n", "title": "T"})
        assert resp.status_code == 200
        assert resp.json()["title"] == "T"

        resp = client.get("/projects")
        assert len(resp.json()) == 1

        resp = client.patch("/projects/p1", json={"title": "New"})
        assert resp.json()["title"] == "New"

        resp = client.get("/projects/p1")
        assert resp.json()["title"] == "New"

        resp = client.delete("/projects/p1")
        assert resp.status_code == 200

        resp = client.get("/projects/p1")
        assert resp.status_code == 404

    def test_custom_storage(self):
        store: dict[str, Project] = {}
        router = ProjectRouter.build(
            create=lambda _id, p: store.setdefault(_id, p) or p,
            get=store.get,
            list_all=lambda: list(store.values()),
            update=lambda _id, p: store.update({_id: p}) or p,
            delete=lambda _id: store.pop(_id, None) is not None,
        )
        app = FastAPI()
        app.include_router(router)
        client = TestClient(app)

        client.post("/projects", json={"id": "p1", "name": "n", "title": "T"})
        assert "p1" in store


class TestTaskRouter:
    def test_build_default(self):
        app = FastAPI()
        app.include_router(TaskRouter.build_default())
        client = TestClient(app)

        resp = client.post(
            "/tasks", json={"id": "t1", "title": "Task", "status": "draft"}
        )
        assert resp.status_code == 200

        resp = client.patch("/tasks/t1", json={"status": "done"})
        assert resp.json()["status"] == "done"

        resp = client.delete("/tasks/t1")
        assert resp.status_code == 200

    def test_tags_and_prefix(self):
        assert ProjectRouter.prefix == "/projects"
        assert ProjectRouter.tags == ["项目"]
        assert TaskRouter.prefix == "/tasks"
        assert TaskRouter.tags == ["任务"]
