# ROADMAP


### 文档完善

- [ ] Python 包 `README.md`、`CHANGELOG.md`
- [ ] FastAPI 包 `README.md`、`CHANGELOG.md`
- [ ] CI 配置（lint + test）

### 跨语言契约测试

- [ ] 创建共享 JSON Fixture（`tests/fixtures/task.json`、`project.json`）
- [ ] Python 侧交叉验证测试（`tests/test_contract.py`）
- [ ] CI 集成契约测试
- [ ] 生成 JSON Schema 作为正式契约

### 未来增强

- [ ] 枚举类（`ProjectType`、`Status`、`Priority`）
- [ ] Pydantic 自定义验证器
- [ ] Rust SDK
