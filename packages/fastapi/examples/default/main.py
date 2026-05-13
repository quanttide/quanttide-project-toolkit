from fastapi import FastAPI

from fastapi_quanttide_project import ProjectRouter, TaskRouter

app = FastAPI(title="QuantTide Projects API", version="0.1.0")

app.include_router(ProjectRouter.build_default())
app.include_router(TaskRouter.build_default())
