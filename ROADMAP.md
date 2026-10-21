# ROADMAP

现状核对（2026-10-21）：`packages/python` 与 `packages/fastapi` 均已有 `README.md`、`CHANGELOG.md`，两处文档项已成立；`packages/python/src/quanttide_project/models/task.py` 已有 `field_validator("tags", mode="before")` 与 datetime 的 `field_serializer`，故「Pydantic 自定义验证器」不再作为待办，若要新增须先写明校验哪个字段的什么规则。

## 文档与门禁

- [x] Python 包 `README.md`、`CHANGELOG.md`
- [x] FastAPI 包 `README.md`、`CHANGELOG.md`
- [ ] CI 配置（lint + test）。现状：`.github/workflows/` 只有 `deploy-docs.yml` 与五个 `publish-*`，没有 lint/test。达成标志：PR 上 `ruff`（或等价 lint）与 `pytest` 各跑一次，失败即阻断合并，Python 与 FastAPI 两个包都覆盖

## 未来增强

- [ ] 枚举类（`ProjectType`、`Status`、`Priority`）。现状：`type` / `status` / `priority` 三个字段在 Python 模型里都是 `Optional[str]`。达成标志：三处取值改为枚举并在 `to_dict` 序列化时取字符串值；跨语言（Dart / Flutter 包）取值名一致，给出样例 JSON 对照
- [ ] Rust SDK
