# AGENTS — fastapi

## 开发注意事项

- JSON I/O 使用 camelCase（`createdAt`），Python 代码保持 snake_case（`created_at`），通过 `CamelCaseModel` 和 `response_model_by_alias=True` 实现
- 改 `pyproject.toml` 版本号后必须跑 `uv lock`，否则 lock 文件与 pyproject 不一致
- `ModelRouter` 自动推导 Create/Update/Response Schema，新增字段无需改 router 代码
