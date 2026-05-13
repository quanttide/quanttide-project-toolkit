from datetime import datetime, timezone

from quanttide_project.models.project import Project


class TestProjectConstructor:
    def test_required_only(self):
        p = Project(id="p1", name="test", title="Test")
        assert p.id == "p1"
        assert p.name == "test"
        assert p.title == "Test"
        assert p.description == ""
        assert p.created_by is None
        assert p.created_at is None
        assert p.updated_by is None
        assert p.updated_at is None

    def test_all_fields(self):
        dt = datetime(2026, 5, 13, tzinfo=timezone.utc)
        p = Project(
            id="p1",
            name="test",
            title="Test",
            description="desc",
            created_by="alice",
            created_at=dt,
            updated_by="bob",
            updated_at=dt,
        )
        assert p.description == "desc"
        assert p.created_by == "alice"
        assert p.created_at == dt
        assert p.updated_by == "bob"
        assert p.updated_at == dt


class TestProjectFromDict:
    def test_full(self):
        data = {
            "id": "p1",
            "name": "test",
            "title": "Test",
            "description": "desc",
            "created_by": "alice",
            "created_at": "2026-05-13T00:00:00+00:00",
            "updated_by": "bob",
            "updated_at": "2026-05-13T00:00:00+00:00",
        }
        p = Project.model_validate(data)
        assert p.id == "p1"
        assert p.created_at == datetime(2026, 5, 13, tzinfo=timezone.utc)

    def test_missing_optionals(self):
        data = {"id": "p1", "name": "test", "title": "Test"}
        p = Project.model_validate(data)
        assert p.description == ""
        assert p.created_by is None

    def test_datetime_object(self):
        dt = datetime(2026, 5, 13, tzinfo=timezone.utc)
        data = {"id": "p1", "name": "test", "title": "Test", "created_at": dt}
        p = Project.model_validate(data)
        assert p.created_at == dt


class TestProjectToDict:
    def test_all_fields(self):
        dt = datetime(2026, 5, 13, tzinfo=timezone.utc)
        p = Project(
            id="p1",
            name="test",
            title="Test",
            description="desc",
            created_by="alice",
            created_at=dt,
            updated_by="bob",
            updated_at=dt,
        )
        d = p.model_dump(mode="json")
        assert d["id"] == "p1"
        assert d["created_at"] == "2026-05-13T00:00:00+00:00"

    def test_null_optionals_omitted(self):
        p = Project(id="p1", name="test", title="Test")
        d = p.model_dump(mode="json", exclude_none=True)
        assert "created_by" not in d
        assert "created_at" not in d

    def test_to_dict(self):
        p = Project(id="p1", name="test", title="Test")
        d = p.to_dict()
        assert set(d.keys()) == {"id", "name", "title", "description"}

    def test_to_dict_with_optionals(self):
        dt = datetime(2026, 5, 13, tzinfo=timezone.utc)
        p = Project(
            id="p1", name="test", title="Test", description="desc", created_at=dt
        )
        d = p.to_dict()
        assert d["description"] == "desc"
        assert d["created_at"] == "2026-05-13T00:00:00+00:00"


class TestProjectRoundTrip:
    def test_round_trip(self):
        original = Project(id="p1", name="test", title="Test", description="desc")
        data = original.to_dict()
        restored = Project.model_validate(data)
        assert restored == original
