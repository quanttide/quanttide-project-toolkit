from datetime import datetime
from typing import Any, Optional

from pydantic import BaseModel, ConfigDict, field_serializer


class Project(BaseModel):
    model_config = ConfigDict(frozen=True, populate_by_name=True)

    id: str
    name: str
    title: str
    description: str = ""

    created_by: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_by: Optional[str] = None
    updated_at: Optional[datetime] = None

    @field_serializer("created_at", "updated_at")
    def serialize_datetime(self, v: Optional[datetime]) -> Optional[str]:
        if v is None:
            return None
        return v.isoformat()

    def to_dict(self) -> dict[str, Any]:
        d = self.model_dump(mode="json", exclude_none=True)
        for key in ("created_at", "updated_at"):
            if key in d and d[key] is None:
                del d[key]
        return d
