import json
from datetime import datetime
from pathlib import Path

from quanttide_project.models.project import Project
from quanttide_project.models.task import Task

ROOT = Path(__file__).parents[3] / "tests"
SCHEMAS = ROOT / "schemas"
FIXTURES = ROOT / "fixtures"


def _validate_schema(data: dict, schema: dict) -> list[str]:
    errors = []
    props = schema.get("properties", {})
    required = schema.get("required", [])

    for field in required:
        if field not in data or data[field] is None:
            errors.append(f"missing required field: {field}")

    for field, value in data.items():
        if field not in props:
            continue
        prop = props[field]
        ptype = prop.get("type")
        if ptype == "string" and not isinstance(value, str):
            errors.append(f"{field}: expected string, got {type(value).__name__}")
        if ptype == "object" and not isinstance(value, dict):
            errors.append(f"{field}: expected object, got {type(value).__name__}")
        if prop.get("format") == "date-time" and isinstance(value, str):
            try:
                datetime.fromisoformat(value.replace("Z", "+00:00"))
            except ValueError:
                errors.append(f"{field}: invalid datetime: {value}")

    return errors


class TestTaskContract:
    def test_fixture_conforms_to_schema(self):
        schema = json.loads((SCHEMAS / "task.json").read_text())
        fixture = json.loads((FIXTURES / "task.json").read_text())
        errors = _validate_schema(fixture, schema)
        assert errors == [], f"Schema validation errors: {errors}"

    def test_fixture_round_trip(self):
        fixture = json.loads((FIXTURES / "task.json").read_text())
        task = Task.model_validate(fixture)
        data = task.to_dict()
        restored = Task.model_validate(data)
        assert restored == task

    def test_model_serialization_conforms_to_schema(self):
        schema = json.loads((SCHEMAS / "task.json").read_text())
        task = Task(
            id="t1",
            title="Test",
            type="task",
            status="draft",
            start_at=datetime(2026, 5, 13),
            end_at=datetime(2026, 5, 13),
            created_by="alice",
            created_at=datetime(2026, 5, 13),
        )
        data = task.to_dict()
        errors = _validate_schema(data, schema)
        assert errors == [], f"Schema validation errors: {errors}"

    def test_minimal_task_conforms(self):
        schema = json.loads((SCHEMAS / "task.json").read_text())
        task = Task(id="t1", title="Minimal")
        data = task.to_dict()
        errors = _validate_schema(data, schema)
        assert errors == []


class TestProjectContract:
    def test_fixture_conforms_to_schema(self):
        schema = json.loads((SCHEMAS / "project.json").read_text())
        fixture = json.loads((FIXTURES / "project.json").read_text())
        errors = _validate_schema(fixture, schema)
        assert errors == [], f"Schema validation errors: {errors}"

    def test_fixture_round_trip(self):
        fixture = json.loads((FIXTURES / "project.json").read_text())
        project = Project.model_validate(fixture)
        data = project.to_dict()
        restored = Project.model_validate(data)
        assert restored == project

    def test_model_serialization_conforms_to_schema(self):
        schema = json.loads((SCHEMAS / "project.json").read_text())
        project = Project(
            id="p1",
            name="demo",
            title="Demo Project",
            created_by="alice",
            created_at=datetime(2026, 5, 13),
        )
        data = project.to_dict()
        errors = _validate_schema(data, schema)
        assert errors == [], f"Schema validation errors: {errors}"

    def test_minimal_project_conforms(self):
        schema = json.loads((SCHEMAS / "project.json").read_text())
        project = Project(id="p1", name="demo", title="Minimal")
        data = project.to_dict()
        errors = _validate_schema(data, schema)
        assert errors == []
