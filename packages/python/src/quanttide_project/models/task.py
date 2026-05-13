from datetime import datetime
from typing import Any, Optional

from pydantic import BaseModel, ConfigDict, field_serializer, field_validator


class Task(BaseModel):
    model_config = ConfigDict(frozen=True, populate_by_name=True)

    id: str
    title: str
    description: str = ""

    type: Optional[str] = None
    category: Optional[str] = None
    tags: dict[str, str] = {}

    status: Optional[str] = None
    priority: Optional[str] = None

    assigner: Optional[str] = None
    assignee: Optional[str] = None

    start_at: Optional[datetime] = None
    end_at: Optional[datetime] = None

    created_by: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_by: Optional[str] = None
    updated_at: Optional[datetime] = None

    @field_validator("tags", mode="before")
    @classmethod
    def coerce_tags(cls, v: Any) -> dict[str, str]:
        if v is None:
            return {}
        if isinstance(v, dict):
            return {str(k): str(v) for k, v in v.items()}
        return {}

    @field_serializer("start_at", "end_at", "created_at", "updated_at")
    def serialize_datetime(self, v: Optional[datetime]) -> Optional[str]:
        if v is None:
            return None
        return v.isoformat()

    def to_dict(self) -> dict[str, Any]:
        d = self.model_dump(mode="json", exclude_none=True)
        if "tags" in d and not d["tags"]:
            del d["tags"]
        return d

    def replace(
        self,
        *,
        type: Optional[str] = None,
        category: Optional[str] = None,
        status: Optional[str] = None,
        priority: Optional[str] = None,
        assigner: Optional[str] = None,
        assignee: Optional[str] = None,
        start_at: Optional[datetime] = None,
        end_at: Optional[datetime] = None,
    ) -> "Task":
        return Task(
            id=self.id,
            title=self.title,
            description=self.description,
            type=type if type is not None else self.type,
            category=category if category is not None else self.category,
            tags=self.tags,
            status=status if status is not None else self.status,
            priority=priority if priority is not None else self.priority,
            assigner=assigner if assigner is not None else self.assigner,
            assignee=assignee if assignee is not None else self.assignee,
            start_at=start_at if start_at is not None else self.start_at,
            end_at=end_at if end_at is not None else self.end_at,
            created_by=self.created_by,
            created_at=self.created_at,
            updated_by=self.updated_by,
            updated_at=self.updated_at,
        )
