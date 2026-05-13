# ROADMAP

目标：参考 `packages/dart`，用 Python 实现等价包 `packages/python`，提供 `Project`、`Task` 数据模型及 JSON 序列化能力。

## 阶段

### 一、脚手架

- [ ] `uv init` 创建 `packages/python/`
- [ ] 添加依赖 `pydantic`，开发依赖 `pytest` `pytest-cov` `ruff`
- [ ] `.gitignore` `LICENSE` `README.md`

### 二、Project 模型（实现 + 测试）

- [ ] `Project(BaseModel)` — `id`, `name`, `title`, `description`, 审计字段
- [ ] 测试：构造、序列化、反序列化、往返

### 三、Task 模型（实现 + 测试）

- [ ] `Task(BaseModel)` — 全部字段（标识、分类、状态、上下文、计划、审计）
- [ ] `Task.replace()` — 等效 Dart `copyWith`
- [ ] 测试：构造、序列化、反序列化、`replace`、往返

### 四、文档与 CI

- [ ] `README.md` 使用示例
- [ ] `CHANGELOG.md` v0.1.0
- [ ] CI 配置（lint + test）

### 五、未来增强

- [ ] 枚举类（`ProjectType`、`Status`、`Priority`）
- [ ] 自定义验证器
