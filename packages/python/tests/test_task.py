from datetime import datetime, timezone

from quanttide_project.models.task import Task


class TestTaskConstructor:
    def test_required_only(self):
        t = Task(id="t1", title="Test")
        assert t.id == "t1"
        assert t.title == "Test"
        assert t.description == ""
        assert t.tags == {}
        assert t.type is None
        assert t.status is None

    def test_all_fields(self):
        dt = datetime(2026, 5, 13, tzinfo=timezone.utc)
        t = Task(
            id="t1",
            title="Test",
            description="desc",
            type="task",
            category="dev",
            tags={"env": "prod"},
            status="in_progress",
            priority="high",
            assigner="alice",
            assignee="bob",
            start_at=dt,
            end_at=dt,
            created_by="alice",
            created_at=dt,
            updated_by="bob",
            updated_at=dt,
        )
        assert t.description == "desc"
        assert t.type == "task"
        assert t.tags == {"env": "prod"}
        assert t.start_at == dt


class TestTaskFromDict:
    def test_full(self):
        data = {
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
            "start_at": "2026-05-13T00:00:00+00:00",
            "end_at": "2026-05-13T00:00:00+00:00",
            "created_by": "alice",
            "created_at": "2026-05-13T00:00:00+00:00",
            "updated_by": "bob",
            "updated_at": "2026-05-13T00:00:00+00:00",
        }
        t = Task.model_validate(data)
        assert t.id == "t1"
        assert t.tags == {"env": "prod"}
        assert t.start_at == datetime(2026, 5, 13, tzinfo=timezone.utc)

    def test_missing_optionals(self):
        data = {"id": "t1", "title": "Test"}
        t = Task.model_validate(data)
        assert t.description == ""
        assert t.tags == {}
        assert t.type is None
        assert t.status is None

    def test_non_dict_tags(self):
        data = {"id": "t1", "title": "Test", "tags": None}
        t = Task.model_validate(data)
        assert t.tags == {}

    def test_null_datetimes(self):
        data = {"id": "t1", "title": "Test", "start_at": None, "end_at": None}
        t = Task.model_validate(data)
        assert t.start_at is None
        assert t.end_at is None

    def test_datetime_object(self):
        dt = datetime(2026, 5, 13, tzinfo=timezone.utc)
        data = {"id": "t1", "title": "Test", "start_at": dt}
        t = Task.model_validate(data)
        assert t.start_at == dt


class TestTaskToDict:
    def test_all_fields(self):
        dt = datetime(2026, 5, 13, tzinfo=timezone.utc)
        t = Task(
            id="t1",
            title="Test",
            description="desc",
            type="task",
            tags={"env": "prod"},
            status="in_progress",
            priority="high",
            assigner="alice",
            assignee="bob",
            start_at=dt,
            end_at=dt,
        )
        d = t.to_dict()
        assert d["id"] == "t1"
        assert d["type"] == "task"
        assert d["start_at"] == "2026-05-13T00:00:00+00:00"

    def test_null_optionals_omitted(self):
        t = Task(id="t1", title="Test")
        d = t.to_dict()
        assert "type" not in d
        assert "status" not in d
        assert "tags" not in d

    def test_empty_tags_omitted(self):
        t = Task(id="t1", title="Test", tags={})
        d = t.to_dict()
        assert "tags" not in d


class TestTaskReplace:
    def test_single_field(self):
        t = Task(id="t1", title="Test", status="draft")
        updated = t.replace(status="in_progress")
        assert updated.status == "in_progress"
        assert updated.id == "t1"
        assert updated.title == "Test"

    def test_multiple_fields(self):
        t = Task(id="t1", title="Test")
        updated = t.replace(status="done", priority="high", assignee="bob")
        assert updated.status == "done"
        assert updated.priority == "high"
        assert updated.assignee == "bob"

    def test_no_args(self):
        t = Task(id="t1", title="Test", status="draft")
        updated = t.replace()
        assert updated == t

    def test_identity_immutable(self):
        t = Task(id="t1", title="Test")
        updated = t.replace(status="done")
        assert t.status is None
        assert updated.status == "done"
        assert t is not updated


class TestTaskRoundTrip:
    def test_round_trip(self):
        original = Task(id="t1", title="Test", type="task", status="draft")
        data = original.to_dict()
        restored = Task.model_validate(data)
        assert restored == original
