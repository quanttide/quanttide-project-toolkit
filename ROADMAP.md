# ROADMAP


### 文档完善

- [ ] Python 包 `README.md`、`CHANGELOG.md`
- [ ] FastAPI 包 `README.md`、`CHANGELOG.md`
- [ ] CI 配置（lint + test）

### 跨语言契约测试

- [x] 创建共享 JSON Schema（`tests/schemas/task.json`、`project.json`）
- [x] 创建共享 JSON Fixture（`tests/fixtures/task.json`、`project.json`）
- [x] Python 侧契约测试（`packages/python/tests/test_contract.py`）
- [x] Dart 侧契约测试（`packages/dart/test/contract_test.dart`）
- [ ] CI 集成契约测试

### 未来增强

- [ ] 枚举类（`ProjectType`、`Status`、`Priority`）
- [ ] Pydantic 自定义验证器
- [ ] Rust SDK
